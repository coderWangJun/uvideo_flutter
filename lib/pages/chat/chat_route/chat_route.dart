import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/enums/image_type.dart';
import 'package:tencent_im_plugin/enums/message_node_type.dart';
import 'package:tencent_im_plugin/message_node/custom_message_node.dart';
import 'package:tencent_im_plugin/message_node/image_message_node.dart';
import 'package:tencent_im_plugin/message_node/sound_message_node.dart';
import 'package:tencent_im_plugin/message_node/text_message_node.dart';
import 'package:tencent_im_plugin/message_node/video_message_node.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/app/storage.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/chat/chat_route/audio_rtc_wait.dart';
import 'package:youpinapp/pages/chat/chat_route/video_rtc_chat.dart';
import 'package:youpinapp/pages/chat/chat_transfer.dart';
import 'package:youpinapp/pages/person/user_detail_route.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/chooseScrollFragment.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/event_bus.dart';
import 'package:youpinapp/utils/uiUtil.dart';


///聊天页---> ChatDome(String a,Map b)
///----参数--> a : sessionId, b : {'headPortraitUrl' : '头像url' , 'name' : '名字' , 'companyName' : '公司'}
///map中没有的参数就不传

final FlutterSound flutterSound = new FlutterSound();//语音插件
class ChatDomeProvider with ChangeNotifier{

  String hisUserId = "";

  bool isSoundOn = true;

  String hisHeadImg = "";
  String myHeadImg;

  //设置锁，防止一点播放就切换引起异常
  bool flagPlayLook = true;

  //保存当前位置，发送成功后刷新原语音UI组件
  int positionNow = -1;

  //常用语，个数不限
  List<String> chatCYY = [
    "您好，可以聊聊吗？我对这个职位很感兴趣，希望进一步了解",
    "我可以把我的简历发给您看看吗？",
    "我可以来贵公司面试吗？",
    "对不起，我觉得该职位不太适合我，祝您早日找到满意的工作人选",
  ];


  AnimationController animationController;


  AccountModel accountModel = g_accountManager.currentUser;

  //保存待发送的文本信息或者一个路径
  String text = "";

  //录制的语音路径-->时长
  String soundPath = "";
  String longTime = "";
  String dbSound = "";
  int index = -1;
  //时长，毫秒
  int timeLen = 0;
  int botItemFlag = 0;

  //是否显示取消发送语音的垃圾桶图标
  bool isShowLJT = false;

  //语音取消
  Color colorQx = Color.fromRGBO(238, 238, 238, 1);

  //保存当前会话的语音总数---->
  int countSound = 0;
  List<AnimationController> soundIconList = [];

  //每次拉取的条数
  static final int COUNT_CHATLISTNUM = 10;
  //当前记录的第一条
  int _countChatList = 10;
  //防止多次上拉重复请求
  bool _upLoadRefresh = true;

  ScrollController scroll = ScrollController();

  //发送按钮是否可用
  bool iconFlag = true;
  bool showFlag = false;

  //保存会话Id
  String toSessionId = "";

  //先不搞这个东西
  List<Map> topList = [
    {"icon" : Icon(Icons.phone_android), "title": "换电话", "function":""},
    {"icon" : "", "title": "换微信", "function":""},
    {"icon" : "", "title": "发简历", "function":""},
    {"icon" : "", "title": "发作品", "function":""},
  ];

  Map userDate = {};

  //保存界面上显示的聊天记录widget
  List<Widget> messageList = [SizedBox(height: 20.0,width: 20.0,)];

  //处理第三方包的BUG--保存最后一条消息由谁发出
  String sessionLast = "";

  Map staSound = {};
  Map _unSound = {
    'colorBack':Colors.white,
    'border':Border.all(color: Color.fromRGBO(170, 170, 170, 1)),
    'text':"长按说话",
    'iconColor':Color.fromRGBO(51, 51, 51, 1),
  };
  Map _onSound = {
    'colorBack':Color.fromRGBO(79, 154, 247, 1),
    'border':Border.fromBorderSide(BorderSide.none),
    'text':"松开发送-滑动取消",
    'iconColor':Colors.white,
  };

  changeColorQx(bool f){
    if(f){
      colorQx = Colors.red;
    }else{
      colorQx = Color.fromRGBO(238, 238, 238, 1);
    }
    notifyListeners();
  }

  changeSoundStyle(){
    if(staSound == _onSound){
      isSoundOn = true;
      staSound = _unSound;
    }else{
      isSoundOn = false;
      staSound = _onSound;
    }
    notifyListeners();
  }

  setIsShowLJT(bool ljt){
    isShowLJT = ljt;
    notifyListeners();
  }

  setLongTime(String txt){
    longTime = txt;
    notifyListeners();
  }

