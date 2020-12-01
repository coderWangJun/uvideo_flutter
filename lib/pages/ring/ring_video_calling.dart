import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/app/web_socket.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/event_bus.dart';


class VideoSession{
  int uid;
  int viewId;
  Widget widget;

  VideoSession(this.uid,this.widget,{this.viewId});

}
///传入房间号--->邀请方的sessionId,即邀请方的腾讯云会话ID
class VideoRtcChatQZL extends StatefulWidget{

  String chatRoomId = "";
  String duiMianUID = "";
  String imgUrl = "";

  VideoRtcChatQZL(this.chatRoomId,this.duiMianUID);

  @override
  _VideoRtcChatQZLState createState()=> _VideoRtcChatQZLState();
}
class _VideoRtcChatQZLState extends State<VideoRtcChatQZL>{


  static final _session = List<VideoSession>();

  ImProvider imPro;
  WebSocketProvide webSocketProvide;

  DateTime startTime;

  VideoSession _getVideoSession(int uid) {
    return _session.firstWhere((session) {
      return session.uid == uid;
    });
  }

  @override
  void initState() {
    super.initState();
    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    startTime = DateTime.now();
    _addRenderView(0, (viewId){
      AgoraRtcEngine.setupLocalVideo(viewId, VideoRenderMode.Hidden);
      AgoraRtcEngine.startPreview();
      AgoraRtcEngine.joinChannel(null, widget.chatRoomId, null, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    imPro = Provider.of<ImProvider>(context);
    webSocketProvide = Provider.of<WebSocketProvide>(context);
    webSocketProvide.startTime = DateTime.now();
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
      setState(() {
        _addRenderView(uid, (viewId){
          AgoraRtcEngine.setupRemoteVideo(viewId, VideoRenderMode.Fit, uid);
        });
      });
    };
    AgoraRtcEngine.onUserOffline = (int uid,int reason){
      //一个用户离开
      print("==离开了===============$uid");
      if(webSocketProvide.flag){
        Get.back();
      }
      webSocketProvide.flag = true;
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
              AgoraRtcEngine.switchCamera();
            },
          )
        ],
      )
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
          _toolbar()];
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
          _toolbar()];
      default:
    }
    return [Container()];
  }

  void _onCallEnd(){

    MsgNode mMsgNode = MsgNode(widget.duiMianUID, "-3", "end");
    webSocketProvide.channel.sink.add(mMsgNode.toJson());
    webSocketProvide.saveQZLUserData("1","");
  }
  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  @override
  void dispose() {
    _session.forEach((element) {
      AgoraRtcEngine.removeNativeView(element.viewId);
    });
    _session.clear();
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    imPro.flagIsOnRtcChat = false;
    super.dispose();
  }


}