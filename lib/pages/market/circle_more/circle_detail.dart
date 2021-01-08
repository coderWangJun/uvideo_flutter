import 'package:chewie/chewie.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/pages/market/add_market/market_edit.dart';
import 'package:youpinapp/pages/market/circle_home.dart';
import 'package:youpinapp/pages/market/circle_members.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/uiUtil.dart';
import 'package:youpinapp/widgets/empty_widget.dart';

class CircleDetailProvider extends ChangeNotifier{
  ///懂得都懂，不懂的说了也不懂，你也别问，
  ///利益牵扯太大，说了对你们没好处，我只能说水很深，
  ///网上的资料都删了，所以我只能说懂得，都懂，不懂也没办法";

  String showTitle = "申请加入";
  Color colorButton = UiUtil.getColor(75,num1: 152,num2: 244);

  bool isFlag = false;
  bool isQc = true;
  final num personNum = 3;
  num marketId = 0;

  bool isMineCircle = false;
  Map dataCircle = {};
  List circlePerson = [];
  init(num id){
    marketId = id;
    DioUtil.request("/market/getMarketCircleDetails",parameters: {"id":id}).then((value){
      if(DioUtil.checkRequestResult(value)){
        if(value['data']!=null){
          dataCircle = value['data'];
          isFlag = (dataCircle['isJoined']??=false) as bool;
          if(isFlag && !isMineCircle) {showTitle = "退圈";}
          DioUtil.request("/market/getCircleUser",parameters: {"marketCircleId":id,"current":1,"size":personNum}).then((value){
            if(DioUtil.checkRequestResult(value)){
              if(value['data']!=null){
                circlePerson = value['data'];
                if(circlePerson[0]['userid'] == g_accountManager.currentUser.id){
                  isMineCircle = true;showTitle = "解散";}
              }
                notifyListeners();
            }
          });
        }
      }else{
        isQc = false;
        notifyListeners();
      }
    });
  }

  addIntoMarketCircle(){
    if(isMineCircle){
      DioUtil.request("/market/disbandMarketCircle",parameters: {"marketCircleId":marketId}).then((value){
        if(DioUtil.checkRequestResult(value,showToast: true)){
          Get.back(result: 1);
        }
      });
    }else{
      if(!isFlag){
          DioUtil.request("/market/addMarketCircleApplication",parameters: {"circleId":marketId},).then((value){
            if(DioUtil.checkRequestResult(value,showToast: true)){
              showTitle = "已申请";
              colorButton = UiUtil.getColor(238);
              notifyListeners();
            }
          });
      }else{
        DioUtil.request("/market/exitMarketCircle",parameters: {"circleId":marketId}).then((value){
          if(DioUtil.checkRequestResult(value,showToast: true)){
            showTitle = "申请加入";
            notifyListeners();
          }
        });
      }
    }
  }

}
class CircleDetail extends StatefulWidget{
  num id;
  CircleDetail(this.id);

  @override
  _CircleDetailState createState() => _CircleDetailState(id);
}
class _CircleDetailState extends State<CircleDetail>{

  num id;
  _CircleDetailState(this.id);

