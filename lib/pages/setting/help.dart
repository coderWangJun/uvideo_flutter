import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youpinapp/app/appText.dart';
import 'package:youpinapp/utils/uiUtil.dart';

class UserHelp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: UiUtil.getAppBar("帮助与反馈"),
      body: Container(
        child: SingleChildScrollView(padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            child: Text("联系方式：\n\n     黄先生：18523453207\n     邮箱：2096221185@qq.com")
        ),
      ),
    );
  }
}