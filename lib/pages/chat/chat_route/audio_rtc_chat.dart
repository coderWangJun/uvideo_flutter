import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/pages/chat/chat_route/chat_route.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/event_bus.dart';

///传入房间号--->邀请方的sessionId,即邀请方的腾讯云会话ID
class AudioRtcChat extends StatefulWidget{

  ChatDomeProvider chatDomeProvider;
  String chatRoomId;
  String headimg = "";
  String name = "";
  AudioRtcChat(this.chatRoomId,this.headimg,this.name,{this.chatDomeProvider});
  @override
  _AudioRtcChatState createState() => _AudioRtcChatState();
}
class _AudioRtcChatState extends State<AudioRtcChat>{

  bool flagQX = false;
  bool showTextFlag = false;
  ImProvider imPro;

  @override
  void initState() {
    super.initState();
    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
  }

  @override
  Widget build(BuildContext context) {
    imPro = Provider.of<ImProvider>(context);
    imPro.flagIsOnRtcChat = true;
    return Scaffold(
      appBar: PreferredSize(child: AppBar(
        brightness: Brightness.light,
      ), preferredSize: Size(double.infinity, 0)),
      body:Stack(
        children: <Widget>[
          Container(child: Image.asset(join(AssetsUtil.assetsDirectoryChat,"bj.png"),fit: BoxFit.cover)),
          Container(
            padding: EdgeInsets.only(top: 100.0),
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(width: 80.0,height: 80.0,decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                ), child: ClipOval(child: Image.network(widget.headimg,fit: BoxFit.cover,),),
                ),
                Text(widget.name,style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),)
              ],
            ),
          ),
          _toolbar(),
        ],
      ),
    );
  }

  void _initAgoraRtcEngine(){
    AgoraRtcEngine.create(ImProvider.AGO_ID);
    AgoraRtcEngine.enableAudio();
    AgoraRtcEngine.joinChannel(null, widget.chatRoomId, null, 0);
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
    };
    AgoraRtcEngine.onUserOffline = (int uid,int reason){
      //一个用户离开
      print("==离开了===============$uid");
      Get.back();
    };
  }

  bool muted = false,audio = false;

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () => _onToggleMute(),
            child: new Icon(
              muted ? Icons.mic : Icons.mic_off,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: muted?Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(),
            child: new Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: () => _onSwitchCamera(),
            child: new Icon(
              audio ? Icons.volume_up : Icons.volume_off,
              color: audio ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: audio?Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }

  void _onCallEnd() {
    Get.back();
  }
  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }
  void _onSwitchCamera() {
    setState(() {
      audio = !audio;
    });
    print("静音对方");
  }

  @override
  void dispose() {
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    imPro.flagIsOnRtcChat = false;
    super.dispose();
  }

}