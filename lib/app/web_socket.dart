import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_baidu_map/flutter_baidu_map.dart';
import 'package:get/route_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/io.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/pages/ring/ring_end.dart';
import 'package:youpinapp/pages/ring/ring_index.dart';
import 'package:youpinapp/pages/ring/ring_video_calling.dart';
import 'package:youpinapp/pages/ring/ring_yaoqing.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/event_bus.dart';
import 'dart:convert' as convert;
import 'package:web_socket_channel/status.dart' as status;

//全局状态管理方便处理服务器socket推送更新app的UI
class WebSocketProvide with ChangeNotifier{

  DateTime startTime;

  IOWebSocketChannel channel;

  BuildContext context;

  String roomId;

  bool flag = true;

  bool twoPerson = false;
  bool isOpen = true;

  var dataMap;

  //心跳检测
  bool connStu = true;
  init() async{
    debugPrint("~~~~~连接start~~~~~");
    try {
      flag = true;
      connStu = true;
      twoPerson = false;
      // BaiduLocation baiduLocation;
      // baiduLocation = await FlutterBaiduMap.getCurrentLocation();
      channel = IOWebSocketChannel.connect("ws://47.108.196.26:2020/ws",
          headers: {
            'token': g_accountManager.currentUser.token,
            // 'lon': baiduLocation == null ? "" : baiduLocation.longitude,
            // 'lat': baiduLocation == null ? "" : baiduLocation.latitude
          });
      channel.stream.listen((msg) {
        if (msg != "") {
          msgHandler(msg as String);
        } else {
          connStu = true;
          debugPrint("~~~~~心跳~~~~~");
        }
      });
      debugPrint("~~~~~连接end~~~~~");
      heartConn();
    }catch(e){
      debugPrint("~~~~~$e~~~~~");
      channel.sink.close(status.goingAway).then((value){
        Future.delayed(Duration(seconds: 3)).then((value){
          init();
        });
      });
    }
  }


  heartConn(){
    if(isOpen){
      try {
        if (connStu) {
          Future.delayed(Duration(seconds: 5)).then((value) { //5
            channel.sink.add("");
            connStu = false;
            Future.delayed(Duration(seconds: 10)).then((value) { //10
              heartConn();
            });
          });
        } else {
          debugPrint("~~~~~未收到心跳包,3s后尝试重连~~~~~");
          channel.sink.close(status.goingAway).then((value) {
            Future.delayed(Duration(seconds: 3)).then((value) {
              init();
            });
          });
        }
      }catch(e){
        heartConn();
      }
    }
  }


  closes() async{
    twoPerson = false;
    Future.delayed(Duration(seconds: 1)).then((value){
      channel.sink.add(MsgNode(g_accountManager.currentUser.id, "-1", "").toJson());
    });
    if(!isOpen){channel.sink.close();}
  }

  saveQZLUserData(String type,String msgDataText){
    flag = false;
    Duration def = DateTime.now().difference(startTime);
    String time = "";
      if(def.inHours>=1){
        time = time + "${def.inHours}小时";
      }else{
        if(def.inMinutes>=1){
          if(def.inMinutes>=10){
            time = time + "${def.inMinutes}:${def.inSeconds}";
          }else{
            if(def.inSeconds-(60*def.inMinutes)>=10){
              time = time + "0${def.inMinutes}:${def.inSeconds-(60*def.inMinutes)}";
            }else{
              time = time + "0${def.inMinutes}:0${def.inSeconds-(60*def.inMinutes)}";
            }
          }
        }else{
          if(def.inSeconds>=10){
            time = time + "00:${def.inSeconds}";
          }else{
            time = time + "00:0${def.inSeconds}";
          }
        }
      }
    if(dataMap!=null && type!="-3"){
      //保存
      Map param;
      if(g_accountManager.currentUser.typeId!=1){
        param = {//公司
          "distance":dataMap['distance'] as String,
          "communication":"$type,$time",
          "userTxUserid":dataMap['myTXUserid'] as String,//个人IM userid
          "companyUserTxUserid":dataMap['targetTXUserid'] as String,//公司IM userid
          "userHeadPortraitUrl":dataMap['headPortraitUrl'] as String,
          "userid":dataMap['userid'] as String,
          "userName":dataMap['name'] as String,
          "userPosition":dataMap['positionName'] as String,
        };
      }else{
        param = {//个人
          "distance":dataMap['distance'] as String,
          "communication":"$type,$time",
          "userTxUserid":dataMap['myTXUserid'] as String,//个人IM userid
          "companyUserTxUserid":dataMap['targetTXUserid'] as String,//公司IM userid
          "companyUserid":dataMap['userid'] as String,
          "companyUserHeadPortraitUrl":dataMap['headPortraitUrl'] as String,
          "companyUserName":dataMap['name'] as String,
          "companyName":dataMap['companyName'] as String
        };
      }
      DioUtil.request("/resume/addUserJobBellRecord",parameters: param);
    }
    closes();
    if(msgDataText=="notgetoff"){
      Get.to(RingEnd(dataMap,time));
    }else{
      Get.off(RingEnd(dataMap,time));
    }
  }

  //处理服务器推送的数据
  msgHandler(String msg){
    var result = convert.jsonDecode(msg);
    print("=--------------------------------------------------------------------->$msg");
    if(1==0){return;}
    else if(result['code'] == "1"){//匹配成功
      roomId = result['data']['roomNo'] as String;
      dataMap = result['data'];
      g_eventBus.emit(GlobalEvent.stopPlayEvent);
      Get.to(RingIndex(result['data'] as Map));
    }
    else if(result['code'] == "200"){
      String room = "${roomId.hashCode}";
      Get.to(RingYaoQing(room,true,uid: dataMap['userid'],));
    }else if(result['code'] == "-2"){
      BotToast.showText(text: "对方离开了匹配");
      closes();
      Get.back();
    }else if(result['code'] == "-3"){
      saveQZLUserData("-3",result['data']);
    }
  }

}

enum MsgNodeType{
  text
}

class MsgNode{

  String userid;

  String type;

  String text;

  MsgNode(this.userid ,this.type, this.text);

  String toJson(){
    String msg = "{"+
        " \"userid\" : \"$userid\" ,"+
        " \"type\" : \"$type\" ,"+
        " \"text\" : \"$text\" "+
        "}";
    return msg;
  }
}