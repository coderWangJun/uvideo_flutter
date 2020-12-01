import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/app/web_socket.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/ring/ring_video_calling.dart';
import 'package:youpinapp/pages/ring/ring_yaoqing.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';

class RingVoiceCalling extends StatefulWidget {
  var msg;

  RingVoiceCalling(this.msg);

  @override
  _RingVideoCallingState createState() => _RingVideoCallingState();
}

class _RingVideoCallingState extends State<RingVoiceCalling> with TickerProviderStateMixin{

  //当前房间人数
  int numPerson = 1;


  ImProvider imPro;
  WebSocketProvide webSocket;
  String head;

  bool twoPersonTalking = false;

  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    if(widget.msg['headPortraitUrl'] as String != null && widget.msg['headPortraitUrl'] != ""){
      head = widget.msg['headPortraitUrl'] as String;
    }else{
      head = ImProvider.DEF_HEAD_IMAGE_URL;
    }
    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    _animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0,end: 900.0).animate(_animationController)..addListener(() {setState(() {

    });});
  }

  @override
  void dispose() {
    super.dispose();
    webSocket.twoPerson = twoPersonTalking;
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    imPro.flagIsOnRtcChat = false;
    _animationController.dispose();
  }

  void _initAgoraRtcEngine(){
    AgoraRtcEngine.create(ImProvider.AGO_ID);
    AgoraRtcEngine.enableAudio();
    AgoraRtcEngine.joinChannel(null, widget.msg['roomNo'] as String, null, 0);
  }

  ///回调监听
  void _addAgoraEventHandlers(){
    AgoraRtcEngine.onJoinChannelSuccess = (String channel,int uid,int elapsed){
      //加入成功
      print("==加入成功===============$uid");
    };
    AgoraRtcEngine.onError = (code){
      //SDK错误
      print("==SDK错误===============");
    };
    AgoraRtcEngine.onUserJoined = (int uid,int elapsed){
      //新用户加入
      print("==新人加入成功===============$uid");
      numPerson = 2;
      twoPersonTalking = true;
    };
    AgoraRtcEngine.onUserOffline = (int uid,int reason){
      //一个用户离开
      print("==离开了========$reason=======$uid");
      if(webSocket.flag){
        Get.back();
      }
      webSocket.flag = true;
    };
  }




  @override
  Widget build(BuildContext context) {
    imPro = Provider.of<ImProvider>(context);
    webSocket = Provider.of<WebSocketProvide>(context);
    webSocket.context = context;
    webSocket.startTime = DateTime.now();
    imPro.flagIsOnRtcChat = true;
    double containerHeight = MediaQuery.of(context).size.height*0.8;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(join(AssetsUtil.assetsDirectoryRing, 'bg_ring_index.png')),
            fit: BoxFit.cover
          )
        ),
        child: SafeArea(
          child: Stack(children: <Widget>[
            Column(
            children: <Widget>[
              _buildAppBar(),
              Expanded(
                child: _buildCenterWidget()
              ),
              _buildBottomWidget(context)
            ],
          ),
            _showMore(context,containerHeight)
          ],)
        ),
      ),
    );
  }

  Widget _showMore(BuildContext context,double containerHeight){
    double containerWidth = MediaQuery.of(context).size.width;
    return Positioned(bottom:0.0,child:Container(
      constraints: BoxConstraints(maxHeight: containerHeight),
      width: containerWidth,height: _animation.value,
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0))),
      child:SingleChildScrollView(physics:NeverScrollableScrollPhysics(),child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(width: containerWidth,height: 44.0,decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1)))
          ),child: Align(alignment: Alignment.centerRight,child: 
              IconButton(icon: Icon(Icons.close), onPressed: (){
                ///关闭
                _animationController.reverse();
              })
            ,),),
          
          Container(width: containerWidth,height: containerHeight-45.0,padding: EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
//              Container(width: containerWidth-36.0,height: 100.0,decoration: BoxDecoration(
//                border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1)))
//              ),child: Row(
//
//              ),)

              _buildJobRow(),
              Expanded(child:SingleChildScrollView(child:_buildJobDesc()))
            ],
          ),
          )
        ],
      ),))
    );
  }

  // 招聘岗位
  Widget _buildJobRow() {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1)))
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ///职位名称
                      Text('UI设计师', style: TextStyle(fontSize: 25, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
                      Row(
                        children: <Widget>[
                          Text('重庆', style: TextStyle(fontSize: 13, color: Color.fromRGBO(101, 101, 101, 1))),
                          Container(width: 0.5, height: 11, color: Color.fromRGBO(210, 210, 210, 1), margin: EdgeInsets.only(left: 14, right: 14)),
                          Text('1-3年', style: TextStyle(fontSize: 13, color: Color.fromRGBO(101, 101, 101, 1))),
                          Container(width: 0.5, height: 11, color: Color.fromRGBO(210, 210, 210, 1), margin: EdgeInsets.only(left: 14, right: 14)),
                          Text('本科', style: TextStyle(fontSize: 13, color: Color.fromRGBO(101, 101, 101, 1)))
                        ],
                      )
                    ],
                  ),
                ),
                Text('3-8K', style: TextStyle(fontSize: 20, color: ColorConstants.themeColorBlue, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 职位描述
  Widget _buildJobDesc() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('职位详情', style: TextStyle(fontSize: 17, color: ColorConstants.textColor51)),
              Text('2天前更新', style: TextStyle(fontSize: 13, color: Color.fromRGBO(101, 101, 101, 1)))
            ],
          ),
          SizedBox(height: 15),
          ///职位详情写死部分----：岗位职责+任职要求====
          Text('岗位职责：\n'
              '1、根据产品需求，对产品美术风格、交互设计、界面结构、操作流程等做出设计，并积极与开发沟通，推进界面及交互设计的最终实现。\n'
              '2、负责项目中各种交互界面、图标、logo、按钮等相关元素的设计与制作；\n'
              '3、负责软件界面的美术设计、创意工作和制作工作。\n'
              '4、根据各种相关软件的用户群，提出构思新颖、有高度吸引力的创意设计\n'
              '5、负责跟踪产品效果及用户体验，提出设计优化方案。\n'
              '6、根据公司品牌要求承担部分电商页面平面设计工作。\n',
            style: TextStyle(fontSize: 13, color: Color.fromRGBO(101, 101, 101, 1))),
          Text('任职要求：\n'
              '1、本科及以上学历，设计类相关专业。\n'
              '2、2年以上移动互联网UI设计工作经验，熟悉Wed、App设计规范；\n'
              '3、精通Photoshop、lIIustrator、CorelDraw等设计软件，\n'
              '4、有较高的审美意识、创新设计能力和团队合作意识。\n'
              '5、能切页面懂代码者（Html+CSS等）优先，具有App设计经验者优先。',
              style: TextStyle(fontSize: 13, color: Color.fromRGBO(101, 101, 101, 1))),
          ///职位详情（请求回传显示）
