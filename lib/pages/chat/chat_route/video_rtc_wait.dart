import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/message_node/custom_message_node.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/app/storage.dart';
import 'package:youpinapp/pages/chat/chat_route/video_rtc_chat.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/event_bus.dart';

class VideoRtcWait extends StatefulWidget{

  //对方的sessionId，同时作为会话的房间号使用。
  String roomId;
  VideoRtcWait(this.roomId);

  @override
  _VideoRtcWaitState createState() => _VideoRtcWaitState();
}

class _VideoRtcWaitState extends State<VideoRtcWait>{

  ImProvider imProvider;

  @override
  Widget build(BuildContext context) {
    imProvider = Provider.of<ImProvider>(context);
    return BaseView(
      model: VideoRtcWaitProvider(),
      onReady: (model){model.init(widget.roomId);},
      builder: (context,model,child){
        return Scaffold(
          appBar: PreferredSize(child: AppBar(
            brightness: Brightness.light,
          ), preferredSize: Size(double.infinity, 0)),
          body: _getBody(context,model),
        );
      },
    );
  }

 Widget _getBody(BuildContext context , VideoRtcWaitProvider model){
    return Stack(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(join(AssetsUtil.assetsDirectoryChat,"bj.png"),fit: BoxFit.cover,),
      ),


      Positioned(child: ClipOval(child: Container(width: 70.0,height: 70.0,child: Image.network(model.headimg,fit: BoxFit.cover,)),),left: 20.0,top: 40.0,),
      Positioned(child: Text(model.name,style: TextStyle(color: Colors.white,fontSize: 20.0),),left: 100.0,top: 55.0,),
      Positioned(child: Text("邀请你进行视频通话",style: TextStyle(color: Colors.white,fontSize: 12.0),),left: 100.0,top: 85.0,),
      Positioned(child: RawMaterialButton(
        onPressed: () => iAmNotOk(),
        child: new Icon(
          Icons.call_end,
          color: Colors.white,
          size: 35.0,
        ),
        shape: new CircleBorder(),
        elevation: 2.0,
        fillColor: Colors.redAccent,
        padding: const EdgeInsets.all(15.0),
      ),left: 50.0,bottom: 80.0,),

      Positioned(child: RawMaterialButton(
        onPressed: () => iAmOk(),
        child: new Icon(
          Icons.videocam,
          color: Colors.white,
          size: 35.0,
        ),
        shape: new CircleBorder(),
        elevation: 2.0,
        fillColor: Colors.green,
        padding: const EdgeInsets.all(15.0),
      ),right: 50.0,bottom: 80.0,),

    ],);
 }

 //接受语音
 iAmOk() async{
    if(await Permission.microphone.request().isGranted && await Permission.camera.request().isGranted){
      Get.off(VideoRtcChat(widget.roomId));
    }else{
      iAmNotOk();
    }
 }

 //拒绝语音
 iAmNotOk(){
    imProvider.flagIsOnRtcChat = false;
    TencentImPlugin.sendMessage(sessionId: widget.roomId, sessionType: SessionType.C2C, node: CustomMessageNode(data: StorageManager.RTC_JUJUE)).then((value){
      Get.back();
    });
 }

  @override
  void initState() {
    super.initState();
    g_eventBus.on(GlobalEvent.outRtcChat, (arg) {
      BotToast.showText(text: arg as String);
      Get.back();
    });
  }

  @override
  void dispose() {
    g_eventBus.off(GlobalEvent.outRtcChat);
    super.dispose();
  }


}

class VideoRtcWaitProvider with ChangeNotifier{
  String headimg = "";
  String name = "";
  init(String sessionId){
    DioUtil.request("/user/getUserMSGByTxUserid",parameters: {"ids":[sessionId]}).then((values){
      if(DioUtil.checkRequestResult(values)){
        if(values!=null){
           Map m = values['data'][sessionId];
           if(m["headPortraitUrl"]!=null){
            headimg = m["headPortraitUrl"];
           }
           if(m["name"]!=null){
            name = m["name"];
           }
           notifyListeners();
        }
      }
    });
  }
}