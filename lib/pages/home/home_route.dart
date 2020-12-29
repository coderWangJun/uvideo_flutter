import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_view/flutter_flip_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:youpinapp/app/app.dart';
import 'package:youpinapp/pages/home/home_list_widget.dart';
import 'package:youpinapp/pages/home/home_video_widget.dart';
import 'package:youpinapp/pages/setting/updataApp.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/event_bus.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _curvedAnimation;

  _HomeRouteState() {
    _animationController =
    new AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _curvedAnimation =
    new CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    // FlipView切换事件
    g_eventBus.on(GlobalEvent.mainFlipSwitch, (reverse) {
      if (_animationController.isAnimating) {
        return;
      } else if (reverse) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    DioUtil.request("/sysInfo/getSYSInfo", method: 'GET').then((value) {
      if (DioUtil.checkRequestResult(value)) {
        if (value['data'] != null) {
          num versionCode = value['data']['updateF'] as num;
          if (versionCode > App.VERSIONCODE) {
            Get.to(UpDataApp(mapParam: value['data'] as Map,));
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);

    return FlipView(
        animationController: _curvedAnimation,
        // front: HomeVideoWidget() ,
        // back: HomeListWidget(),
        front: HomeListWidget(),
        back: SizedBox.shrink()
    );
  }
}