  //处理监听
  _listener(ListenerTypeEnum type,params){
    print("ok====$type");
    if(type == ListenerTypeEnum.NewMessages){
      List<MessageEntity> list = params;

      String sessionId = list[0].sender;
      MessageNodeType nodeType = list[0].elemList[0].nodeType;
      if(toSessionId==sessionId){
        refreshUiIsGet(nodeType, list[0]);

        notifyListeners();
        //暂时想不到更好的方式了，先等待500毫秒再滚动至末尾
        Future.delayed(Duration(milliseconds: 500)).then((value){
          scroll.animateTo(scroll.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
//        scroll.jumpTo(scroll.position.maxScrollExtent);
        });
      }
    }
  }

  init(ScrollController scrolls,String session){
    if(g_accountManager.currentUser.typeId==1){
      myHeadImg = g_accountManager.currentUser.userData.headPortraitUrl??="http://mingyankeji.oss-cn-chengdu.aliyuncs.com/default-head-portrait/%E4%BC%98%E8%A7%86APP%E9%BB%98%E8%AE%A4%E5%A4%B4%E5%83%8F.png1597053811548?Expires=3173853811&OSSAccessKeyId=LTAI4GDRbwvuszWXHCNebT2j&Signature=tIsYLrlR9C01liBA1UtmSriROUI%3D";
    }else if(g_accountManager.currentUser.typeId==2){
      myHeadImg = g_accountManager.currentUser.companyData.logoUrl??="http://mingyankeji.oss-cn-chengdu.aliyuncs.com/default-head-portrait/%E4%BC%98%E8%A7%86APP%E9%BB%98%E8%AE%A4%E5%A4%B4%E5%83%8F.png1597053811548?Expires=3173853811&OSSAccessKeyId=LTAI4GDRbwvuszWXHCNebT2j&Signature=tIsYLrlR9C01liBA1UtmSriROUI%3D";
    }else{
      myHeadImg = "http://mingyankeji.oss-cn-chengdu.aliyuncs.com/default-head-portrait/%E4%BC%98%E8%A7%86APP%E9%BB%98%E8%AE%A4%E5%A4%B4%E5%83%8F.png1597053811548?Expires=3173853811&OSSAccessKeyId=LTAI4GDRbwvuszWXHCNebT2j&Signature=tIsYLrlR9C01liBA1UtmSriROUI%3D";
    }
    staSound = _unSound;
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbLevelEnabled(true);
    flutterSound.setDbPeakLevelUpdate(0.8);
    initializeDateFormatting();

    scroll = scrolls;


    //注册监听
    g_eventBus.on(GlobalEvent.chatListener, (arg) {
      _listener(ListenerTypeEnum.NewMessages, arg);
    });

    //添加监听
//    TencentImPlugin.addListener(_listener);
    //读取聊天记录显示
    reFreshChatList();
    
    DioUtil.request("/user/getUserMSGByTxUserid",parameters: {'ids':[toSessionId]}).then((value){
      if(DioUtil.checkRequestResult(value)){if(value['data']!=null){
        hisUserId = value['data'][toSessionId]['userid'] as String;
      }}
    });
  }


  cleanAllParam(){
    messageList.clear();
    countSound = 0;
    soundIconList.clear();
  }

  reFreshChatList(){
    messageList.clear();
    TencentImPlugin.getMessages(sessionId: toSessionId, sessionType: SessionType.C2C, number: _countChatList).then((value){
        cleanAllParam();
      value.forEach((e){
        if(e.sender==toSessionId){
          refreshUiIsGet(e.elemList[0].nodeType, e);
        }else{
          refreshUiIsSend(e.elemList[0].nodeType, e);
        }
      });
        notifyListeners();
        //暂时想不到更好的方式了,先等待500毫秒再滚动至末尾
        Future.delayed(Duration(milliseconds: 500)).then((value){
//          scroll.animateTo(scroll.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        scroll.jumpTo(scroll.position.maxScrollExtent);
        });
    });
    _countChatList = _countChatList + COUNT_CHATLISTNUM;
  }

  reFreshChatListMore(){
    messageList.clear();
    TencentImPlugin.getMessages(sessionId: toSessionId, sessionType: SessionType.C2C, number: _countChatList).then((value){
      cleanAllParam();
      value.forEach((e){
        if(e.sender==toSessionId){
          refreshUiIsGet(e.elemList[0].nodeType, e);
        }else{
          refreshUiIsSend(e.elemList[0].nodeType, e);
        }
      });
      notifyListeners();
    });
    _countChatList = _countChatList + COUNT_CHATLISTNUM;
  }

  dis(){

    g_eventBus.off(GlobalEvent.chatListener);
    //移除监听
//    TencentImPlugin.removeListener(_listener);
    if(flutterSound.isPlaying){
      flutterSound.stopPlayer();
    }
  }

  stopAnimationController(){
    soundIconList.forEach((element) {
      if(element.isAnimating){
        element.reset();
      }
    });
  }

  playSound(int indexs,MessageEntity node,int mill){
    stopAnimationController();

    try {
      if(flagPlayLook){
        flagPlayLook = false;
        if (flutterSound.isPlaying) {
          if (indexs == index) {
            print("停止播放当前语嘤......");
            flutterSound.stopPlayer();
            flagPlayLook = true;
          } else {
            index = indexs;
            print("其他语嘤正在播放......先停止播放......");
            flutterSound.stopPlayer().then((value) {
              TencentImPlugin.downloadSound(message: node).then((urlPath) {
                flutterSound.startPlayer(urlPath);
                soundIconList[indexs].forward();
                flagPlayLook = true;});});
          }
        } else {
          print("=======>播放语音--->$index");
          index = indexs;
          TencentImPlugin.downloadSound(message: node).then((urlPath) {
            flutterSound.startPlayer(urlPath);
            soundIconList[indexs].forward();
            flagPlayLook = true;});
        }
      }else{print("========>操作频繁");}
    }catch(e){
      if(flutterSound.isPlaying){
        flutterSound.stopPlayer();
      }
      print(e);
    }
  }

  setIconFlag(bool flag){
    iconFlag = flag;
    notifyListeners();
  }

  setBotItemFlag(int botItem){
    botItemFlag = botItem;
    notifyListeners();
  }

  setShowFlag(bool flag){
    if(!flag){
      botItemFlag = 0;
    }
    showFlag = flag;
    if(flag){
      animationController.forward();
    }else{
      animationController.reverse();
    }
    notifyListeners();
  }

  sendMessage(MessageNodeType type){
    print("send:$text----sessionId:$toSessionId");

    var node;
    //根据消息类型封装消息体
    if(1==0){return;}
    else if(type == MessageNodeType.Text)  {  node = TextMessageNode(content: text);        }
    else if(type == MessageNodeType.Image) {  node = ImageMessageNode(path: text,level: 1); }
    else if(type == MessageNodeType.Sound) {  node = SoundMessageNode(path: soundPath, duration: timeLen);}
    else if(type == MessageNodeType.Video) {  node = VideoMessageNode(videoSnapshotInfo: null, videoInfo: null);}
    else if(type == MessageNodeType.Custom){  node = CustomMessageNode(data: text);}//自定义消息--->音视频邀请信息

    //发送(语音消息发送成功后才显示，不然之前的语言本地打不开)
    TencentImPlugin.sendMessage(sessionId: toSessionId, sessionType: SessionType.C2C, node: node).then((value){
      if(type==MessageNodeType.Sound){
        longTime = "";
        refreshUiIsSend(type,value);
        notifyListeners();
        Future.delayed(Duration(milliseconds: 500)).then((value){
          scroll.animateTo(scroll.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
//        scroll.jumpTo(scroll.position.maxScrollExtent);
        });
      }
      print("发送完成。。。。。。");
    });

    if(type != MessageNodeType.Sound){
      refreshUiIsSend(type, MessageEntity(elemList: [node]));
      notifyListeners();
      Future.delayed(Duration(milliseconds: 500)).then((value){
        scroll.animateTo(scroll.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
//        scroll.jumpTo(scroll.position.maxScrollExtent);
      });
    }

  }

  refreshUiIsSend(MessageNodeType type,MessageEntity node){
    print("开始更新UI。。。。。。");
    sessionLast = node.sender;
    if(1==0){return;}
    else if(type == MessageNodeType.Text){//文本消息
      TextMessageNode textNode = node.elemList[0] as TextMessageNode;
      Widget appendUi = Container(margin:EdgeInsets.only(bottom: 20.0),child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          //头像先写死了，暂时不知道怎么获取这个东西
          _TextUiWidget(textNode.content,true),
          SizedBox(width: 10.0,),
          _getHeadImg(myHeadImg),
          SizedBox(width: 20.0,)
        ],
      ));
      messageList.add(appendUi);}
    else if(type == MessageNodeType.Image){//图片消息
      ImageMessageNode imageNode = node.elemList[0] as ImageMessageNode;
      Widget appendUi = Container(margin:EdgeInsets.only(bottom: 20.0),child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          //头像先写死了，暂时不知道怎么获取这个东西
          _TextUiWidgetImg((imageNode.path!=null&&imageNode.path!="")?imageNode.path:imageNode.imageData[ImageType.Original].url,true),
          SizedBox(width: 10.0,),
          _getHeadImg(myHeadImg),
          SizedBox(width: 20.0,)
        ],
      ));
      messageList.add(appendUi);}
    else if(type == MessageNodeType.Sound){//语言消息
      Widget appendUi = Container(margin:EdgeInsets.only(bottom: 20.0),child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          //头像先写死了，暂时不知道怎么获取这个东西
//          _TextUiWidgetSound(node, true, countSound),
          SoundWidget(this, node, true, countSound),
          SizedBox(width: 10.0,),
          _getHeadImg(myHeadImg),
          SizedBox(width: 20.0,)
        ],
      ));
      countSound++;
      messageList.add(appendUi);}
    else if(type == MessageNodeType.Custom){//视频通话
      CustomMessageNode textNode = node.elemList[0] as CustomMessageNode;
      Widget appendUi;
      if(textNode.data == "getPhone"){
          appendUi = Container(margin:EdgeInsets.only(bottom: 20.0),child:Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _TextVideoWidget("请求交换联系方式",true,Icons.phone_android),
              SizedBox(width: 10.0,),
              _getHeadImg(myHeadImg),
              SizedBox(width: 20.0,)
            ],
          ));
      }else{
        List<String> nodeList = textNode.data.split(".");
        if(nodeList[0] == "transfer"){
            appendUi = Container(margin:EdgeInsets.only(bottom: 20.0),child:Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                //头像先写死了，暂时不知道怎么获取这个东西
                _transferUiWidget(nodeList[1],true),
                SizedBox(width: 10.0,),
                _getHeadImg(myHeadImg),
                SizedBox(width: 20.0,)
              ],
          ));
        }else{
           appendUi = Container(margin:EdgeInsets.only(bottom: 20.0),child:Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              //头像先写死了，暂时不知道怎么获取这个东西
              _TextVideoWidget(textNode.data.split(',')[0],true,Icons.videocam),
              SizedBox(width: 10.0,),
              _getHeadImg(myHeadImg),
              SizedBox(width: 20.0,)
            ],
          ));
      }}
      messageList.add(appendUi);}

    messageList.add(SizedBox(height: 5.0));
  }

  List boolList = [];
  int boolListIndex = -1;

  refreshUiIsGet(MessageNodeType type,MessageEntity node){
    sessionLast = node.sender;
    if(1==0){return;}
    else if(type == MessageNodeType.Text){//文本
      TextMessageNode textNode = node.elemList[0] as TextMessageNode;
      Widget appendUi = Container(margin:EdgeInsets.only(bottom: 20.0),child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //头像先写死了，暂时不知道怎么获取这个东西
          SizedBox(width: 20.0,),
          _getHeadImg(hisHeadImg),
          SizedBox(width: 10.0,),
          _TextUiWidget(textNode.content,false),
        ],
      ));
      messageList.add(appendUi);}
    else if(type == MessageNodeType.Image){//图片
      ImageMessageNode imageNode = node.elemList[0] as ImageMessageNode;
      Widget appendUi = Container(margin:EdgeInsets.only(bottom: 20.0),child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //头像先写死了，暂时不知道怎么获取这个东西
          SizedBox(width: 20.0,),
          _getHeadImg(hisHeadImg),
          SizedBox(width: 10.0,),
          _TextUiWidgetImg((imageNode.path!=null&&imageNode.path!="")?imageNode.path:imageNode.imageData[ImageType.Original].url,false),
        ],
      ));
      messageList.add(appendUi);}
    else if(type == MessageNodeType.Sound){
      Widget appendUi = Container(margin:EdgeInsets.only(bottom: 20.0),child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //头像先写死了，暂时不知道怎么获取这个东西
          SizedBox(width: 20.0,),
          _getHeadImg(hisHeadImg),
          SizedBox(width: 10.0,),
//          _TextUiWidgetSound(node, false, countSound),
          SoundWidget(this, node, false, countSound)
        ],
      ));
      countSound++;
      messageList.add(appendUi);}
    else if(type == MessageNodeType.Custom){//视频通话
      CustomMessageNode textNode = node.elemList[0] as CustomMessageNode;
      Widget appendUi;
      if(textNode.data == "getPhone"){
        if(node.read){
          appendUi = Container(margin: EdgeInsets.only(bottom: 20.0), child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //头像先写死了，暂时不知道怎么获取这个东西
              SizedBox(width: 20.0,),
              _getHeadImg(hisHeadImg),
              SizedBox(width: 10.0,),
              _TextVideoWidget("已失效", false,Icons.phone_android),
            ],
          ));
        }else{
          boolList.add(true);
          boolListIndex++;
          int index = boolListIndex;
          appendUi = Container(margin: EdgeInsets.only(bottom: 20.0), child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //头像先写死了，暂时不知道怎么获取这个东西
              SizedBox(width: 20.0,),
              _getHeadImg(hisHeadImg),
              SizedBox(width: 10.0,),
              ZdyPhoneWidget(this)
            ],
          ));
        }
      }else{
        List<String> nodeList = textNode.data.split(".");
        if(nodeList[0] == "transfer"){
          appendUi = Container(margin:EdgeInsets.only(bottom: 20.0),child:Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              //头像先写死了，暂时不知道怎么获取这个东西
              SizedBox(width: 20.0,),
              _getHeadImg(hisHeadImg),
              SizedBox(width: 10.0,),
              _transferUiWidget(nodeList[1],false),
            ],
          ));
        }else{
          appendUi = Container(margin: EdgeInsets.only(bottom: 20.0), child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //头像先写死了，暂时不知道怎么获取这个东西
              SizedBox(width: 20.0,),
              _getHeadImg(hisHeadImg),
              SizedBox(width: 10.0,),
              _TextVideoWidget(textNode.data.split(',')[0], false,Icons.videocam),
            ],
          ));
      }}
      messageList.add(appendUi);}

    messageList.add(SizedBox(height: 5.0));
  }

  //头像组件
  Widget _getHeadImg(String path){
    return GestureDetector(behavior: HitTestBehavior.opaque,child:Container(
        padding: EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        child:ClipOval(child: Image.network(path,width: 40.0,height: 40.0,fit: BoxFit.fitWidth,),))
      ,onTap: (){
        if(path==hisHeadImg && hisUserId!=""){
          Get.to(UserDetailRoute(userId: hisUserId,isCanGotoChat: false,));
        }
      },
    );
  }

  //音视频消息
  Widget _TextVideoWidget(String data,bool flag,IconData iconData){
    String texts = "";
    if(1==0){return null;}
    else if(data == StorageManager.RTC_YAOQING){texts = "邀请通话";}
    else if(data == StorageManager.RTC_JUJUE){texts = "拒绝了邀请";}
    else if(data == StorageManager.RTC_FANMANG){texts = "正在其他通话";}
    else if(data == StorageManager.RTC_QUXIAO){texts = "取消了邀请";}
    else if(data == StorageManager.RTC_JIESHOU){texts = "接受了语音邀请";}
    else{texts = data;}
    if(flag){
      return Container(
        constraints: BoxConstraints(maxWidth: 250.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color.fromRGBO(79, 154, 247, 1),
        ),
        child: Row(children: <Widget>[
          Icon(iconData,color: Colors.white,),
          Text(texts,style: TextStyle(color: Colors.white,fontSize: 15.0,),),
        ],mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.center,)
      );
    }else{
      return Container(
        constraints: BoxConstraints(maxWidth: 250.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white
        ),
        child: Row(children: <Widget>[
          Icon(iconData,color: Color.fromRGBO(79, 154, 247, 1),),
          Text(texts,style: TextStyle(color: Colors.black,fontSize: 15.0,),),
        ],mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.center,)
      );
    }
  }

  //消息组件
  Widget _TextUiWidget(String text,bool flag){
    if(flag){
      return Container(
        constraints: BoxConstraints(maxWidth: 250.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color.fromRGBO(79, 154, 247, 1),
        ),
        child: Text(text,style: TextStyle(
          color: Colors.white,fontSize: 15.0,
        ),
          //        strutStyle: StrutStyle(height: 8.0),
        ),
      );
    }else{
      return Container(
        constraints: BoxConstraints(maxWidth: 250.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white
        ),
        child: Text(text,style: TextStyle(
          color: Colors.black,fontSize: 15.0,
        ),
          //        strutStyle: StrutStyle(height: 8.0),
        ),
      );
    }
  }

  //消息组件
  Widget _transferUiWidget(String text,bool flag){
      return Container(
        constraints: BoxConstraints(minWidth: 250.0,maxHeight: 500),
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        decoration: BoxDecoration(
          color: UiUtil.getColor(80,num1: 154,num2: 249),
        ),
        child: Text(flag?"成功转账给对方${text}U币":"对方转账给你${text}U币,已存入你的余额",style: UiUtil.getTextStyle(255, 13.0),textAlign: TextAlign.center,),
      );
  }


  //消息组件---图片
  Widget _TextUiWidgetImg(String text,bool flag){
    if(flag){
      return Container(
        constraints: BoxConstraints(maxWidth: 250.0),
        padding: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color.fromRGBO(79, 154, 247, 1),
        ),
        child: Image.file(File(text),fit: BoxFit.fitWidth,),
      );
    }else{
      return Container(
        constraints: BoxConstraints(maxWidth: 250.0),
        padding: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white
        ),
        child: Image.network(text,fit: BoxFit.fitWidth,loadingBuilder: (context,child,loadingProgress){
          if(loadingProgress==null){return child;}
          return CircularProgressIndicator(
            value: loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
          );
        },),
      );
    }
  }
}


