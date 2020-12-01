import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/chat/chat_data.dart';
import 'package:youpinapp/pages/chat/chat_route/chat_route.dart';
import 'package:youpinapp/pages/common/search_bar.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/dataTime_string.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/widgets/empty_widget.dart';


class ChatChatProvider with ChangeNotifier{

  init(){}
}

class ChatChat extends StatefulWidget {
  @override
  _ChatChatState createState() => _ChatChatState();
}

class _ChatChatState extends State<ChatChat> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ImProvider imProvider = Provider.of<ImProvider>(context);
    if(imProvider.dateMap.length==0){imProvider.initListChat();}//防止初始化app加载列表失败，每次重绘都判断是否存在列表，不存在就尝试刷新
    return BaseView(
      model: ChatChatProvider(),
      onReady: (model){},
      onDispose: (model){},
      builder:(context,model,child){
        return Column(children: <Widget>[
//        SearchBar('通过姓名或公司 搜索联系人'),
        Expanded(child: imProvider.dateMap.length==0?EmptyWidget(showTitle: "列表空空如也,快去聊天吧~",):ListView(children: _getList(model,imProvider))
//            itemCount: chatRecordList.length,
        )
      ]
    );},);
  }

  List<Widget> _getList(ChatChatProvider model,ImProvider imProvider){
    List<Widget> mList = [];
    imProvider.chatList.forEach((e){
      if(imProvider.dateMap[e.id]!=null){
        //Dart要求时间戳13位，乘以1000增加三位0
      DateTime timedif = DateTime.fromMillisecondsSinceEpoch(e.message.timestamp*1000).toLocal();
      String time = DataTimeToString.toTextString(timedif);
      Widget w = GestureDetector(behavior: HitTestBehavior.opaque,onTap: (){Get.to(ChatRoute(e.id,imProvider.dateMap[e.id]));},child:Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 12.5, bottom: 12.5),
        child: Row(
          children: <Widget>[
            Container(width: 55.0,height: 55.0,
              child: Stack(
                children: <Widget>[
                    ClipOval(
                      child: Container(
                        width: 55.0,height: 55.0,decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.5)
                      ),child: Image.network(imProvider.dateMap[e.id]["headPortraitUrl"]==null?"http://mingyankeji.oss-cn-chengdu.aliyuncs.com/default-head-portrait/%E4%BC%98%E8%A7%86APP%E9%BB%98%E8%AE%A4%E5%A4%B4%E5%83%8F.png1597053811548?Expires=3173853811&OSSAccessKeyId=LTAI4GDRbwvuszWXHCNebT2j&Signature=tIsYLrlR9C01liBA1UtmSriROUI%3D":imProvider.dateMap[e.id]["headPortraitUrl"],fit: BoxFit.cover,),
                      ),
                    ),
                    Visibility(visible:e.unreadMessageNum>0?true:false,child: Container(
                      margin: EdgeInsets.only(left: 35.0),
                      width: 20,height: 20,decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.red,
                    ),child: Center(child:Text("${e.unreadMessageNum}",style: TextStyle(color:Colors.white),),)
                    )),

                ],
              ),
            ),
            SizedBox(width: 10.0,),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(imProvider.dateMap[e.id]["name"]??="这个人没名字", style: TextStyle(fontSize: 15, color: ColorConstants.textColor51)),
                          SizedBox(width: 5.0),
//                          _buildJobTitle(rowData),
                          Text(imProvider.dateMap[e.id]["companyName"]??="", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Color.fromRGBO(153, 153, 153, 1)))
                        ],
                      ),
                      Text(time, style: TextStyle(fontSize: 13, color: Color.fromRGBO(153, 153, 153, 1)))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(e.message.peerReaded?"[已读]":"[未读]", style: TextStyle(fontSize: 13, color: Color.fromRGBO(153, 153, 153, 1))),
                      SizedBox(width: 3),
                      Text(e.message.note, style: TextStyle(fontSize: 13, color: ColorConstants.textColor51),overflow: TextOverflow.ellipsis,)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ));
      mList.add(w);
      }});
    return mList;
  }
}