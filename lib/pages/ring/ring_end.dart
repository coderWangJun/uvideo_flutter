import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/app/web_socket.dart';
import 'package:youpinapp/pages/chat/chat_route/chat_route.dart';
import 'package:youpinapp/pages/ring/ring_waiting.dart';
import 'package:youpinapp/utils/assets_util.dart';

class RingEnd extends StatefulWidget{

  var dateMap;
  String time;
  RingEnd(this.dateMap,this.time);

  @override
  _RingEndState createState() => _RingEndState();
}
class _RingEndState extends State<RingEnd>{

//  WebSocketProvide webSocketProvide;

  @override
  Widget build(BuildContext context) {
    int type = g_accountManager.currentUser.typeId;
//    webSocketProvide = Provider.of<WebSocketProvide>(context);
    double windonWidth = MediaQuery.of(context).size.width-30.0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(preferredSize: Size(double.infinity, 44.0),
        child:AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading:IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon,"nav_back_black.png")),onPressed: (){
            ///back返回上一步
            Navigator.of(context)..pop();
          },),
          elevation: 0.0,
        ),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(behavior: HitTestBehavior.opaque,child:Container(width:windonWidth,height:70.0,child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[Container(width: 40.0,height: 40.0,decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),child: ClipOval(child: 
                  Image.network(widget.dateMap['headPortraitUrl']??=ImProvider.DEF_HEAD_IMAGE_URL,fit: BoxFit.cover,)
                  ,),),
                SizedBox(width: 10.0,),
                Column(mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${widget.dateMap['name']??=''}",style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1),fontSize: 18.0,fontWeight: FontWeight.bold),),
                    Text("${widget.dateMap['companyName']??=''}  ${widget.dateMap['positionName']??=''}",style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1),fontSize: 13.0),),
                  ],
                ),],),
                
                Image.asset(join(AssetsUtil.assetsDirectoryCommon,"icon_forward_normal.png"))
              ],
            ),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1)))),
            ),onTap: (){
              //--------------------->去聊天
              Get.off(ChatRoute(type!=1?widget.dateMap['myTXUserid']:widget.dateMap['targetTXUserid'],{'headPortraitUrl' : widget.dateMap['headPortraitUrl']??=ImProvider.DEF_HEAD_IMAGE_URL , 'name' : widget.dateMap['name']??="" , 'companyName' : widget.dateMap['companyName']??=""}));
            },),

            Container(
              width: windonWidth,height: 60.0,decoration: BoxDecoration(border:Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("通话时长",style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1),fontSize: 13.0),),
                  SizedBox(width: 10.0,height: 60.0,),
                  Text(widget.time,style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1),fontSize: 13.0),)
                ],
              ),
            ),

            GestureDetector(child: Container(
              width: windonWidth,height: 60.0,decoration: BoxDecoration(border:Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("职位",style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1),fontSize: 13.0),),
                      SizedBox(width: 10.0,height: 60.0,),
                      Text("${widget.dateMap['salary']??=""}",style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1),fontSize: 13.0),)
                    ],
                  ),

                  Image.asset(join(AssetsUtil.assetsDirectoryCommon,"icon_forward_normal.png"))

                ],
              ),
            ),onTap: (){

            },),

            Container(width: windonWidth,height: 60.0,decoration: BoxDecoration(border:Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1)))),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[Text("距你位置${widget.dateMap['distance']??=""}",style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1),fontSize: 13.0),),
            ],),),

            SizedBox(height: 100.0,),

            FlatButton(child: Container(
              width: windonWidth,height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color.fromRGBO(79, 154, 247, 1)
              ),
              child: Center(child: Text("继续匹配",style: TextStyle(color: Colors.white,fontSize: 13.0),textAlign: TextAlign.center,),),
            ),onPressed: (){
              ///继续匹配
              Get.off(RingWaiting());
            },)
          ],
        ),
      ),
    );
  }
}