import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youpinapp/app/storage.dart';
import 'package:youpinapp/pages/agreement/agreement_detail_route.dart';
import 'package:youpinapp/pages/agreement/agreement_policy_route.dart';
import 'package:youpinapp/pages/agreement/agreement_service_route.dart';
import 'package:youpinapp/pages/home/home_route.dart';

class AgreementRoute extends StatefulWidget {
  @override
  _AgreementRouteState createState() => _AgreementRouteState();
}

class _AgreementRouteState extends State<AgreementRoute> {
  String _isAcceptAgreement = "0";
  bool _storageLoaded = false;

  @override
  void initState() {
    super.initState();

    BotToast.showLoading();
    g_storageManager.getStorage(StorageManager.keyIsAcceptAgreement).then((value) {
      _isAcceptAgreement = value ?? "0";

      if (_isAcceptAgreement == "1") {
        Get.off(HomeRoute());
      } else {
        _storageLoaded = true;
        setState(() { });
      }
    }).whenComplete(() => BotToast.closeAllLoading());
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);

    return Scaffold(
      body:
      _storageLoaded == false ? Container() :
      Stack(
        children: <Widget>[
          Center(
            child: Image.asset("assets/images/launch_img.png", width: ScreenUtil.mediaQueryData.size.width / 1.8, height: ScreenUtil.mediaQueryData.size.height / 1.8, fit: BoxFit.cover,),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: ScreenUtil.mediaQueryData.size.width,
              height: ScreenUtil.mediaQueryData.size.height,
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Container(
                  width: ScreenUtil.mediaQueryData.size.width - 60,
//                  height: 329,
//                   constraints: BoxConstraints(minHeight: 350),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: SingleChildScrollView(child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("服务协议和隐私政策", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 15,),
                            Text.rich(TextSpan(
                                children: [
                                  TextSpan(text: "请务必审阅阅读、充分理解“服务协议”和“隐私政策”各条款，包括但不限于：为了向你提供即时通信、内容分享等服务，我们需要收集你的"
                                      "设备信息、操作日志等人信息。你可以在“设置”中查看、变更、删除个人信息并管理你的授权。\n你可阅读",
                                      style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1), fontSize: 15)),
                                  TextSpan(text: "《服务协议》", style: TextStyle(color: Colors.blue.withOpacity(0.6), fontSize: 15), recognizer: TapGestureRecognizer()..onTap=() {
                                    Get.to(AgreementDetailRoute("服务协议",index: 1,));
                                  }),
                                  TextSpan(text: "和"),
                                  TextSpan(text: "《隐私政策》", style: TextStyle(color: Colors.blue.withOpacity(0.6), fontSize: 15), recognizer: TapGestureRecognizer()..onTap=() {
                                    Get.to(AgreementDetailRoute("隐私政策",index: 0,));
                                  }),
                                  TextSpan(text: "了解详细信息。如你同意，请点击“同意”开始接受我们的服务。"),
                                ]
                            )),
                          ],
                        )),
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border(top: BorderSide(color: Color.fromRGBO(237, 237, 237, 1), width: 1))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: FlatButton(
                                child: Text("暂不使用"),
                                onPressed: () {
                                  exit(0);
                                },
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: FlatButton(
                                  child: Text("同意", style: TextStyle(color: Colors.blue.withOpacity(0.6))),
                                  onPressed: () {
                                    g_storageManager.setStorage(StorageManager.keyIsAcceptAgreement, "1").then((value) => Get.off(HomeRoute()));
                                  },
                                )
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}