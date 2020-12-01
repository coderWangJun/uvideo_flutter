import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/enums/message_node_type.dart';
import 'package:tencent_im_plugin/message_node/custom_message_node.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/app/storage.dart';
import 'package:youpinapp/pages/chat/chat_route/chat_route.dart';
import 'package:youpinapp/utils/event_bus.dart';


class VideoSession{
  int uid;
  int viewId;
  Widget widget;

  VideoSession(this.uid,this.widget,{this.viewId});

}
///传入房间号--->邀请方的sessionId,即邀请方的腾讯云会话ID
class VideoRtcChat extends StatefulWidget{

  ChatDomeProvider chatDomeProvider;
  String chatRoomId;
  String imgUrl = "";
  VideoRtcChat(this.chatRoomId,{this.imgUrl = "",this.chatDomeProvider});

  @override
  _VideoRtcChatState createState()=> _VideoRtcChatState();
}
class _VideoRtcChatState extends State<VideoRtcChat>{


  static final _session = List<VideoSession>();

  bool flagQX = false;
  bool showTextFlag = false;
  ImProvider imPro;

  VideoSession _getVideoSession(int uid) {
    return _session.firstWhere((session) {
      return session.uid == uid;
    });
  }

  @override
  void initState() {
    super.initState();
    g_eventBus.on(GlobalEvent.outRtcChat, (arg) {
      BotToast.showText(text: arg as String);
      flagQX = true;
      Get.back();
    });
    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    _addRenderView(0, (viewId){
      AgoraRtcEngine.setupLocalVideo(viewId, VideoRenderMode.Hidden);
      AgoraRtcEngine.startPreview();
      AgoraRtcEngine.joinChannel(null, widget.chatRoomId, null, 0);
    });
    Future.delayed(Duration(seconds: 20)).then((value){
      if(!flagQX){
        BotToast.showText(text: "对方可能不在 无法接听");
        Future.delayed(Duration(seconds: 15)).then((value){
          if(!flagQX){
            Get.back();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    imPro = Provider.of<ImProvider>(context);
    imPro.flagIsOnRtcChat = true;
    return Scaffold(
      appBar: PreferredSize(child: AppBar(brightness: Brightness.dark,backgroundColor:Colors.black,), preferredSize: Size(double.infinity, 0.0)),
      body:Stack(
        children: _viewRows(context),
      ),
    );
  }

  void _initAgoraRtcEngine(){
    AgoraRtcEngine.create(ImProvider.AGO_ID);
    AgoraRtcEngine.enableVideo();
    AgoraRtcEngine.enableAudio();
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
      flagQX = true;
      setState(() {
        showTextFlag = false;
        _addRenderView(uid, (viewId){
          AgoraRtcEngine.setupRemoteVideo(viewId, VideoRenderMode.Fit, uid);
        });
      });
    };
    AgoraRtcEngine.onUserOffline = (int uid,int reason){
      //一个用户离开
      print("==离开了===============$uid");
      Get.back();
    };
  }

  void _addRenderView(int uid,Function(int viewId) finished){
    Widget view = AgoraRtcEngine.createNativeView((viewId){
      setState(() {
        _getVideoSession(uid).viewId = viewId;
        if(finished != null){
          finished(viewId);
        }
      });
    });
    VideoSession session = VideoSession(uid, view);
    _session.add(session);
  }

  bool muted = false;

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
            onPressed: () => _onCallEnd(context),
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
        ],
      ),
    );
  }

  Widget _changeCamera(){
    return Positioned(
      left: 12.0,
      top: 45.0,
      child: RawMaterialButton(
        onPressed: () => _onSwitchCamera(),
        child: new Icon(
          Icons.switch_camera,
          color: Colors.blueAccent,
          size: 20.0,
        ),
        shape: new CircleBorder(),
        elevation: 2.0,
        fillColor: Colors.white,
        padding: const EdgeInsets.all(12.0),
      ),
    );
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Container(child: view);
  }

  /// Video layout wrapper
  List<Widget> _viewRows(BuildContext context) {
    List<Widget> views = _session.map((session) => session.widget).toList();
    switch (views.length) {
      case 1:
        return [Container(child:_videoView(views[0])),
          Positioned(
            top: 50.0,
            right: 20.0,
            child: ClipOval(child: Image.network(widget.imgUrl,fit: BoxFit.cover,),),
            width: 120.0,
            height: 120.0,
          ),
          _toolbar(),_changeCamera()];
      case 2:
        return [
          Container(child:_videoView(views[1]),width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,),
          Positioned(
            top: 50.0,
            right: 20.0,
            child:_videoView(views[0]),
            width: 120.0,
            height: 200.0,
          ),
          _toolbar(),_changeCamera()];
      default:
    }
    return [Container()];
  }




  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }
  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }
  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  @override
  void dispose() {
    g_eventBus.off(GlobalEvent.outRtcChat);
    _session.forEach((element) {
      AgoraRtcEngine.removeNativeView(element.viewId);
    });
    _session.clear();
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    imPro.flagIsOnRtcChat = false;

    if(!flagQX&&g_accountManager.currentUser.tXIMUser.txUserid == widget.chatRoomId){
      flagQX = true;
      widget.chatDomeProvider.text = StorageManager.RTC_QUXIAO;
      widget.chatDomeProvider.sendMessage(MessageNodeType.Custom);
    }
    super.dispose();
  }


}