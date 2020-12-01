
import 'dart:convert' as convert;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/app/storage.dart';
import 'package:youpinapp/app/web_socket.dart';
import 'dart:convert' as convert;
import 'package:youpinapp/pages/ring/ring_video_calling.dart';
import 'package:youpinapp/pages/ring/ring_voice_calling.dart';
import 'package:youpinapp/pages/ring/ring_waiting.dart';
import 'package:youpinapp/utils/assets_util.dart';

class RingIndex extends StatefulWidget {
  
  var msg;

  RingIndex(this.msg);

  @override
  _RingIndexState createState() => _RingIndexState();
}

class _RingIndexState extends State<RingIndex> {

  WebSocketProvide webSo;
  String head;
  @override
  void initState() {
    super.initState();
    if(widget.msg['headPortraitUrl'] as String != null && widget.msg['headPortraitUrl'] != ""){
      head = widget.msg['headPortraitUrl'] as String;
    }else{
      head = ImProvider.DEF_HEAD_IMAGE_URL;
    }
  }


  @override
  Widget build(BuildContext context) {
    webSo = Provider.of<WebSocketProvide>(context);
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _buildTopWidgets(),
                      _buildBottomWidgets(),
                    ],
                  )
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'nav_back.png')),
            onPressed: () async{
              MsgNode mMsgNode = MsgNode(widget.msg['userid'] as String, "-2", "");
              webSo.channel.sink.add(mMsgNode.toJson());
              await webSo.closes();
              Get.back();
            },
          ),

          ///图标
          /*
          IconButton(
            icon: Image.asset(join(AssetsUtil.assetsDirectoryRing, 'btn_detail_info.png')),
            onPressed: () {
              print('aaaaa');
            },
          )
         */

        ],
      ),
    );
  }

  Widget _buildTopWidgets() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ClipOval(child:Container(width: 50.0,height: 50.0,child:Image.network(head,fit: BoxFit.cover,))),
        SizedBox(height: 10),
        Text.rich(TextSpan(
          children: [
            TextSpan(text:widget.msg['name']??="", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            TextSpan(text: '    '),
            TextSpan(text:widget.msg['positionName']??="", style: TextStyle(fontSize: 15, color: Colors.white)),
          ]
        )),
        SizedBox(height: 8),
        Text(widget.msg['companyName']??="", style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.bold)),
        Container(
          width: 185,
          height: 115,
          margin: EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(widget.msg['positionName']??="", style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
              Text(widget.msg['salary']??="", style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.location_on, color: Colors.white),
                  SizedBox(width: 6),
                  Text(widget.msg['distance']==null?"":"距我${widget.msg['distance']}", style: TextStyle(fontSize: 13, color: Color.fromRGBO(208, 208, 208, 1)))
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBottomWidgets() {
    return Column(
      children: <Widget>[
        Text('求职铃响起，请点击接听按钮...', style: TextStyle(fontSize: 13, color: Color.fromRGBO(208, 208, 208, 1))),
        SizedBox(height: 33),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Image.asset(join(AssetsUtil.assetsDirectoryRing, 'btn_ring_switch.png'), width: 36, height: 36,),
              onTap: () async{
                MsgNode mMsgNode = MsgNode(widget.msg['userid'] as String, "-2", "");
                webSo.channel.sink.add(mMsgNode.toJson());
                await webSo.closes();
                Get.back();
              },
            ),
            SizedBox(width: 35),
            InkWell(
              child: Image.asset(join(AssetsUtil.assetsDirectoryRing, 'btn_call.png'), width: 61, height: 61, fit: BoxFit.cover),
              onTap: () async{
                if(await Permission.microphone.request().isGranted){
                  Get.off(RingVoiceCalling(widget.msg));
                }else{
                  print("权限拒绝");
                }
              },
            )
          ],
        )
      ],
    );
  }
}