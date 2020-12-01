import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/chat/chat_data.dart';
import 'package:youpinapp/pages/chat/chat_route/chat_route.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dataTime_string.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/widgets/empty_widget.dart';

class ChatMessageRing extends StatefulWidget {
  @override
  _ChatMessageRingState createState() => _ChatMessageRingState();
}
class _ChatMessageRingState extends State<ChatMessageRing> {


  bool isNotGeRen = true;

  @override
  void initState() {
    super.initState();
    if(g_accountManager.currentUser.typeId==1){
      isNotGeRen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: ChatMessageRingProvider(),
      onReady: (model){model.getPages();},
      onDispose: (model){},
      builder: (context,model,child){
        return getBody(context,model);
      },
    );
  }

  @override
  Widget getBody(BuildContext context,ChatMessageRingProvider model) {

    if(model.data.length>0){
    return ListView.builder(
        padding: EdgeInsets.only(left: 20, right: 20),
        itemCount: model.data.length,
        itemBuilder: (BuildContext context, int index) {
          var ro = model.data[index];
          List<String> mList = (ro['communication'] as String).split(",");
          var icon;
          if(mList[0]=="0"){icon = join(AssetsUtil.assetsDirectoryChat, 'icon_chat_tel.png');}
          else {icon = join(AssetsUtil.assetsDirectoryChat, 'icon_chat_camera.png');}

          DateTime timedif = DateTime.parse(ro['createdTime'] as String);
          String time = DataTimeToString.toTextString(timedif);
          return GestureDetector(behavior: HitTestBehavior.opaque,child:Container(
            padding: EdgeInsets.only(top: 12.5, bottom: 12.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipOval(child: Container(width:50.0,height:50.0,child: Image.network(isNotGeRen?ro['userHeadPortraitUrl']??=ImProvider.DEF_HEAD_IMAGE_URL:ro['companyUserHeadPortraitUrl']??=ImProvider.DEF_HEAD_IMAGE_URL,fit: BoxFit.cover,),),),
                SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(isNotGeRen?ro['userName']??="":ro['companyUserName']??="", style: TextStyle(fontSize: 15, color: ColorConstants.textColor51)),
                          SizedBox(width: 5),
                          Image.asset(join(AssetsUtil.assetsDirectoryChat, 'icon_chat_lolcation.png')),
                          Text(ro['distance']??="", style: TextStyle(fontSize: 12, color: Color.fromRGBO(153, 153, 153, 1))),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(isNotGeRen?ro['userPosition']??="":ro['companyUserPosition']??="", style: TextStyle(fontSize: 12, color: ColorConstants.textColor51)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(time, style: TextStyle(fontSize: 12, color: Color.fromRGBO(153, 153, 153, 1))),
                    Row(
                      children: <Widget>[
                        Image.asset(icon),
                        SizedBox(width: 5),
                        Text(mList[1]??="", style: TextStyle(fontSize: 12, color: Color.fromRGBO(153, 153, 153, 1)))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),onTap: (){
            Get.to(ChatRoute(isNotGeRen?ro['userTxUserid']:ro['companyUserTxUserid'],
                isNotGeRen? {'headPortraitUrl' : ro['userHeadPortraitUrl']??=ImProvider.DEF_HEAD_IMAGE_URL , 'name' : ro['userName']??="" , 'companyName' : ro['userPosition']??=""}:
                {'headPortraitUrl' : ro['companyUserHeadPortraitUrl']??=ImProvider.DEF_HEAD_IMAGE_URL , 'name' : ro['companyUserName']??="" , 'companyName' : ro['companyName']??=""}));
          },);
        }
    );
  }else{
      return EmptyWidget(showTitle: "暂时没有你的求职铃记录哦，快去匹配吧",);
    }
  }

}


class ChatMessageRingProvider extends ChangeNotifier{

  static final num pageSizes = 10;
  num pageNo = 1;
  bool isHasNextPage = true;
  List data = [];
  getPages(){
    if(isHasNextPage){
        DioUtil.request("/resume/getUserJobBellRecord",parameters: {'current':pageNo,'size':pageSizes}).then((value){
          if(DioUtil.checkRequestResult(value)){
            data = value['data'];
            notifyListeners();
            pageNo++;
          }else{
            isHasNextPage = false;
          }
        });
    }else{
      //没有下一页了
    }
  }
}