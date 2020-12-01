import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_verification_box/verification_box.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/home/home_route.dart';
import 'package:youpinapp/pages/login/choose_identity_route.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/event_bus.dart';

enum VerifyCodeOperType {
  loginOrRegister // 登录或注册
}

class VerifyCodeRoute extends StatefulWidget {
  final VerifyCodeOperType operType;
  final String phone;

  VerifyCodeRoute(this.operType, {this.phone});

  @override
  _VerifyCodeRouteState createState() => _VerifyCodeRouteState();
}

class _VerifyCodeRouteState extends State<VerifyCodeRoute> {
  bool _isCalling = false;
  int _totalTimerSeconds = 60;
  String _timerButtonTitle = '重新发送';
  Timer _countDownTimer;

  @override
  void initState() {
    super.initState();

    _requestSmsCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isCalling,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildAppBar(),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 35, left: 25, right: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('输入短信验证码', style: TextStyle(fontSize: 24, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
                            Text('已向您的手机${widget.phone}发送验证码', style: TextStyle(fontSize: 13, color: Color.fromRGBO(101, 101, 101, 1))),
                          ],
                        ),
                      ),
                      _buildVerifyBox(context),
                      _buildCountDownWidget(),
//                      _buildNextButton()
                    ],
                  )
              )
            ],
          ),
        ),
      )
    );
  }

  void _startTimer() {
    if (_countDownTimer == null) {
      _countDownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        int currentTimerSeconds = _totalTimerSeconds - timer.tick;

        if (currentTimerSeconds <= 0) {
          _timerButtonTitle = '重新发送';
          _countDownTimer.cancel();
          _countDownTimer = null;
        } else {
          _timerButtonTitle = '重新发送($currentTimerSeconds)';
        }

        setState(() { });
      });
    }
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      height: 44,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'nav_back_black.png')),
            onPressed: () {
              Get.back();
            },
          )
        ],
      ),
    );
  }

  Widget _buildVerifyBox(BuildContext parentContext) {
    // return Container(
    //   height: 45,
    //   padding: EdgeInsets.only(left: 20, right: 20),
    //   margin: EdgeInsets.only(top: 40),
    //   child: VerificationBox(
    //     showCursor: true,
    //     count: 4,
    //     type: VerificationBoxItemType.underline,
    //     onSubmitted: (value) {
    //       _loginWithVerifyCode(value);
    //     },
    //   ),
    // );
    // return Container();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: PinCodeTextField(
        length: 4,
        appContext: parentContext,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.underline,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          activeColor: Colors.blue,
          inactiveColor: Color.fromRGBO(238, 238, 238, 1),
        ),
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        // enableActiveFill: true,
        // errorAnimationController: errorController,
        // controller: textEditingController,
        onCompleted: (v) {
          _loginWithVerifyCode(v);
        },
      ),
    );
  }

  // 倒计时
  Widget _buildCountDownWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          child: Text(_timerButtonTitle, style: TextStyle(fontSize: 13, color: _countDownTimer != null ? ColorConstants.textColor153 : ColorConstants.themeColorBlue)),
          onPressed: () {
            if (_countDownTimer == null) {
              _requestSmsCode();
            }
          },
        ),
      ],
    );
  }

  // 下一步按钮
  Widget _buildNextButton() {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 25, right: 25, top: 20),
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
//        color: ColorConstants.themeColorBlue.withOpacity(0.5),
          color: ColorConstants.themeColorBlue.withOpacity(1),
          borderRadius: BorderRadius.circular(6)
        ),
        child: Center(
          child: Text('下一步', style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      onTap: () {
        Get.to(ChooseIdentityRoute());
      },
    );
  }
  
  void _requestSmsCode() {
    setState(() { _isCalling = true; });

    var params = {'phonenumber': widget.phone};
    DioUtil.request('/user/sendVcode', parameters: params).then((reponseData) {
      bool success = DioUtil.checkRequestResult(reponseData, showToast: true);
      if (success) {
        _startTimer();
      }
    }).whenComplete(() => setState(() { _isCalling = false; }));
  }

  void _loginWithVerifyCode(vcode) {
    var params = {'vcode': vcode, 'phonenumber': widget.phone};
    BotToast.showLoading();
    DioUtil.request('/user/login', parameters: params).then((responseData) async {
      bool success = DioUtil.checkRequestResult(responseData, showToast: true);
      if (success) {
        await g_accountManager.refreshLocalUser(responseData['data']);
        g_eventBus.emit(GlobalEvent.accountInitialized);
        int typeId = g_accountManager.currentUser.typeId;
        if (typeId == 1 || typeId == 2) {
          Get.offAll(HomeRoute());
        } else {
          Get.offAll(ChooseIdentityRoute());
        }
      }
    }).whenComplete(() => BotToast.closeAllLoading());
  }

  @override
  void dispose() {
    super.dispose();

    if (_countDownTimer != null) {
      _countDownTimer.cancel();
      _countDownTimer = null;
    }
  }
}