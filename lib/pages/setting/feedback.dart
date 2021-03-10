import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/pages/home/home_grid.dart';
import 'package:youpinapp/pages/login/login_route.dart';
import 'package:youpinapp/pages/setting/fraud_prevention_guidelines.dart';
import 'package:youpinapp/utils/uiUtil.dart';
import 'package:get/get.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/agreement/agreement_detail_route.dart';

class FeedBack extends StatefulWidget {
  final String title;
  FeedBack({Key key, @required this.title}) : super(key: key);

  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  TextEditingController _feedbackController;

  @override
  void initState() {
    super.initState();
    _feedbackController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _requestFocusFn(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _submit() {
    String _val = _feedbackController.text.trim();
    if (_val == null || _val.isEmpty) {
      BotToast.showText(text: '${widget.title}不能为空!');
      return;
    }
    BotToast.showLoading();
    Future.delayed(Duration(seconds: 2), () {
      BotToast.cleanAll();
      setState(() {
        _feedbackController.clear();
      });
      BotToast.showText(text: '${widget.title}提交成功。');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, //输入框抵住键盘
      backgroundColor: Colors.white,
      appBar: UiUtil.getAppBar("${widget.title}"),
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => _requestFocusFn(context),
          child: Column(
            children: <Widget>[
              _buildInput(),
              _buildSubmit(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmit(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: ColorConstants.themeColorBlue,
      ),
      child: FlatButton(
        onPressed: _submit,
        child: Text(
          '提交',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: TextField(
        controller: _feedbackController,
        style: TextStyle(
          fontSize: 15,
          color: Color.fromRGBO(1, 1, 1, 0.5),
        ),
        maxLength: 200,
        maxLines: 6,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromRGBO(0, 0, 0, 0.06),
          border: InputBorder.none,
          hintText: '请输入需要录入的信息',
          hintStyle: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            fontSize: 14,
            letterSpacing: 3,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
        ),
      ),
    );
  }
}