class ZdyPhoneWidget extends StatefulWidget{
  ChatDomeProvider chatDomeProvider;
  ZdyPhoneWidget(this.chatDomeProvider);

  @override
  _ZdyPhoneWidget createState() => _ZdyPhoneWidget();
}
class _ZdyPhoneWidget extends State<ZdyPhoneWidget>{

  bool showBool = true;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          constraints: BoxConstraints(maxWidth: 250.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Color.fromRGBO(79, 154, 247, 1),
          ),
          child: Row(children: <Widget>[
            Icon(Icons.phone_android,color: Colors.white,),
            Text("对方请求获取你的联系方式",style: TextStyle(color: Colors.white,fontSize: 15.0,),),
          ],mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.center,)
      ),
      SizedBox(height: 10.0,),
      showBool?Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(behavior: HitTestBehavior.opaque,child: UiUtil.getContainer(30.0, 10.0,
              Color.fromRGBO(79, 154, 247, 1), Text("同意",style: UiUtil.getTextStyle(0, 13.0,isBold: true),),mWidth: 70.0),
            onTap: (){
            setState(() {
              showBool = false;
            });
              widget.chatDomeProvider.text = g_accountManager.currentUser.phonenumber;
              widget.chatDomeProvider.sendMessage(MessageNodeType.Text);
            },),
          SizedBox(width: 20.0,),
          GestureDetector(behavior: HitTestBehavior.opaque,child: UiUtil.getContainer(30.0, 10.0,
              Colors.red, Text("拒绝",style: UiUtil.getTextStyle(255, 13.0,isBold: true),),mWidth: 70.0),
            onTap: (){
              setState(() {
                showBool = false;
              });
              widget.chatDomeProvider.text = "拒绝交换联系方式";
              widget.chatDomeProvider.sendMessage(MessageNodeType.Text);
            },),

        ],):SizedBox.shrink()
    ],);
  }
}