//          Text('${homeCompanyDetailedModel.jobDetails}', style: TextStyle(fontSize: 13, color: Color.fromRGBO(101, 101, 101, 1))),

        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[


          SizedBox(width: 10.0,)
          /*
          IconButton(
            icon: Image.asset(join(AssetsUtil.assetsDirectoryRing, 'btn_detail_info.png')),
            onPressed: () {
              _animationController.forward();
            },
          ),
          */

        ],
      ),
    );
  }

  Widget _buildCenterWidget() {
    return Container(
      padding: EdgeInsets.only(top: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipOval(child:Container(width: 50.0,height: 50.0,child:Image.network(head,fit: BoxFit.cover,))),
          Container(
            margin: EdgeInsets.only(top: 14, bottom: 8),
            child: Text.rich(TextSpan(
              children: [
                TextSpan(text:widget.msg['name'] as String, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                TextSpan(text: '     '),
                TextSpan(text:widget.msg['positionName'] as String, style: TextStyle(fontSize: 15, color: Colors.white)),
              ]
            )),
          ),
          Text(widget.msg['companyName']??="", style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.bold)),
          Container(
            margin: EdgeInsets.only(top: 40),
            width: 185,
            height: 115,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(widget.msg['positionName'] as String, style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
                Text(widget.msg['salary'] as String, style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.location_on, color: Colors.white),
                    SizedBox(width: 6),
                    Text(widget.msg['distance']==null?"":"距我${widget.msg['distance']}", style: TextStyle(fontSize: 13, color: Color.fromRGBO(208, 208, 208, 1)))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  bool muted = false;

  void _onCallEnd() async{
    if(twoPersonTalking){
      MsgNode mMsgNode = MsgNode(widget.msg['userid'], "-3", "end");
      webSocket.channel.sink.add(mMsgNode.toJson());
      webSocket.saveQZLUserData("0","");
    }else{
      MsgNode mMsgNode = MsgNode(widget.msg['userid'] as String, "-2", "");
      webSocket.channel.sink.add(mMsgNode.toJson());
      await webSocket.closes();
      Get.back();
    }
  }
  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  Widget _buildBottomWidget(BuildContext contexts) {
    return Container(
      height: 184,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
//          Text('通话中：00:00', style: TextStyle(fontSize: 13, color: Color.fromRGBO(208, 208, 208, 1))),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                iconSize: 35,
                icon: muted?
                Image.asset(join(AssetsUtil.assetsDirectoryHome, 'yyk.png')):
                Image.asset(join(AssetsUtil.assetsDirectoryRing, 'btn_voice_record.png')),
                onPressed: (){
                  _onToggleMute();
                },
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: IconButton(
                  iconSize: 60,
                  icon: Image.asset(join(AssetsUtil.assetsDirectoryRing, 'btn_hang_up.png')),
                  onPressed: (){
                    _onCallEnd();
                  },
                ),
              ),
              IconButton(
                iconSize: 35,
                icon: Image.asset(join(AssetsUtil.assetsDirectoryRing, 'btn_video_call.png')),
                onPressed: (){
                  if(numPerson!=2){
                    BotToast.showText(text: "对方未接听,不能发起视频通话");
                  }else{
                    String room = "${webSocket.roomId.hashCode}";
                    Get.off(RingYaoQing(room,false,uid: widget.msg['userid'] as String,));
                  }

//                  showDialog(context: contexts,builder: (BuildContext context){
//                    return AlertDialog(
//                    title:Text("确定要发送视频邀请吗"),
//                    actions: <Widget>[
//                      FlatButton(onPressed: (){
//                        Get.back();
//                      }, child: Text("取消"),),
//                      FlatButton(onPressed: () async{
//                        MsgNode msgNode = new MsgNode(widget.msg['userid'],"200","");
//                        webSocket.channel.sink.add(msgNode.toJson());
//                        if(await Permission.microphone.request().isGranted){
//                          Get.back();
//                          String room = (widget.msg['roomNo'] as String) + "video";
//                          Get.off(RingYaoQing(room,false));
//                        }else{
//                          Get.back();
//                          print("权限拒绝");
//                        }
//                      }, child: Text("确定"))
//                    ],
//                  );}
//                  );

                },
              )
            ],
          )
        ],
      ),
    );
  }

}