  VideoPlayerController _controller;
  ChewieController _chewieController;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: CircleDetailProvider(),
      onReady: (model){
        model.init(id);
        },
      onDispose: (model){},
      builder: (context,model,child){
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: UiUtil.getAppBar("圈资料",
              actionsListWidget: model.isMineCircle?[
                GestureDetector(behavior: HitTestBehavior.opaque,child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_modify_white.png'),color: UiUtil.getColor(102),width: 15.0,height: 15.0,fit: BoxFit.cover,),
                    SizedBox(width: 5.0,),
                    Text("编辑",style: UiUtil.getTextStyle(102, 15.0),),
                    SizedBox(width: 10.0,),
                  ],),onTap: (){
                  //编辑
                  playStop();
                  Get.to(MarketEdit("", model.dataCircle['marketTypeId'] as num,mFlagIsAdd: false,marketId: id,)).then((value){
                    if(value!=null){
                      model.init(id);
                    }
                  });
                },)
              ]:[SizedBox.shrink()],
          ),
          body:model.isQc?_getBody(context,model):EmptyWidget(showTitle: "该圈子因为某些原因找不了啦",),
        );
      },
    );
  }
  
  Widget _getBody(BuildContext context,CircleDetailProvider model){
    int i = 0;
    return model.dataCircle.length>0?Container(width: double.infinity,height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
      child: Column(
        children: <Widget>[
          Expanded(child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[
              model.dataCircle['worksUrl']!=""&&model.dataCircle['worksUrl']!=null?
//                  _buildVideo(model.dataCircle['worksUrl'] as String)
              _buildImage(model.dataCircle['worksUrl'] as String,context):SizedBox.shrink(),
              SizedBox(height: 20.0,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        UiUtil.getHeadImage(model.dataCircle['logoUrl']??=ImProvider.DEF_HEAD_IMAGE_URL, 60.0),
                        SizedBox(width: 10.0,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(model.dataCircle['circleName']??="",style: UiUtil.getTextStyle(52, 20.0,isBold: true),),
                            Text.rich(
                              TextSpan(children: [
                                TextSpan(text: "关注: ",style: UiUtil.getTextStyle(154, 13.0,isBold: true)),
                                TextSpan(text: "${model.dataCircle['countOfPeople']??=0}",style: UiUtil.getTextStyle(0, 13.0,isBold: true,c: UiUtil.getColor(76,num1: 152,num2: 244))),
                                TextSpan(text: "     帖子: ",style: UiUtil.getTextStyle(154, 13.0,isBold: true)),
                                TextSpan(text: "${model.dataCircle['countOfMarket']??=0}",style: UiUtil.getTextStyle(0, 13.0,isBold: true,c: UiUtil.getColor(76,num1: 152,num2: 244)))
                              ]),
                            ),
                            SizedBox(width: 20.0,),
                          ],
                        )
                      ],
                    ),
                    Row(children: <Widget>[
                      model.dataCircle['cityName']!=null&&model.dataCircle['cityName']!=""?Image.asset(join(AssetsUtil.assetsDirectoryChat, 'icon_chat_lolcation.png'),):SizedBox.shrink(),
                      SizedBox(width: 2.0,),
                      Text(model.dataCircle['cityName']??="",style: UiUtil.getTextStyle(154, 13.0),),
                    ],)
                  ],),
                  SizedBox(height: 18.0,),
                  Text("本圈简介",style: UiUtil.getTextStyle(52, 15.0),),
                  SizedBox(height: 10.0,),
                  Text("创建时间:  ${(model.dataCircle['createdTime'] as String).substring(0,10)}",style: UiUtil.getTextStyle(154, 13.0),),
                  SizedBox(height: 10.0,),
                  Text("${model.dataCircle['shortContent']??=model.dataCircle['content']??=""}",style: UiUtil.getTextStyle(52, 13.0),softWrap: true,),
                  SizedBox(height: 24.0,),
                  Text.rich(TextSpan(children: [
                    TextSpan(text: "本圈成员",style: UiUtil.getTextStyle(52, 15.0)),
//                    TextSpan(text: "本圈成员  (",style: UiUtil.getTextStyle(52, 15.0)),
//                    TextSpan(text:"70",style: UiUtil.getTextStyle(0, 15.0,c: UiUtil.getColor(76,num1: 152,num2: 244))),
//                    TextSpan(text: "/405)",style: UiUtil.getTextStyle(52, 15.0)),
                  ])),
                  SizedBox(height: 20.0,),
                  Column(
                      children: model.circlePerson.length>0?
                      model.circlePerson.map((e){
                        bool isMineFlag = false;
                        if(i==0){isMineFlag = true;i++;}
                        return _getBodyItems(context, e,isMineFlag);
                      }).toList():[SizedBox.shrink()]),
                  model.circlePerson.length>=model.personNum?GestureDetector(behavior: HitTestBehavior.opaque,child:Center(child: Text("查看更多圈成员 >",style: UiUtil.getTextStyle(154, 13.0),),),
                    onTap: (){
                      //查看更多圈成员
                      playStop();
                      Get.to(CircleMembers(id));
                    },
                  ):SizedBox.shrink(),

              SizedBox(height: 20.0,),
            ],),
          )),

          Container(width: double.infinity,height: 70.0,
            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(behavior: HitTestBehavior.opaque,child: UiUtil.getContainer(36.0, 15.0,
                    UiUtil.getColor(76,num1:152,num2: 244),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(join(AssetsUtil.assetsDirectoryMarket,"qz.png"),width: 17.0,height: 17.0,fit: BoxFit.cover,),
                        SizedBox(width: 10.0,),
                        Text("进入圈集",style: UiUtil.getTextStyle(255, 17.0,isBold: true),),
                      ],
                    ),mWidth:150.0),onTap: (){
                  //进入圈集
                  playStop();
                  Get.to(CircleHome(id,model.dataCircle['id'] as int));
                },),

                GestureDetector(child: UiUtil.getContainer(36.0, 15.0,
                    model.colorButton,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(join(AssetsUtil.assetsDirectoryMarket,"fx.png"),width: 17.0,height: 17.0,fit: BoxFit.cover,),
                        SizedBox(width: 10.0,),
                        Text(model.showTitle,style: UiUtil.getTextStyle(255, 17.0,isBold: true),),
                      ],
                    ),mWidth: 150.0),onTap: (){
                  if(model.isMineCircle){
                    showDialog(
                        context: context,
                        builder: (_){
                          return UiUtil.getOkButtonCon(MediaQuery.of(context).size.width-100.0, 120.0, "你确定要解散吗",
                                  () {Get.back(result: true);},
                                  () {Get.back(result: false);});
                        }
                    ).then((value){
                      if(value!=null){if(value){model.addIntoMarketCircle();}}
                    });
                  }else{
                    model.addIntoMarketCircle();
                  }
                },),


              ],
            ),)
        ],
      ),
    ):SizedBox.shrink();
  }

  Widget _getBodyItems(BuildContext context,Map map,bool isMine){
    return Column(children: <Widget>[Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: <Widget>[
      Row(children: <Widget>[
        UiUtil.getHeadImage(map['headPortraitUrl']??=ImProvider.DEF_HEAD_IMAGE_URL, 50.0),
        SizedBox(width: 17.0,),
        Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: <Widget>[
          Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.start,children: <Widget>[
            Text(map['name']??="",style: UiUtil.getTextStyle(52, 15.0),),
            SizedBox(width: 10.0,),
            isMine?UiUtil.getContainer(16.0, 8.0, UiUtil.getColor(76,num1: 152,num2: 244), Text("圈主",style: UiUtil.getTextStyle(255, 10.0),),constraints: BoxConstraints(minWidth: 35.0)):SizedBox.shrink(),
          ],),
          Text.rich(TextSpan(children: [
            TextSpan(text: map['companyName']??=""),
            TextSpan(text: map['companyName']==""?"":"·"),
            TextSpan(text: map['companyJob']??=""),
          ],style: UiUtil.getTextStyle(154, 13.0)))
        ],),
      ],),
      Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,crossAxisAlignment: CrossAxisAlignment.end,children: <Widget>[
        Text(map['memberLevel']??="Lv1",style: UiUtil.getTextStyle(0, 12.0,c: UiUtil.getColor(76,num1: 152,num2: 244)),),
        Text(map['distanceString']??='',style: UiUtil.getTextStyle(154, 12.0),)
      ],)
    ],),SizedBox(height: 20.0,)]);
  }


  Widget _buildVideo(String videoUrl) {
    _controller = VideoPlayerController.network(videoUrl);
    _chewieController = ChewieController(
        videoPlayerController: _controller,
//        aspectRatio: 16/9,
        autoPlay: true,
        looping: true
    );
    return Center(child: Chewie(
      controller: _chewieController,
    ));
  }

  Widget _buildImage(String imageUrl,BuildContext context){
    return Center(child:UiUtil.getHeadImage(imageUrl, MediaQuery.of(context).size.width-50.0,
    isOval: false,mHeight: 200.0));
  }


  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    if(_controller!=null){_controller.dispose();}
    if(_chewieController!=null){_chewieController.dispose();}
    super.dispose();
  }

  void playStop(){
    if(_chewieController!=null){_chewieController.pause();}
  }

}