//自定义语音消息组件
class SoundWidget extends StatefulWidget{

  ChatDomeProvider chatDomeProvider;
  MessageEntity node;
  bool flag;
  int index;
  SoundWidget(this.chatDomeProvider, this.node, this.flag, this.index);

  @override
  _SoundWidgetState createState()=>_SoundWidgetState(this.chatDomeProvider, this.node, this.flag, this.index);
}
class _SoundWidgetState extends State<SoundWidget> with TickerProviderStateMixin{
  ChatDomeProvider model;
  MessageEntity node;
  bool flag;
  int index;
  int mill;

  AnimationController _controller;
  Animation<double> animation;
  var borderWidth = BorderSide.none;

  _SoundWidgetState(this.model, this.node, this.flag, this.index);


  @override
  void initState() {
    mill = (node.elemList[0] as SoundMessageNode).duration;
    super.initState();
    _controller = AnimationController(vsync:this,duration: Duration(milliseconds: mill));
    animation = new Tween(begin: 56.0,end:0.0).animate(_controller)..addListener(() {setState(() {
      if(_controller.isCompleted){
//        borderWidth = BorderSide.none;
        _controller.reset();
      }
    });});
    model.soundIconList.add(_controller);
  }

  @override
  Widget build(BuildContext context) {
    int second = (mill/1000).round();
    Color color = Colors.white;
    Color playItems = Color.fromRGBO(79, 154, 247, 1);
    Color colorBack = Color.fromRGBO(255, 255, 255, 0.4);
    if(flag){
      color = Color.fromRGBO(79, 154, 247, 1);
      playItems = Colors.white;
      colorBack = Color.fromRGBO(79, 154, 247, 0.4);
    }
    return Container(
      constraints: BoxConstraints(maxWidth: 250.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: color,
      ),
      child: GestureDetector(
        child: Container(height:34.0,child:Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(width: 12.0,),
            Stack(alignment:Alignment.centerRight,children: <Widget>[
              Container(height: 34.0,child:Row(mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(width: 4.0,height: 10.0,color: playItems,margin: EdgeInsets.only(left: 4.0),),
                  Container(width: 4.0,height: 12.0,color: playItems,margin: EdgeInsets.only(left: 4.0),),
                  Container(width: 4.0,height: 6.0,color: playItems,margin: EdgeInsets.only(left: 4.0),),
                  Container(width: 4.0,height: 17.0,color: playItems,margin: EdgeInsets.only(left: 4.0),),
                  Container(width: 4.0,height: 10.0,color: playItems,margin: EdgeInsets.only(left: 4.0),),
                  Container(width: 4.0,height: 8.0,color: playItems,margin: EdgeInsets.only(left: 4.0),),
                  Container(width: 4.0,height: 11.0,color: playItems,margin: EdgeInsets.only(left: 4.0),),
                ],)),
              Container(height: 34.0,width: animation.value,decoration: BoxDecoration(
                  color: colorBack,
//                      border: Border(left: borderWidth)
                  border: Border(left: BorderSide(color: color))
              ),),
            ]),
            SizedBox(width: 10.0,),
            Text("$second\"",style: TextStyle(
                color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold
            ),),
            SizedBox(width: 12.0,),
          ],)
        ),
        onTap: (){
          model.playSound(index, node, mill);
//          if(_controller.isAnimating){
//            _controller.reset();
//          }else{
//            model.stopAnimationController();
//            _controller.forward();
//          }
        },
      ),
    );
  }
}


