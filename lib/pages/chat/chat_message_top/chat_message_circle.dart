import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/pages/market/circle_more/circle_detail.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/uiUtil.dart';
import 'package:youpinapp/widgets/empty_widget.dart';

class ChatMessageCircleProvide extends ChangeNotifier{

  List<num> numCircleId = [];
  Map<num,Map> mDataMapTop = {};
  Map<num,List> mDataMap = {};

  String userID = "";
  
  init(){
    userID = g_accountManager.currentUser.id;
    DioUtil.request("/market/getMarketCircleApplication").then((value){
      if(DioUtil.checkRequestResult(value)){if(value['data']!=null){
        List mDatas = value['data'];
        mDatas.forEach((element) {
          num index = element['circleId'] as num;
          if(mDataMap[index] == null){
            numCircleId.add(index);
            mDataMapTop[index] = {};
            mDataMapTop[index]['waitNum']=0;
            mDataMapTop[index]['totalNum']=0;
            mDataMap[index] = [];
          }
            num sta = element['status'] as num;
            mDataMapTop[index]['totalNum']++;
            if(sta!=0){element['color'] = UiUtil.getColor(187);element['needDo'] = false;}
            else{element['color'] = UiUtil.getColor(75,num1: 151,num2: 243); mDataMapTop[index]['waitNum']++;element['needDo'] = true;}
            mDataMap[index].add(element);
        });
        notifyListeners();
      }}
    });
  }

  updateMarketCircle(String userId,num sta,num marketId,int position){
    DioUtil.request("/market/updateMarketCircleApplication",parameters: {
      "circleId":marketId,
      "userid":userId,
      "status":sta
    }).then((value){if(DioUtil.checkRequestResult(value)){
          mDataMap[marketId][position]['needDo'] = false;
          mDataMap[marketId][position]['status'] = sta;
          mDataMap[marketId][position]['color'] = UiUtil.getColor(187);
          mDataMapTop[marketId]['waitNum']--;
          notifyListeners();
      }});
  }

}

class ChatMessageCircle extends StatefulWidget{


  @override
  _ChatMessageCircleState createState() => _ChatMessageCircleState();
}
class _ChatMessageCircleState extends State<ChatMessageCircle>{

  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: ChatMessageCircleProvide(),
      onReady: (model){model.init();},
      onDispose: (model){},
      builder: (context,model,child){
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: UiUtil.getAppBar("圈集"),
          body: _getBody(context,model),
        );
      },
    );
  }


  Widget _getBody(BuildContext context,ChatMessageCircleProvide model){
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 30.0),
      child: model.numCircleId.length>0?Column(
        children: model.numCircleId.map((e){
          return _getIndexItem(e,model.mDataMap[e],model);
        }).toList(),
      ):EmptyWidget(showTitle:"暂时还没有你圈集的相关消息哦",mHeight:(MediaQuery.of(context).size.height-100.0),),
    );
  }

  Widget _getIndexItem(num index,List mList,ChatMessageCircleProvide model){
    List<Widget> mDataWidget = [];
    int position = -1;
    mList.forEach((el) {
      position = position + 1;
      Widget mWidget = Padding(padding:EdgeInsets.only(top: 10.0),child:_getItemUsers(model,context, el, null, null,position: position));
      mDataWidget.add(mWidget);
    });
    return Column(children: <Widget>[
      _getItemUsers(model,context, mList[0], () {
        //--->todo 点击整体
//        Get.to(CircleDetail(index,0));
        }, null,isBot: false,topMap:model.mDataMapTop[index]),
      Column(children: mDataWidget),
      SizedBox(height: 20.0,),
      Container(width: double.infinity,height: 2.0,color: Colors.grey,),
      SizedBox(height: 10.0,)
    ],);
  }

  Widget _getItemUsers(ChatMessageCircleProvide model,BuildContext context,Map e,GestureTapCallback onTapAll,GestureTapCallback onTaps,{bool isBot = true,Map topMap,int position = -1}){
    double pad;
    if(isBot){pad = 25.0;}else{pad = 3.0;}
    String mText = "";
    switch (e['status'] as num){
      case 0:mText="未处理";break;
      case 1:mText="已通过";break;
      case 2:mText="已拒绝";break;
      case 3:mText="已忽略";break;
    }
    return GestureDetector(behavior: HitTestBehavior.opaque,child:UiUtil.getUserItems(60.0, MediaQuery.of(context).size.width-pad*2,pad,
        UiUtil.getHeadImage(isBot?e['headPortraitUrl']??=ImProvider.DEF_HEAD_IMAGE_URL:e['circleLogoUrl']??=ImProvider.DEF_HEAD_IMAGE_URL,
            50.0,mBoxShadow: [BoxShadow(color: Colors.black54,offset: Offset(1.0, 1.0),blurRadius: 2.0)],),
        [Container(width: MediaQuery.of(context).size.width-300.0,child:Text("${isBot?e['name']??="":((e['circleName']??=""))}",style: UiUtil.getTextStyle(51, isBot?14.0:17.0,isBold: !isBot),overflow: TextOverflow.ellipsis,))],
        [],
      isBot?GestureDetector(child:

      (e['needDo']?Row(children: <Widget>[
        GestureDetector(behavior: HitTestBehavior.opaque,child:
        UiUtil.getContainer(32.0, 10.0, e['color'], Text("同意",style: UiUtil.getTextStyle(255, 13.0),),mWidth: 50.0),
          onTap: (){
            //--->todo 同意
            model.updateMarketCircle(e['userid'], 1, e['circleId'] as num,position);
          },),
        SizedBox(width: 20.0,),
        GestureDetector(behavior: HitTestBehavior.opaque,child:
        UiUtil.getContainer(32.0, 10.0, Colors.red, Text("拒绝",style: UiUtil.getTextStyle(255, 13.0),),mWidth: 50.0),
          onTap: (){
            //--->todo 拒绝
            model.updateMarketCircle(e['userid'], 2, e['circleId'] as num,position);
          },)
      ],)
          :
      UiUtil.getContainer(32.0, 10.0, e['color'], Text(mText,style: UiUtil.getTextStyle(255, 13.0),),mWidth: 60.0))

        ,onTap:onTaps,):
        Row(
          children: <Widget>[
            UiUtil.getContainer(15.0, 3.0, Colors.blue,
            Text.rich(TextSpan(children: [
              TextSpan(text: "  ${topMap['waitNum']}",style: UiUtil.getTextStyle(0, 12.0,c: Colors.amber,isBold: true)),
              TextSpan(text: "  / ${topMap['totalNum']}  ",style: UiUtil.getTextStyle(0, 12.0,c: Colors.white,isBold: true))
            ])),constraints: BoxConstraints(minWidth: 10.0),)
          ],
        )
      ,isHasBotBorder: !isBot),onTap: onTapAll);
  }


}