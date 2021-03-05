import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/route_manager.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/enums/message_node_type.dart';
import 'package:tencent_im_plugin/message_node/custom_message_node.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:youpinapp/app/app.dart';
import 'package:youpinapp/app/storage.dart';
import 'package:youpinapp/main.dart';
import 'package:youpinapp/pages/chat/chat_chat.dart';
import 'package:youpinapp/pages/chat/chat_route/video_rtc_wait.dart';
import 'package:youpinapp/pages/chat/chat_route/audio_rtc_wait.dart';
import 'package:youpinapp/pages/setting/updataApp.dart';
import 'package:youpinapp/third/tencent_kit.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/event_bus.dart';

class ImProvider with ChangeNotifier {
  static final String AGO_ID = "d1e4c73e80eb48598f993161ab4ce026";
  //7a3a1bf360f64dcbafe4c1b9ffc045ae
  static final String CHAT_KEY = "chatlistkey";
  static final String DEF_HEAD_IMAGE_URL =
      "http://mingyankeji.oss-cn-chengdu.aliyuncs.com/default-head-portrait/%E4%BC%98%E8%A7%86APP%E9%BB%98%E8%AE%A4%E5%A4%B4%E5%83%8F.png1597053811548?Expires=3173853811&OSSAccessKeyId=LTAI4GDRbwvuszWXHCNebT2j&Signature=tIsYLrlR9C01liBA1UtmSriROUI%3D";

  String mySessionId = "";
  //全局保存用户处于哪一个会话下，“”空串代表不在任何一个会话下
  String inWhereSessionId = "";

  List<String> sessionIdList = [];

  bool chat_flag = true;
  List<SessionEntity> chatList = [];
  Map dateMap = {};

  //是否处于音视频通话或者邀请界面中
  bool flagIsOnRtcChat = false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  //首页底部导航栏的红色小点点，对应-->（首页，集市，消息，我的）
  List<int> countRedIcon = [0, 0, 0, 0];

  initImProvider() {
    // 登录成功后，初始化腾讯SDK
    g_eventBus.on(GlobalEvent.accountInitialized, (arg) async {
      // await TencentImPlugin.logout().catchError((e){
      //   debugPrint("登出失败");
      // });
      TencentImPlugin.removeListener(_listener);
//      if(!chat_flag){return;}
      await TencentKit.instance.initSdk();
      initListChat();
      //监听消息
      chat_flag = false;
      TencentImPlugin.addListener(_listener);
      debugPrint("添加监听");
//弹出通知
//      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//      var android = new AndroidInitializationSettings("@mipmap/ic_launcher");
//      var IOS = new IOSInitializationSettings();
//      var initSettings = new InitializationSettings(android, IOS);
//      flutterLocalNotificationsPlugin.initialize(initSettings,onSelectNotification:onTapNotify);
    });
  }

  _listener(ListenerTypeEnum type, params) {
    if (type == ListenerTypeEnum.NewMessages) {
      List<MessageEntity> list = params;
      //C2C-------：
      //type为新消息时渲染UI
      //    测试发现接收方Refresh -> RefreshConversation -> NewMessages
      //            发送方Refresh -> RefreshConversation
      //Refresh(f) -> RefreshConversation(f) -> Refresh(t) -> RefreshConversation(t) -> NewMessages(t)
      //接收方避免重复接收相同消息处理方案现在是只接收 NewMessages
      //发送方不通过监听器来渲染UI

      String sessionId = list[0].sender;
      //判断是否处于当前消息的会话中
      if (sessionId != inWhereSessionId) {
//          showNotify(list[0].note);
        initListChat();
      } else {
        //将消息实体广播出去
        g_eventBus.emit(GlobalEvent.chatListener, params);
      }
      //如果消息为自定义消息时
      if (list[0].elemList[0].nodeType == MessageNodeType.Custom) {
        CustomMessageNode customMessageNode =
            list[0].elemList[0] as CustomMessageNode;
        List<String> mListString = customMessageNode.data.split(",");
        if (mListString[0] == StorageManager.RTC_YAOQING) {
          //收到了新的语音邀请
          //对方的ID，作为接受时的房间号以及发送回调信息的sessionId
          Duration dif = DateTime.now().difference(
              DateTime.fromMillisecondsSinceEpoch(list[0].timestamp * 1000));
          if (dif.inSeconds < 15) {
            String fromSessionId = list[0].sender;
            if (!flagIsOnRtcChat) {
              //正在空闲，可以接受，设置繁忙，跳转到邀请页面
              flagIsOnRtcChat = true;
              if (mListString[1] == "1") {
                Get.to(VideoRtcWait(fromSessionId));
              } else {
                Get.to(AudioRtcWait(
                  fromSessionId,
                  isSender: false,
                ));
              }
            } else {
              //当前繁忙，发送繁忙消息回去
              TencentImPlugin.sendMessage(
                  sessionId: fromSessionId,
                  sessionType: SessionType.C2C,
                  node: CustomMessageNode(data: StorageManager.RTC_FANMANG));
            }
          }
        } else if (mListString[0] == StorageManager.RTC_QUXIAO) {
          //对方取消了音视频邀请
          flagIsOnRtcChat = false;
          //退出视频通话房间，显示对方拒绝
          g_eventBus.emit(GlobalEvent.outRtcChat, "对方取消了邀请");
        } else if (mListString[0] == StorageManager.RTC_FANMANG) {
          //对方正在其他音视频中，繁忙
          //退出视频通话房间，显示对方当前繁忙稍后再试
          flagIsOnRtcChat = false;
          g_eventBus.emit(GlobalEvent.outRtcChat, "对方繁忙,请稍后再试");
        } else if (mListString[0] == StorageManager.RTC_JUJUE) {
          //对方拒绝了音视频邀请
          flagIsOnRtcChat = false;
          g_eventBus.emit(GlobalEvent.outRtcChat, "对方拒绝了你的邀请");
        } else if (mListString[0] == StorageManager.RTC_JIESHOU) {
          //对方接受了语音通话
          flagIsOnRtcChat = true;
          g_eventBus.emit(GlobalEvent.outRtcChat, "1");
        }
      }
    }
  }

//  Future<void> onTapNotify(String p) async{
//    if(p=='chat'){
//      main();
//      Get.to(ChatChat());
//    }
//    print("123-->$p");
//  }

//  showNotify(String msg){
//    var androids = new AndroidNotificationDetails('1', '2', '3',priority: Priority.High);
//    var ioss  = new IOSNotificationDetails();
//    var platform = new NotificationDetails(androids, ioss);
//    flutterLocalNotificationsPlugin.show(0, '新消息', msg, platform,payload: 'chat');
//  }

  //刷新会话列表
  initListChat() {
    sessionIdList.clear();
    chatList.clear();
    TencentImPlugin.getConversationList().then((value) {
      if (value != null) {
        chatList = value;
      }
      int countXX = 0;
      chatList.forEach((element) {
        if (element.message != null) {
          sessionIdList.add(element.id);
          countXX = countXX + element.unreadMessageNum;
        }
      });
      countRedIcon[2] = countXX;
      // print("========${sessionIdList.length}========");
      if (sessionIdList.length != 0) {
        DioUtil.request("/user/getUserMSGByTxUserid",
            parameters: {"ids": sessionIdList}).then((values) {
          if (DioUtil.checkRequestResult(values)) {
            print(values.toString());
            dateMap = values["data"];
            notifyListeners();
          }
        });
      } else {
        notifyListeners();
      }
    });
  }

  intoSessionChat(String sessionId) {
    inWhereSessionId = sessionId;
  }
}
