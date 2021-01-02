
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youpinapp/models/account_model.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/widgets/empty_widget.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/app/account.dart';
class MyFensList extends StatefulWidget {
  @override
  _MyFensListState createState() => _MyFensListState();
}

class _MyFensListState extends State<MyFensList> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<AccountModel> list = List<AccountModel>();


  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWhite(title: "我的粉丝"),
      body: SmartRefresher(
        enablePullDown: false,
        enablePullUp: false,
        controller: _refreshController,
        child: ListView.builder(itemBuilder:  (context, index) {
          if(list.isEmpty){
            return EmptyWidget(showTitle: "空空如也");
          }
          return EmptyWidget(showTitle: "空空如也");
        }),
      ),
      );
  }


}

void getData() {
  DioUtil.request("/user/getUserFansList",parameters: {'userid':g_accountManager.currentUser.id}).then((responseData) {
    bool success = DioUtil.checkRequestResult(responseData, showToast: false);
    if (success) {
      var json = responseData["data"];


    }
  });
}
