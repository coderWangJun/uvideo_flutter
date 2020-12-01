import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:youpinapp/utils/assets_util.dart';

class RingWaiting extends StatefulWidget {
  @override
  _RingWaitingState createState() => _RingWaitingState();
}


class _RingWaitingState extends State<RingWaiting> {

  @override
  Widget build(BuildContext context) {
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
                _buildAppBar(context), Expanded(child:
                Padding(
                        padding: EdgeInsets.only(top: 50, bottom: 75),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Center(child: Image.asset(join("assets/gif/ppdx.gif"),height: 10.0,),),
                            _buildBottomWidgets(),
                          ],
                        )
                    )
                )
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'nav_back.png')),
            onPressed: (){
              Get.back();
            },
          ),
          SizedBox.shrink()
        ],
      ),
    );
  }


  Widget _buildBottomWidgets() {
    return Column(
      children: <Widget>[
        Text('正为你后台匹配中...', style: TextStyle(fontSize: 13, color: Color.fromRGBO(208, 208, 208, 1))),
      ],
    );
  }
}