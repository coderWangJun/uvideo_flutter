import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/utils/dio_util.dart';

class SettingPassWord extends StatefulWidget {
  @override
  _SettingPassWordState createState() => _SettingPassWordState();
}

class _SettingPassWordState extends State<SettingPassWord> {
  TextEditingController _passController = TextEditingController();
  TextEditingController _passController1 = TextEditingController();
  bool _passInputFinished = false;
  _SettingPassWordState() {

    _passController.addListener(() {
      _checkPassInputState();
    });
    _passController1.addListener(() {
      _checkPassInputState();
    });

  }
  void _checkPassInputState() {
    String pass = _passController.text;
    String pass1 = _passController1.text;

    if (pass.length > 0 && pass1.length > 0) {
      _passInputFinished = true;
    } else {
      _passInputFinished = false;
    }
    setState(() { });
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWhite(title: "设置密码"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildPassInputWidgets(),
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 20,left: 20,right: 20),
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                  color: _passInputFinished
                      ? ColorConstants.themeColorBlue
                      : ColorConstants.themeColorBlue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6)),
              child: Text('完成',
                  style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
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
    if (pass == '') {
      BotToast.showText(text: '请输入密码');
      return;
    }
    if (pass1 == '') {
      BotToast.showText(text: '请再次输入密码');
      return;
    }
    if (pass.length<6||pass.length>20||pass1.length<6||pass1.length>20) {
      BotToast.showText(text: '密码长度6-20之间');
      return;
    }
    if (pass != pass1) {
      BotToast.showText(text: '两次输入不一致');
      return;
    }
    var params = { 'phonenumber': g_accountManager.currentUser.phonenumber, 'password': pass};
    BotToast.showLoading();
    DioUtil.request('/user/setPassword', parameters: params).then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: true);
      if (success) {
        BotToast.showText(text: '设置密码成功');
        Navigator.of(context).pop();
      }
    }).whenComplete(() => BotToast.closeAllLoading());
  }

  Widget _buildPassInputWidgets() {
    return Container(
        child: Column(children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 40, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: Color.fromRGBO(237, 237, 237, 0.5), borderRadius: BorderRadius.circular(6)),
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
              prefixIcon: Icon(Icons.lock_outline, color: Color.fromRGBO(153, 153, 153, 1))),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: Color.fromRGBO(237, 237, 237, 0.5), borderRadius: BorderRadius.circular(6)),
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
              prefixIcon: Icon(Icons.lock_outline, color: Color.fromRGBO(153, 153, 153, 1))),
        ),
      ),
    ]));
  }
}
