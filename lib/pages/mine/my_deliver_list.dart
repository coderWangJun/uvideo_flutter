import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/widgets/empty_widget.dart';

class MyDeliverList extends StatefulWidget {
  @override
  _MyDeliverListState createState() => _MyDeliverListState();
}

class _MyDeliverListState extends State<MyDeliverList> {





  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWhite(title: "我的投递"),
      body: EmptyWidget(showTitle: "空空如也"),
      );
  }


}
