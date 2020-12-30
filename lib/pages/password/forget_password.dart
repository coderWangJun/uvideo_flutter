import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/utils/dio_util.dart';

class ForgetPassWord extends StatefulWidget {
  @override
  _ForgetPassWordState createState() => _ForgetPassWordState();
}

class _ForgetPassWordState extends State<ForgetPassWord> {
  TextEditingController _passController = TextEditingController();
  TextEditingController _passController1 = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  bool _passInputFinished = false;
  int _totalTimerSeconds = 60;
  String _timerButtonTitle = '获取验证码';
  Timer _countDownTimer;

  _ForgetPassWordState() {
    _passController.addListener(() {
      _checkPassInputState();
    });
    _codeController.addListener(() {
      _checkPassInputState();
    });
    _passController1.addListener(() {
      _checkPassInputState();
    });
    _phoneController.addListener(() {
      _checkPassInputState();
    });
  }

  void _checkPassInputState() {
    String phone = _phoneController.text;
    String code = _codeController.text;
    String pass = _passController.text;
    String pass1 = _passController1.text;

    if (pass.length > 0 &&
        pass1.length > 0 &&
        phone.length > 0 &&
        code.length > 0) {
      _passInputFinished = true;
    } else {
      _passInputFinished = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWhite(title: "修改密码"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildPassInputWidgets(),
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                  color: _passInputFinished
                      ? ColorConstants.themeColorBlue
                      : ColorConstants.themeColorBlue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6)),
              child: Text('完成',
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _settingPassWord(context);
            },
          ),
        ],
      ),
    );
  }

  void _settingPassWord(BuildContext context) {
    String pass = _passController.text;
    String pass1 = _passController1.text;
    String phone =_phoneController.text;
    String code=_codeController.text;
    if (phone == '') {
      BotToast.showText(text: '请输入手机号');
      return;
    }
    if (code == '') {
      BotToast.showText(text: '请输入短信验证码');
      return;
    }
    if (pass == '') {
      BotToast.showText(text: '请输入密码');
      return;
    }
    if (pass1 == '') {
      BotToast.showText(text: '请再次输入密码');
      return;
    }
    if (pass.length < 6 ||
        pass.length > 20 ||
        pass1.length < 6 ||
        pass1.length > 20) {
      BotToast.showText(text: '密码长度6-20之间');
      return;
    }
    if (pass != pass1) {
      BotToast.showText(text: '两次输入不一致');
      return;
    }
    var params = {
      'phonenumber': phone,
      'password': pass,
      'vcode':code,
    };
    BotToast.showLoading();
    DioUtil.request('/user/updatePasswordByPhonenumber', parameters: params)
        .then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: true);
      if (success) {
        BotToast.showText(text: '修改密码成功');
        Navigator.of(context).pop();
      }
    }).whenComplete(() => BotToast.closeAllLoading());
  }
  void _requestSmsCode() {
    String phone =_phoneController.text;
    if (phone == '') {
      BotToast.showText(text: '请输入手机号');
      return;
    }
    var params = {'phonenumber': phone};
    DioUtil.request('/user/sendVcode', parameters: params).then((reponseData) {
      bool success = DioUtil.checkRequestResult(reponseData, showToast: true);
      if (success) {
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
    }).whenComplete(() => setState(() {}));
  }
  Widget _buildPassInputWidgets() {
    return Container(
        child: Column(children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 40, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: Color.fromRGBO(237, 237, 237, 0.5),
            borderRadius: BorderRadius.circular(6)),
        child: TextField(
          controller: _phoneController,
          maxLength: 20,
          decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
              hintStyle: TextStyle(
                  fontSize: 13,
                  color: Color.fromRGBO(153, 153, 153, 1),
                  fontWeight: FontWeight.w500),
              hintText: '请输入手机号',
              prefixIcon: Icon(Icons.phone_android,
                  color: Color.fromRGBO(153, 153, 153, 1))),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: Color.fromRGBO(237, 237, 237, 0.5),
            borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _codeController,
                maxLength: 6,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    hintStyle: TextStyle(
                        fontSize: 13,
                        color: Color.fromRGBO(153, 153, 153, 1),
                        fontWeight: FontWeight.w500),
                    hintText: '请输入验证码',
                    prefixIcon: Icon(Icons.textsms_rounded,
                        color: Color.fromRGBO(153, 153, 153, 1))),
              ),
            ),
            GestureDetector(
              child: Text(
                _timerButtonTitle,
                style: TextStyle(
                    fontSize: 13,
                    color: Color.fromRGBO(153, 153, 153, 1),
                    fontWeight: FontWeight.w500),
              ),
              onTap:()=>_timerButtonTitle=='获取验证码'? _requestSmsCode():null,
            ),
            Padding(padding: EdgeInsets.only(right: 10))
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: Color.fromRGBO(237, 237, 237, 0.5),
            borderRadius: BorderRadius.circular(6)),
        child: TextField(
          controller: _passController,
          maxLength: 20,
          obscureText: true,
          decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
              hintStyle: TextStyle(
                  fontSize: 13,
                  color: Color.fromRGBO(153, 153, 153, 1),
                  fontWeight: FontWeight.w500),
              hintText: '请输入密码',
              prefixIcon: Icon(Icons.lock_outline,
                  color: Color.fromRGBO(153, 153, 153, 1))),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: Color.fromRGBO(237, 237, 237, 0.5),
            borderRadius: BorderRadius.circular(6)),
        child: TextField(
          controller: _passController1,
          obscureText: true,
          maxLength: 20,
          decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
              hintStyle: TextStyle(
                  fontSize: 13,
                  color: Color.fromRGBO(153, 153, 153, 1),
                  fontWeight: FontWeight.w500),
              hintText: '再次输入密码',
              prefixIcon: Icon(Icons.lock_outline,
                  color: Color.fromRGBO(153, 153, 153, 1))),
        ),
      ),
    ]));
  }
}
