import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/market_post_model.dart';
import 'package:youpinapp/pages/chat/chat_message_top/chat_message_huifu.dart';
import 'package:youpinapp/pages/market/market_list_detail.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dataTime_string.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/widgets/empty_widget.dart';


class ChatMessageTopProvide extends ChangeNotifier{

  int nowPage = 1;
  int pageSize = 10;
  bool isHasNextFlag = true;
  bool isLoading = false;
  List mData = [];
  Widget emp = SizedBox.shrink();
  init(bool bo){
    if(isHasNextFlag && !isLoading){
      isLoading = true;
      String uri;
      Map params = {"current":nowPage,"size":pageSize};
      if(bo){//点赞页
        uri = "/market/queryMarketLiked";
      }else{//@我的页
        uri = "/market/getMarketList";
        params['queryAtMe'] = 1;
      }
      DioUtil.request(uri,parameters: params).then((value){if(DioUtil.checkRequestResult(value)){if(value['data']!=null){
          if((value['data'] as List).length<pageSize){isHasNextFlag = false;}
          mData.addAll(value['data'] as List);
          nowPage++;
          notifyListeners();
          isLoading = false;
        }else{
        isHasNextFlag = false;
        emp = EmptyWidget(showTitle: "空空如也",);
        notifyListeners();
      }}else{
        emp = EmptyWidget(showTitle: "空空如也",);
        notifyListeners();
      }});
    }
  }
}

class ChatMessageTop extends StatefulWidget {

  bool switchFlag = true;
  ChatMessageTop(this.switchFlag);

  @override
  _ChatMessageTopState createState() => _ChatMessageTopState();
}

class _ChatMessageTopState extends State<ChatMessageTop> {


  ScrollController scrollController = new ScrollController();
  String name;

  @override
  void initState() {
    super.initState();
    if(g_accountManager.currentUser.typeId==1){
      name = g_accountManager.currentUser.userData.realname;
    }else{
      name = g_accountManager.currentUser.companyData.username;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseView(
      model: ChatMessageTopProvide(),
      onReady: (model){
        model.init(widget.switchFlag);
        scrollController.addListener(() {
          if(scrollController.position.pixels>=scrollController.position.maxScrollExtent){
            model.init(widget.switchFlag);
          }
        });
        },
      onDispose: (model){},
      builder: (context,model,child){
        return Scaffold(
        appBar: PreferredSize(preferredSize: Size(double.infinity, 44.0),child:
            AppBar(backgroundColor: Colors.white,elevation: 0,centerTitle: true,brightness: Brightness.light,
                leading: IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon,"nav_back_black.png")),onPressed: (){
                  Navigator.of(context)..pop();
                },),
                title: Text(widget.switchFlag?"点赞":"@我的",style: TextStyle(
                  color: Color.fromRGBO(51, 51, 51, 1),fontWeight: FontWeight.bold,fontSize: 17.0
                ),),
//                actions: <Widget>[
//                  IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryChat,"2508.png")),onPressed: (){
//                    print("右上角的框框");
//                  },),
//                  SizedBox(width: 20.0,)
//                ],
            )
          ,),
        body:Column(children: <Widget>[Expanded(child: _buildMarketList(model),)],
    ));},);
  }

  // 集市列表
  Widget _buildMarketList(ChatMessageTopProvide model) {
    return model.mData.length>0?ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: model.mData.length,
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) {
        var rowData = model.mData[index];

        return GestureDetector(behavior: HitTestBehavior.opaque,child:Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildMarketListHead(rowData),
              _buildContent(rowData),
              _buildMarketCard(rowData)
            ],
          ),
        ),onTap: (){
        Get.to(MarketListDetail(new MarketPostModel(),{},marketId: widget.switchFlag?rowData['marketId'] as num:rowData['id'] as num,));
        });
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 5,
          color: Color.fromRGBO(238, 238, 238, 1),
        );
      },
    ):model.emp;
  }

  // 集市列表头部
  Widget _buildMarketListHead(rowData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
//            Image.asset(rowData['head']),
            Container(width: 45.0,height: 45.0,decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(widget.switchFlag?rowData['headPortrait']??=ImProvider.DEF_HEAD_IMAGE_URL:rowData['headPortraitUrl']??=ImProvider.DEF_HEAD_IMAGE_URL)),
                shape: BoxShape.circle
            ),),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(rowData['name']??='', style: TextStyle(fontSize: 15, color: ColorConstants.textColor51, fontWeight: FontWeight.w500)),
                  Text.rich(TextSpan(
                      children: [
                        TextSpan(text: '${DataTimeToString.toTextString(DateTime.parse(rowData['createdTime']))}   ${rowData['marketCircleName']!=null&&rowData['marketCircleName']!=""?"评论于":""}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color.fromRGBO(102, 102, 102, 1))),
                        TextSpan(text: '  ${rowData['marketCircleName']??=''}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: ColorConstants.themeColorBlue)),
                      ]
                  ))
                ],
              ),
            )
          ],
        ),
        widget.switchFlag?SizedBox.shrink():GestureDetector(behavior: HitTestBehavior.opaque,child:Container(
          width: 40,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color.fromRGBO(238, 238, 238, 1),
              borderRadius: BorderRadius.circular(5)
          ),
          child: Text('回复', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: ColorConstants.textColor51, fontFamily: 'HanSans')),
        ),onTap: (){
            Get.to(ChatMessageHuiFu(rowData['id'], rowData['belongTo'], rowData['marketId']));
          })
      ],
    );
  }

  // 文本内容
  Widget _buildContent(rowData) {
    String textString = "";
    if(widget.switchFlag){
      textString = "${rowData['name']??=''} 赞了一下你~";
    }else{
      (rowData['atUseridsList'] as List).forEach((element) {
        textString = textString + "@${element['atName']}  ";
      });
    }
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: Text(textString, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: ColorConstants.textColor51)),
    );
  }

  // 集市卡片
  Widget _buildMarketCard(rowData) {
    String cover;
    if(widget.switchFlag){
      cover = rowData['cover'];
    }else{
      cover = rowData['coverUrl'];
    }
    return Container(
      height: 90,
      decoration: BoxDecoration(
          color: Color.fromRGBO(238, 238, 238, 1),
          borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          cover!=null&&cover!=""?Container(width: 80.0,height: 90.0,
            child: Image.network(cover,fit: BoxFit.cover,),
          ):SizedBox.shrink(),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(rowData['content'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Color.fromRGBO(1, 1, 1, 1).withOpacity(0.5)),overflow: TextOverflow.ellipsis,maxLines: 3,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}