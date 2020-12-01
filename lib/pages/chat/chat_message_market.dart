import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/market_post_model.dart';
import 'package:youpinapp/pages/chat/chat_message_top/chat_message_circle.dart';
import 'package:youpinapp/pages/chat/chat_message_top/chat_message_huifu.dart';
import 'package:youpinapp/pages/chat/chat_message_top/chat_message_top.dart';
import 'package:youpinapp/pages/market/market_list_detail.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dataTime_string.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/widgets/empty_widget.dart';

class ChatMessageMarketProvide extends ChangeNotifier{
  List chatMessageMarketList = [];
  int currentPage = 1;

  bool isLoading = false;

  bool isHasNext = true;
  static final int PAGE_SIZE = 10;
  init(){
    if(isHasNext && !isLoading){
      isLoading = true;
      DioUtil.request("/market/getMarketComment",
          parameters: {'refMe':1,'current':currentPage,'size':PAGE_SIZE}).then((value){
            if(DioUtil.checkRequestResult(value)){if(value['data']!=null){
              if((value['data'] as List).length<PAGE_SIZE){
                isHasNext = false;
              }
              chatMessageMarketList.addAll(value['data'] as List);
              currentPage++;
              notifyListeners();
              isLoading = false;
            }else{
              isHasNext = false;
            }

            }});
      }
  }
}


class ChatMessageMarket extends StatefulWidget {
  @override
  _ChatMessageMarketState createState() => _ChatMessageMarketState();
}

class _ChatMessageMarketState extends State<ChatMessageMarket> {
  ScrollController controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: ChatMessageMarketProvide(),
      onReady: (model){
        model.init();
        controller.addListener(() {
          if(controller.position.pixels>=controller.position.maxScrollExtent){
            model.init();
          }
        });
        },
      onDispose: (model){},
      builder: (context,model,child){
        return SingleChildScrollView(physics: BouncingScrollPhysics(),controller: controller,child:Column(children: <Widget>[
              _buildAtRow(),
              _buildPraiseRow(),
              _buildQz(),
              Column(
                children: _buildMarketList(model),
              )],));
      },);
  }

  Widget _buildAtRow() {
    return GestureDetector(child:Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(join(AssetsUtil.assetsDirectoryChat, 'icon_chat_at.png')),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text('@我的', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ColorConstants.textColor51)))
            ],
          ),
          Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_forward_normal.png'))
        ],
      ),
    ),
      behavior: HitTestBehavior.opaque,
      onTap: (){
        Get.to(ChatMessageTop(false));
      },);
  }

  Widget _buildPraiseRow() {
    return GestureDetector(child:Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(join(AssetsUtil.assetsDirectoryChat, 'icon_chat_praise.png')),
              Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text('点赞', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ColorConstants.textColor51)))
            ],
          ),
          Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_forward_normal.png'))
        ],
      ),
    ),
      behavior: HitTestBehavior.opaque,
      onTap: (){
        Get.to(ChatMessageTop(true));
      },);
  }

  Widget _buildQz(){
    return GestureDetector(child:Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(join(AssetsUtil.assetsDirectoryHome, 'home_comment.png')),
              Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text('圈集', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ColorConstants.textColor51)))
            ],
          ),
          Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_forward_normal.png'))
        ],
      ),
    ),
      behavior: HitTestBehavior.opaque,
      onTap: (){
        Get.to(ChatMessageCircle());
      },);
  }

  // 集市列表
  List<Widget> _buildMarketList(ChatMessageMarketProvide model) {
    if(model.chatMessageMarketList.length>0){
      return model.chatMessageMarketList.map((rowData){
          return GestureDetector(behavior:HitTestBehavior.opaque,child:Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildMarketListHead(rowData),
                _buildContent(rowData),
                _buildMarketCard(rowData),
                Container(height: 5.0,color: Color.fromRGBO(238, 238, 238, 1),)
              ],
            ),
          ),onTap: (){
            Get.to(MarketListDetail(new MarketPostModel(),{},marketId: rowData['marketId'] as num,));
          },);
      }).toList();
    }else{
      return [EmptyWidget(showTitle: "暂时没有关于你的集市消息哦~",mHeight: 350.0,)];
    }
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
              image: DecorationImage(image: NetworkImage(rowData['headPortrait']??=ImProvider.DEF_HEAD_IMAGE_URL)),
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
        GestureDetector(behavior: HitTestBehavior.opaque,child:Container(
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
        },)
      ],
    );
  }

  // 文本内容
  Widget _buildContent(rowData) {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: Text(rowData['content'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: ColorConstants.textColor51)),
    );
  }

  // 集市卡片
  Widget _buildMarketCard(rowData) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Color.fromRGBO(238, 238, 238, 1),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          rowData['marketCover']!=null&&rowData['marketCover']!=""?Container(width: 80.0,height: 90.0,
            child: Image.network(rowData['marketCover'],fit: BoxFit.cover,),
          ):SizedBox.shrink(),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(rowData['marketContent'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Color.fromRGBO(1, 1, 1, 1).withOpacity(0.5)),overflow: TextOverflow.ellipsis,maxLines: 3,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}