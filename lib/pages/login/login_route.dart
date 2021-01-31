import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/agreement/agreement_policy_route.dart';
import 'package:youpinapp/pages/agreement/agreement_service_route.dart';
import 'package:youpinapp/pages/home/home_grid.dart';
import 'package:youpinapp/pages/login/verify_code_route.dart';
import 'package:youpinapp/pages/password/forget_password.dart';
import 'package:youpinapp/utils/dio_util.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  int _loginType = 1; // 1 手机号登录；2 密码登录
  bool _phoneInputFinished = false;
  bool _userNameInputFinished = false;
  TextEditingController _phoneController;
  TextEditingController _phoneController1;
  TextEditingController _passController;

  void _checkPassInputState() {
    String userName = _phoneController1.text;
    String pass = _passController.text;

    if (userName.length > 0 && pass.length > 0) {
      _userNameInputFinished = true;
    } else {
      _userNameInputFinished = false;
    }

    setState(() {});
  }

  _LoginRouteState() {
    _phoneController = TextEditingController();
    _phoneController1 = TextEditingController();
    _passController = TextEditingController();

    // _phoneController.text = '18602335806';
//    _phoneController1.text = 'user1';
//    _passController.text = '123456';

    _phoneController.addListener(() {
      int inputLength = _phoneController.text.length;

      if (inputLength == 11) {
        _phoneInputFinished = true;
      } else {
        _phoneInputFinished = false;
      }

      setState(() {});
    });

    _phoneController1.addListener(() {
      _checkPassInputState();
    });
    _passController.addListener(() {
      _checkPassInputState();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        elevation: 0,
      ),
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.only(left: 25, right: 25, top: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('手机号注册/登录',
                style: TextStyle(
                    fontSize: 24,
                    color: ColorConstants.textColor51,
                    fontWeight: FontWeight.bold)),
            Expanded(
              child: _loginType == 1
                  ? _buildPhoneLoginInputWidgets()
                  : _buildPassLoginInputWidgets(),
            ),
            _weixinLogin(),
            _buildBottomWidgets()
          ],
        ),
      )),
    );
  }

  Widget _buildPhoneLoginInputWidgets() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
                color: Color.fromRGBO(237, 237, 237, 0.5),
                borderRadius: BorderRadius.circular(6)),
            child: TextField(
              keyboardType: TextInputType.phone,
              controller: _phoneController,
              maxLength: 11,
              maxLengthEnforced: true,
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
                hintText: '请输入手机号',
                hintStyle: TextStyle(
                    fontSize: 13, color: Color.fromRGBO(153, 153, 153, 1)),
                prefixIcon: Container(
                  width: 90,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '+86',
                              style: TextStyle(
                                fontSize: 18,
                                color: ColorConstants.themeColorBlue,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 24,
                              color: ColorConstants.themeColorBlue,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 12,
                        margin: EdgeInsets.only(
                          right: 14,
                        ),
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                      ),
                    ],
                  ),
                ),
                // prefixIcon: Icon(
                //   Icons.phone_android,
                //   color: Color.fromRGBO(153, 153, 153, 1),
                // ),
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            child: Container(
              height: 48,
              width: double.infinity,
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: _phoneInputFinished
                      ? ColorConstants.themeColorBlue
                      : ColorConstants.themeColorBlue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6)),
              child: Text('下一步',
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
            onTap: () {
              if (_phoneInputFinished) {
                Get.to(VerifyCodeRoute(VerifyCodeOperType.loginOrRegister,
                    phone: _phoneController.text));
              }
            },
          ),
          ButtonTheme(
            minWidth: 0,
            child: FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.only(left: 0, right: 0),
              child: Text('账号密码登录',
                  style: TextStyle(
                      fontSize: 12,
                      color: ColorConstants.textColor51,
                      fontWeight: FontWeight.w500)),
              onPressed: () {
                setState(() {
                  _loginType = 2;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPassLoginInputWidgets() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
                color: Color.fromRGBO(237, 237, 237, 0.5),
                borderRadius: BorderRadius.circular(6)),
            child: TextField(
              controller: _phoneController1,
              maxLength: 20,
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: '',
                hintStyle: TextStyle(
                    fontSize: 13,
                    color: Color.fromRGBO(153, 153, 153, 1),
                    fontWeight: FontWeight.w500),
                hintText: '请输入手机号',
                prefixIcon: Container(
                  width: 90,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '+86',
                              style: TextStyle(
                                fontSize: 18,
                                color: ColorConstants.themeColorBlue,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 24,
                              color: ColorConstants.themeColorBlue,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 12,
                        margin: EdgeInsets.only(
                          right: 14,
                        ),
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                      ),
                    ],
                  ),
                ),
              ),
              // prefixIcon: Icon(Icons.phone_android,
              //     color: Color.fromRGBO(153, 153, 153, 1))),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: Color.fromRGBO(237, 237, 237, 0.5),
                borderRadius: BorderRadius.circular(6)),
            child: TextField(
              controller: _passController,
              obscureText: true,
              maxLength: 20,
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: '',
                hintStyle: TextStyle(
                    fontSize: 13,
                    color: Color.fromRGBO(153, 153, 153, 1),
                    fontWeight: FontWeight.w500),
                hintText: '请输入密码',
                prefixIcon: Container(
                  width: 90,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.lock_outline,
                              size: 24,
                              color: Color.fromRGBO(153, 153, 153, 1),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 12,
                        margin: EdgeInsets.only(
                          right: 14,
                        ),
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                  color: _userNameInputFinished
                      ? ColorConstants.themeColorBlue
                      : ColorConstants.themeColorBlue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6)),
              child: Text('登录',
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
            onTap: () {
              if (_userNameInputFinished) {
                _startLogin();
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ButtonTheme(
                minWidth: 0,
                child: FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.all(0),
                  child: Text('短信登录',
                      style: TextStyle(
                          fontSize: 12, color: ColorConstants.textColor51)),
                  onPressed: () {
                    setState(() {
                      _loginType = 1;
                    });
                  },
                ),
              ),
              ButtonTheme(
                minWidth: 0,
                child: FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.all(0),
                  child: Text('忘记密码？',
                      style: TextStyle(
                          fontSize: 12, color: ColorConstants.themeColorBlue)),
                  onPressed: () {
                    Get.to(ForgetPassWord());
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _weixinLogin() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        bottom: 50,
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              bottom: 20,
            ),
            child: Text(
              '或通过以下方式登录',
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.3),
                fontSize: 13,
              ),
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
            ),
            child: InkWell(
              onTap: () {},
              child: Image.asset(
                'assets/images/login/weixin.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomWidgets() {
    return Container(
      width: double.infinity,
      height: 62,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text.rich(TextSpan(children: [
            TextSpan(
                text: '阅读',
                style: TextStyle(
                    fontSize: 13, color: ColorConstants.textColor153)),
            TextSpan(
                text: '《用户协议及',
                style: TextStyle(
                    fontSize: 13, color: ColorConstants.themeColorBlue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.to(AgreementServiceRoute());
                  }),
            TextSpan(
                text: '隐私政策》',
                style: TextStyle(
                    fontSize: 13, color: ColorConstants.themeColorBlue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.to(AgreementPolicyRoute());
                  }),
          ]))
        ],
      ),
    );
  }

  void _startLogin() {
    String phone = _phoneController1.text;
    String pass = _passController.text;

    if (phone == '') {
      BotToast.showText(text: '请输入手机号');
      return;
    }

    if (pass == '') {
      BotToast.showText(text: '请输入密码');
      return;
    }

    g_accountManager.clearLocalUser();

    var params = {'username': phone, 'password': pass};
    BotToast.showLoading();
    DioUtil.request('/user/login', parameters: params).then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: true);
      if (success) {
        g_accountManager.refreshLocalUser(responseData['data']);
        Get.offAll(HomeGrid());
      }
    }).whenComplete(() => BotToast.closeAllLoading());
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }
}