class ChatRoute extends StatefulWidget{
  
  String sessionId = "";
  Map hisUserInfo;

  ChatRoute(this.sessionId,this.hisUserInfo);

  @override
  _ChatDomeImp createState()=>_ChatDomeImp(sessionId);
}
class _ChatDomeImp extends State<ChatRoute> with WidgetsBindingObserver,TickerProviderStateMixin{

  String sessionId = "";

  _ChatDomeImp(this.sessionId);

  ScrollController scrollController = ScrollController();

  StreamSubscription _streamSubscription;
  //录制的最长时长（秒）
  final int MaxVoiceSecond = 60;

  //当前已录制的时长
  int nowVoiceSecond = 0;

  double _x = 0.0,_y = 0.0;

  TextEditingController _controller = new TextEditingController();


  AnimationController _animationController;
  Animation<double> _animation;

  double windowX = 0.0;
  double windowY = 0.0;

  bool isCanSendSound = true;
  ImProvider imProvider;

  @override
  void initState() {
    print("========================================>进来的sessionId：-->$sessionId");
    
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _animationController = new AnimationController(vsync: this,duration: Duration(milliseconds: 350));
    _animation = Tween<double>(begin: 0.0,end: 200.0).animate(_animationController)..addListener((){setState(() {});});
  }


  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    imProvider.inWhereSessionId = "";
//    if(_chatDomeProvider.sessionLast==sessionId){
      TencentImPlugin.setRead(sessionId: sessionId, sessionType: SessionType.C2C).then((value){
//        imProvider.initListChat();
//        super.dispose();
//    }else{
      imProvider.initListChat();
      });
//    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  //开始录制语音
  void startRecorderSound(ChatDomeProvider model) async{
    try{
      String path = await flutterSound.startRecorder(bitRate: 320000);
      model.soundPath = path;
//      print("开始录制------>$path<------开始录制");
      _streamSubscription = flutterSound.onRecorderStateChanged.listen((event) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            event.currentPosition.toInt(),isUtc: true
        );
        //声音大小的监听（注释掉）
//        flutterSound.onRecorderDbPeakChanged.listen((event) {
//          if(event!=null){
//            model.dbSound = model.dbSound + event.floor().toString();
//          }
//        });
//         print("----${date.millisecondsSinceEpoch}");
        model.timeLen = date.millisecondsSinceEpoch;
        model.setLongTime(DateFormat('mm:ss:SS','en_GB').format(date).substring(0,5));
      });
    }catch(e){
      print("throw error----->$e");
    }
  }


  //停止录音
  void stopRecorderSound(ChatDomeProvider model) async{
    try{
      String result = await flutterSound.stopRecorder();

      if(_streamSubscription != null){
        _streamSubscription.cancel();
        _streamSubscription = null;
      }
//      print("录制完成------>$result<------录制完成--->${model.dbSound}");
      model.soundPath = result;
    }catch(e){
      print("throw error----->$e");
    }
  }


  //build---------------------------
  @override
  Widget build(BuildContext context) {

    //获取屏幕的逻辑像素坐标x-y轴最大值
    windowX = MediaQuery.of(context).size.width;
    windowY = MediaQuery.of(context).size.height;

    imProvider = Provider.of<ImProvider>(context);
    imProvider.intoSessionChat(sessionId);
    return BaseView(
      model: ChatDomeProvider(),
      onReady: (model){
        model.toSessionId = sessionId;
        model.animationController = _animationController;
        model.hisHeadImg = widget.hisUserInfo["headPortraitUrl"]??=ImProvider.DEF_HEAD_IMAGE_URL;
        model.init(scrollController,imProvider.mySessionId);
      },
      onDispose: (model){
        model.dis();
      },
      builder: (context,model,child){
        return GestureDetector(
            behavior: HitTestBehavior.translucent, onTap:(){FocusScope.of(context).requestFocus(FocusNode());if(model.showFlag){model.setShowFlag(false);}},child:Scaffold(
            backgroundColor: Color.fromRGBO(235, 235, 235, 1),
            appBar: PreferredSize(child:AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              elevation: 0,
              //leading-----------
              leading: IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon,"nav_back_black.png")), onPressed: (){
                //点击返回
                Navigator.of(context)..pop();
              }),

              //title----------
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.hisUserInfo["name"] ?? "",style: TextStyle(
                          fontWeight: FontWeight.bold,fontSize: 17.0,color: Color.fromRGBO(51, 51, 51, 1)
                      ),),
                      Icon(Icons.notifications,color: Color.fromRGBO(33, 187, 137, 1),)
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.hisUserInfo["companyName"] ?? "",style: TextStyle(color:Color.fromRGBO(102, 102, 102, 1),fontSize: 11.0 ),),
//                      SizedBox(width: 5.0,),
//                      Text("人事专员",style: TextStyle(color:Color.fromRGBO(102, 102, 102, 1),fontSize: 11.0 ),),
                    ],
                  )
                ],
              ),

              //action
              actions: <Widget>[
                IconButton(icon: Icon(Icons.scatter_plot), onPressed: (){
                  print("点击了action");
                }),
                SizedBox(width: 20.0,)
              ],
            ), preferredSize: Size(double.infinity,44.0)),
            body: RefreshIndicator(child:_getBody(context, model),onRefresh: () async {model.reFreshChatListMore();},)
        ));
      },
    );
  }

  Widget _getBody(BuildContext context,ChatDomeProvider model){

    return Stack(children: <Widget>[Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[

//              Container(
//                height: 90.0,
//                color: Colors.white,
//                width: 400.0,
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: <Widget>[
//                    _getTopItem(model,context),
//                  ],
//                ),
//              )

        //提示框
        Visibility(visible:false,child: Container(
          width: 400.0,height: 40.0,
          color: Color.fromRGBO(255, 245, 217, 1),
          child: Text("提示框",style: TextStyle(color: Color.fromRGBO(206, 163, 44, 1)),),
        )),

        Expanded(child: ListView(
          controller: scrollController,
          padding: EdgeInsets.only(top: 10.0),
          physics: BouncingScrollPhysics(),
          children: model.messageList.map((e){
            return e;
          }).toList(),
        ),),

        Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(minHeight: 50.0),
            child:Column(children: <Widget>[Row(
              children: <Widget>[
                SizedBox(width: 20.0,),
                Expanded(child: TextField(
                  maxLines: 5,
                  minLines: 1,
                  controller: _controller,
                  decoration: InputDecoration(
                      hintText: "新消息",
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1),
                        fontSize: 15.0,
                      ),
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                  ),
                  onChanged: (value){
                    if(value!=null && value!=""){
                      model.text = value;
                      if(model.iconFlag){
                        model.setIconFlag(false);
                      }
                    }else{
                      model.setIconFlag(true);
                    }
                  },
                  onTap: (){
                    if(model.showFlag){model.setShowFlag(false);}
                  },
                )),

                IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryChat,"vo2586.png")),
                    onPressed: () async{
                      if(await Permission.camera.request().isGranted){
                          model.text = StorageManager.RTC_YAOQING+','+"1";
                          model.sendMessage(MessageNodeType.Custom);
                          Get.to(VideoRtcChat(g_accountManager.currentUser.tXIMUser.txUserid,imgUrl:model.hisHeadImg,chatDomeProvider: model));
                      }else{
                        print("权限拒绝");
                      }
                    }),

                IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryChat,"sound2587.png")),
                    onPressed: () async{
                      if(await Permission.microphone.request().isGranted){
                        model.text = StorageManager.RTC_YAOQING+','+"2";
                        model.sendMessage(MessageNodeType.Custom);
                        Get.to(AudioRtcWait(sessionId));
                      }else{
                        print("权限拒绝");
                      }
                    }),

                model.iconFlag ? IconButton(icon: Icon(Icons.control_point,color: Colors.blue,), onPressed: (){
                  FocusScope.of(context).requestFocus(FocusNode());
                  if(model.showFlag){
                    model.setShowFlag(false);
                  }else{
                    model.setShowFlag(true);
                    Future.delayed(Duration(milliseconds: 300)).then((value){
                      scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut
                      );
                    });
                  }
                }) : IconButton(icon: Icon(Icons.send), onPressed: (){
                  _controller.text = "";
                  model.setIconFlag(true);
                  model.sendMessage(MessageNodeType.Text);
                }),
              ],
            ),

              Visibility(visible: model.showFlag,child:Container(
                  width: MediaQuery.of(context).size.width,
//              height: 200.0,
                  height: _animation.value,
                  padding: EdgeInsets.only(left: 10.0,right: 10.0),
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Color.fromRGBO(222, 222, 222, 1),))
                  ),
                  child: _getBottomItem(model, context, model.botItemFlag)))
            ],))
      ],
    )],);
  }

  Widget _getBottomItem(ChatDomeProvider model,BuildContext context,int posIndex){
    if(posIndex==0){//选项列表
      return Wrap(
        children: <Widget>[

          GestureDetector(behavior:HitTestBehavior.opaque,child:Container(
              width: 80.0,
              height: 100.0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.image,size: 45.0,color: Color.fromRGBO(120, 120, 120, 1),),
                    Text("图片",style: TextStyle(
                        color: Color.fromRGBO(77, 77, 77, 1),
                        fontSize: 15.0
                    ),)
                  ])),
            onTap: (){
              ImagePicker.pickImage(source: ImageSource.gallery).then((value){
                if(value!=null){
                  model.text = value.absolute.path;
                  print(model.text);
                  model.sendMessage(MessageNodeType.Image);
                }
              });
            },),

          GestureDetector(behavior:HitTestBehavior.opaque,child:Container(
              width: 80.0,
              height: 100.0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.keyboard_voice,size: 45.0,color: Color.fromRGBO(120, 120, 120, 1),),
                    Text("语音",style: TextStyle(
                        color: Color.fromRGBO(77, 77, 77, 1),
                        fontSize: 15.0
                    ),)
                  ])),
            onTap: () async{
              //语音录制
              if(await Permission.microphone.request().isGranted){
                model.setBotItemFlag(1);
              }else{
                BotToast.showText(text: "拒绝了麦克风权限");
              }

            },),

          GestureDetector(behavior:HitTestBehavior.opaque,child:Container(
              width: 80.0,
              height: 100.0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.chat,size: 45.0,color: Color.fromRGBO(120, 120, 120, 1),),
                    Text("常用语",style: TextStyle(
                        color: Color.fromRGBO(77, 77, 77, 1),
                        fontSize: 15.0
                    ),)
                  ])),
            onTap: (){
              showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context){
                    return ChooseScrollFragment(model.chatCYY);
                  }
              ).then((value){
                if(value!=null){
                  model.text = model.chatCYY[value];
                  model.sendMessage(MessageNodeType.Text);
                }
              });
            },),

          GestureDetector(behavior:HitTestBehavior.opaque,child:Container(
              width: 80.0,
              height: 100.0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.phone_android,size: 45.0,color: Color.fromRGBO(120, 120, 120, 1),),
                    Text("交换电话",style: TextStyle(
                        color: Color.fromRGBO(77, 77, 77, 1),
                        fontSize: 15.0
                    ),)
                  ])),
            onTap: (){
              model.text = "getPhone";
              model.sendMessage(MessageNodeType.Custom);
            },),

          GestureDetector(behavior:HitTestBehavior.opaque,child:Container(
              width: 80.0,
              height: 100.0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.phone_android,size: 45.0,color: Color.fromRGBO(120, 120, 120, 1),),
                    Text("转U币",style: TextStyle(
                        color: Color.fromRGBO(77, 77, 77, 1),
                        fontSize: 15.0
                    ),)
                  ])),
            onTap: (){
              Get.to(Transfer({'userid':model.hisUserId,'headImageUrl':model.hisHeadImg,'userName':widget.hisUserInfo["name"] ?? ""})).then((value){
                if(value!=null){
                  // todo----->
                  model.text = "transfer.${value}";
                  model.sendMessage(MessageNodeType.Custom);
                }
              });
            },),


        ],);
    }else if(posIndex == 1){//发送语音
      return Stack(children: <Widget>[Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(model.longTime,style: TextStyle(color: Color.fromRGBO(51, 51, 51, 0.7),fontSize: 15.0,fontWeight: FontWeight.bold),),
              SizedBox(height: 10.0,),
              ClipOval(child:
              Container(width: 100,height: 100,
                decoration: model.isSoundOn?BoxDecoration(
//                    gradient: LinearGradient(colors: [Colors.blueAccent,Colors.blue],
//                        begin: Alignment.center
//                    )
                color:model.staSound['colorBack'],
                  border: model.staSound['border'],
                  borderRadius: BorderRadius.circular(50.0),
                ):BoxDecoration(
                  image:DecorationImage(image: AssetImage("assets/gif/sound.gif")),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: model.isSoundOn?Image.asset(join(AssetsUtil.assetsDirectoryChat,"yyb.png"),color: model.staSound['iconColor'],):SizedBox.shrink(),
              ),),
              Text("${model.staSound['text']}",style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1),fontSize: 12.0),),
            ],),

          onLongPress: (){
            model.changeSoundStyle();
            model.setIsShowLJT(true);
            print("长按开始");
            startRecorderSound(model);
          },

          //监听长按时用户移动的坐标
          onLongPressMoveUpdate: (e){
            _x = windowX - 50.0 - e.globalPosition.dx;
            _y = windowY - 100 - e.globalPosition.dy;
            if( 0.0<_x && _x<50.0 && 0.0<_y && _y<50.0){
              if(isCanSendSound){
                model.changeColorQx(true);
                isCanSendSound = false;
              }
            }else if(!isCanSendSound){
              model.changeColorQx(false);
              isCanSendSound = true;
            }
          },
//          onPanEnd: (DragEndDetails e){
//            model.changeSoundStyle();
//          },


          onLongPressUp: () async{
            print("长按结束$isCanSendSound");
            model.changeColorQx(false);
            model.changeSoundStyle();
            model.setIsShowLJT(false);
            stopRecorderSound(model);
            if(model.timeLen>1000 && isCanSendSound){
              model.sendMessage(MessageNodeType.Sound);
              model.setBotItemFlag(0);
            }else{
              if(!isCanSendSound){
                BotToast.showText(text: "发送被取消了");
              }else{
                BotToast.showText(text: "说话时长太短啦");
              }
            }
          },

        ),
      ),
        Visibility(visible:model.isShowLJT,child:Positioned(
            top: 50.0,
            right: 50.0,
            child:ClipOval(child: Container(
              width: 50.0,height: 50.0,
              color: model.colorQx,
              child: Image.asset(join(AssetsUtil.assetsDirectoryChat,"sch.png")),
            ),),),)

      ],);
    }
  }
}