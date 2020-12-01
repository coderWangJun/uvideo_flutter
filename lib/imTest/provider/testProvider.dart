import 'package:flutter/material.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/enums/message_node_type.dart';
import 'package:tencent_im_plugin/message_node/image_message_node.dart';
import 'package:tencent_im_plugin/message_node/message_node.dart';
import 'package:tencent_im_plugin/message_node/text_message_node.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';

class ImTestProvider with ChangeNotifier{

  //保存发送消息
  String sendText = "";

  String path = "";
  String text = "";

  _listener(ListenerTypeEnum type, params) async{
////    List<SessionEntity> sessionEntity = params;
//  print(type.toString());
//    print("消息加入");
    String i = await TencentImPlugin.getLoginUser();
    print("======================loginId=============================");
    print(i);
    print("ok========================path===========================");
    print(path);
////    print(sessionEntity[0].toJson());
//    TencentImPlugin.getMessages(sessionId: "test", sessionType: SessionType.C2C, number: 1 ).then((value){
//      print(value[0].toJson());
//    });
    print(DateTime.now());
    if (type == ListenerTypeEnum.NewMessages) {
      print("ok========================type===========================");
      print("NewMessages");
      List<MessageEntity> list = params;
      print("ok========================data===========================");
        print(list[0].toJson());

      List<MessageNode> lists = list[0].elemList;
      if(lists[0].nodeType == MessageNodeType.Image){
        print("ok========================is_image===========================");
      }
      text = text + "---" +list[0].note;
      print(list.toString());
    }
//    else if (type == ListenerTypeEnum.RefreshConversation) {
//      print("RefreshConversation");
//      List<SessionEntity> list = params;
//          print(list.length);
//          print(list[0].id);
//          print(list[0].message.note);
//          text = text + "---" +list[0].message.note;
//          print(list.toString());
//    } else if (type == ListenerTypeEnum.RecvReceipt) {
//      print("RecvReceipt");
//          print(params);
//    } else{
//      print(type.toString());
//      print(params);
//      print("其他");
//    }
    notifyListeners();
  }

  sendMess(){
    print(sendText);
//    TencentImPlugin.sendMessage(sessionId: "f10a5d13d8ab43768e78a9a6f9db06c2", sessionType: SessionType.C2C, node: TextMessageNode(content: sendText));
    TencentImPlugin.sendMessage(sessionId: "f10a5d13d8ab43768e78a9a6f9db06c2", sessionType: SessionType.C2C, node: ImageMessageNode(
      path: path,level: 1));
  }

  init(){TencentImPlugin.addListener(_listener);}
  dis(){TencentImPlugin.removeListener(_listener);}
}