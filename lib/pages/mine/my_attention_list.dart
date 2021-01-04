import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youpinapp/models/fens_model.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/widgets/empty_widget.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/app/account.dart';

class MyAttentionList extends StatefulWidget {
  @override
  _MyAttentionListState createState() => _MyAttentionListState();
}

class _MyAttentionListState extends State<MyAttentionList> {

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  List<FensModel> list = List<FensModel>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBarWhite(title: "我的关注"),
      body: Container(
        child: SmartRefresher(
          enablePullDown: false,
          enablePullUp: false,
          controller: _refreshController,
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (list == null || list.isEmpty) {
                return EmptyWidget(showTitle: "空空如也");
              }
              return GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 24.0),
                    decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(6.0)),
                    padding: EdgeInsets.only(top: 12,left: 20,bottom: 12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(32.0),
                          child: list[index].targetUserHeadPortrait.isNotEmpty
                              ? Image.network(
                            list[index].targetUserHeadPortrait,
                            fit: BoxFit.fill,
                            width: 48.0,
                            height: 48.0,
                          )
                              : Image.asset(
                            'assets/images/common/icon_forward_normal.png',
                            width: 32.0,
                            height: 32.0,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(list[index].name ?? "",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  '${list[index].companyName ?? ""} ${list[index].position ?? ""}',
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF666666)))
                            ]),
                      ],
                    ),
                  ),
                ),
                onTap: () {
//                  Get.to(UserDetailRoute(
//                    userId: list[index].userid,
//                    isCanGotoChat: false,
//                  ));
                },
              );
            },
            itemCount: list.isEmpty ? 1 : list.length,
          ),
        ),
      ),
    );
  }

  void getData() {
    DioUtil.request("/user/getUserCareList",
        parameters: {'userid': g_accountManager.currentUser.id})
        .then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: false);
      if (success) {
        List<dynamic> dataList = responseData['data'];
        List<FensModel> fensList = dataList.map((json) {
          return FensModel.fromJson(json);
        }).toList();
        list.addAll(fensList);
      }
      setState(() {});
      _refreshController.refreshCompleted();
    });
  }
}
