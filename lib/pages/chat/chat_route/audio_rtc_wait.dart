import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/message_node/custom_message_node.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/app/storage.dart';
import 'package:youpinapp/pages/chat/chat_route/audio_rtc_chat.dart';
import 'package:youpinapp/pages/chat/chat_route/video_rtc_chat.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/event_bus.dart';

class AudioRtcWait extends StatefulWidget{

  String sessionIdApi;
  bool isSender = true;
  AudioRtcWait(this.sessionIdApi,{this.isSender = true});

  @override
  _AudioRtcWaitState createState() => _AudioRtcWaitState();
}

class _AudioRtcWaitState extends State<AudioRtcWait>{

  ImProvider imProvider;

  @override
  Widget build(BuildContext context) {
    imProvider = Provider.of<ImProvider>(context);
    imProvider.flagIsOnRtcChat = true;
    return BaseView(
      model: AudioRtcWaitProvider(),
      onReady: (model){model.init(widget.sessionIdApi);},
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

  Widget _getBody(BuildContext context , AudioRtcWaitProvider model){
    return Stack(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(join(AssetsUtil.assetsDirectoryChat,"bj.png"),fit: BoxFit.cover,),
      ),

      Positioned(child: ClipOval(child: Container(width: 70.0,height: 70.0,child:Image.network(model.headimg,fit: BoxFit.cover,)),),left: 20.0,top: 40.0,),
      Positioned(child: Text(model.name,style: TextStyle(color: Colors.white,fontSize: 20.0),),left: 100.0,top: 55.0,),
      Positioned(child: Text("邀请进行语音通话",style: TextStyle(color: Colors.white,fontSize: 12.0),),left: 100.0,top: 85.0,),
      Positioned(child:Container(width: MediaQuery.of(context).size.width,child:Row(
        mainAxisAlignment: widget.isSender?MainAxisAlignment.center:MainAxisAlignment.spaceEvenly,
        children: <Widget>[
            RawMaterialButton(
              onPressed: () => iAmNotOk(),
              child: new Icon(
                Icons.call_end,
                color: Colors.white,
                size: 35.0,
              ),
              shape: new CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.redAccent,
              padding: widget.isSender?const EdgeInsets.all(15.0) :const EdgeInsets.symmetric(vertical: 15.0,horizontal: 40.0),
            ),
          widget.isSender?SizedBox.shrink():RawMaterialButton(
            onPressed: () => iAmOk(model),
            child: new Icon(
              Icons.keyboard_voice,
              color: Colors.white,
              size: 35.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 40.0),
          ),
      ],)),bottom: 80.0,),


    ],);
  }

  //接受语音
  iAmOk(AudioRtcWaitProvider model) async{
    if(widget.isSender){
      if(await Permission.microphone.request().isGranted){
        Get.off(AudioRtcChat(g_accountManager.currentUser.tXIMUser.txUserid,model.headimg,model.name));
      }else{
        iAmNotOk();
      }
    }else{
      TencentImPlugin.sendMessage(sessionId: widget.sessionIdApi, sessionType: SessionType.C2C, node: CustomMessageNode(data: StorageManager.RTC_JIESHOU+",1")).then((value){
        Get.off(AudioRtcChat(widget.sessionIdApi,model.headimg,model.name));
      });
    }
  }

  //拒绝或者取消语音
  iAmNotOk(){
    imProvider.flagIsOnRtcChat = false;
    String datas;
    if(widget.isSender){
      datas = StorageManager.RTC_QUXIAO;
    }else{
      datas = StorageManager.RTC_JUJUE;
    }
    TencentImPlugin.sendMessage(sessionId: widget.sessionIdApi, sessionType: SessionType.C2C, node: CustomMessageNode(data: datas)).then((value){
      Get.back();
    });
  }

  @override
  void dispose() {
    g_eventBus.off(GlobalEvent.outRtcChat);
    super.dispose();
  }


}

class AudioRtcWaitProvider with ChangeNotifier{
  String headimg = "http://mingyankeji.oss-cn-chengdu.aliyuncs.com/default-head-portrait/%E4%BC%98%E8%A7%86APP%E9%BB%98%E8%AE%A4%E5%A4%B4%E5%83%8F.png1597053811548?Expires=3173853811&OSSAccessKeyId=LTAI4GDRbwvuszWXHCNebT2j&Signature=tIsYLrlR9C01liBA1UtmSriROUI%3D";
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

    g_eventBus.on(GlobalEvent.outRtcChat, (arg) {
      if((arg as String )== "1"){
        Get.off(AudioRtcChat(g_accountManager.currentUser.tXIMUser.txUserid,headimg,name));
      }else{
        BotToast.showText(text: arg as String);
        Get.back();
      }
    });

  }
}