import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/app/web_socket.dart';
import 'package:youpinapp/pages/ring/ring_video_calling.dart';
import 'package:youpinapp/utils/assets_util.dart';

class RingYaoQing extends StatefulWidget{

  String room;
  bool flag;
  String uid = "";
  RingYaoQing(this.room,this.flag,{this.uid});

  @override
  _RingYaoQingState createState() => _RingYaoQingState();
}
class _RingYaoQingState extends State<RingYaoQing>{

  WebSocketProvide webSocket;

  @override
  Widget build(BuildContext context) {
    webSocket = Provider.of<WebSocketProvide>(context);
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(join(AssetsUtil.assetsDirectoryRing, 'bg_ring_index.png')),
                  fit: BoxFit.cover
              )
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                _buildAppBar(),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(top: 50, bottom: 75),
                        child: Center(child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(widget.flag?"对方邀请你进行视频通话":"确认邀请对方开始视频通话",style: TextStyle(color: Colors.white
                              ,fontWeight: FontWeight.bold,fontSize: 15.0
                            ),),
                            SizedBox(height: 100.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FlatButton(onPressed: () async{
                                    if(webSocket.twoPerson){
                                      MsgNode mMsgNode;
                                      if(widget.flag){
                                        mMsgNode = MsgNode(widget.uid, "-3", "");
                                      }else{
                                        mMsgNode = MsgNode(widget.uid, "-3", "notgetoff");
                                      }
                                      webSocket.channel.sink.add(mMsgNode.toJson());
                                      webSocket.saveQZLUserData("0","");
                                    }else{
                                      MsgNode mMsgNode = MsgNode(widget.uid, "-2", "");
                                      webSocket.channel.sink.add(mMsgNode.toJson());
                                      await webSocket.closes();
                                      Get.back();
                                    }
                                }, child:
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(150, 150, 150, 1),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    width: 125.0,height: 44.0,
                                    child: Center(child:Text("拒绝",style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold
                                    ),textAlign: TextAlign.center,),)
                                  )
                                ),

                                FlatButton(onPressed: () async{
                                  if(await Permission.camera.request().isGranted && await Permission.microphone.request().isGranted){
                                    if(!widget.flag){
                                      MsgNode msgNode = new MsgNode(widget.uid,"200","");
                                      webSocket.channel.sink.add(msgNode.toJson());
                                    }
                                    Get.off(VideoRtcChatQZL(widget.room,widget.uid));
                                  }else{
                                    Get.back();
                                    print("权限拒绝");
                                  }
                                }, child:
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(33, 187, 137, 1),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  width: 125.0,height: 44.0,
                                  child: Center(child:Text("同意",style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold
                                  ),textAlign: TextAlign.center),)
                                )
                                ),
                              ],
                            )
                          ],
                        ))
                    )
                )
              ],
            ),
          ),
        )
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 60,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'nav_back.png')),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}