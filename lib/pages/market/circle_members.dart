import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:youpinapp/models/circle_member_model.dart';
import 'package:youpinapp/pages/common/search_bar.dart';
import 'package:youpinapp/pages/market/circle_member_row.dart';
import 'package:youpinapp/pages/market/circle_more/circle_detail.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/uiUtil.dart';

// import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:get/route_manager.dart';
import 'package:youpinapp/pages/market/circle_home.dart';

class CircleMembers extends StatefulWidget {
  final int circleId;

  CircleMembers(this.circleId);

  @override
  _CircleMembersState createState() => _CircleMembersState();
}

class _CircleMembersState extends State<CircleMembers>
    with SingleTickerProviderStateMixin {
  List<String> _titles = ['诚信分', '距离'];
  TabController _tabController;
  List<CircleMemberModel> _circleMemberList = [];

  String mainUserId = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _titles.length, vsync: this);
    _loadCircleMembers();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: CircleDetailProvider(),
      onReady: (model) {
        model.init(widget.circleId);
      },
      onDispose: (model) {},
      builder: (context, model, child) {
        return Scaffold(
            appBar: UiUtil.getAppBar(
              '圈成员',
            ),
            // appBar: PreferredSize(
            //   preferredSize: Size(double.infinity, 88),
            //   child: AppBar(
            //     elevation: 0,
            //     brightness: Brightness.light,
            //     backgroundColor: Colors.white,
            //     leading: IconButton(
            //       icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'nav_back_black.png')),
            //       onPressed: () {
            //         Navigator.of(context).pop();
            //       },
            //     ),
            //     title: Padding(
            //       padding: EdgeInsets.only(right: 50),
            //       child: Container(
            //         width: double.infinity,
            //         child: SearchBar('集圈搜索'),
            //       ),
            //     ),
            //     bottom: TabBar(
            //       controller: _tabController,
            //       labelColor: ColorConstants.textColor51,
            //       labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            //       unselectedLabelColor: Color.fromRGBO(102, 102, 102, 1),
            //       unselectedLabelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            //       indicatorWeight: 2,
            //       indicatorColor: ColorConstants.themeColorBlue,
            //       indicatorSize: TabBarIndicatorSize.label,
            //       indicatorPadding: EdgeInsets.only(bottom: 10),
            //       tabs: _titles.map((title) {
            //         return Tab(text: title);
            //       }).toList(),
            //     ),
            //   ),
            // ),
            body: Container(
                color: Colors.white,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 8.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 10.0,
                              color: Color.fromRGBO(0, 0, 0, 0.04),
                            ),
                          ),
                        ),
                        child: SearchBar('搜索'),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 20.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: "本圈成员",
                                  style: UiUtil.getTextStyle(52, 15.0)),
                            ])),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: "(",
                                  style: UiUtil.getTextStyle(52, 15.0)),
                              TextSpan(
                                  text: "70",
                                  style: UiUtil.getTextStyle(0, 15.0,
                                      c: UiUtil.getColor(76,
                                          num1: 152, num2: 244))),
                              TextSpan(
                                  text: "/405)",
                                  style: UiUtil.getTextStyle(52, 15.0)),
                            ])),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            itemCount: _circleMemberList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CircleMemberRow(
                                  _circleMemberList[index], mainUserId);
                            }),
                      ),
                      Container(
                        height: 70.0,
                        margin: EdgeInsets.only(bottom: 20.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              child: UiUtil.getContainer(
                                  36.0,
                                  15.0,
                                  UiUtil.getColor(76, num1: 152, num2: 244),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        join(AssetsUtil.assetsDirectoryMarket,
                                            "qz.png"),
                                        width: 17.0,
                                        height: 17.0,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        "进入圈集",
                                        style: UiUtil.getTextStyle(255, 17.0,
                                            isBold: true),
                                      ),
                                    ],
                                  ),
                                  mWidth: 150.0),
                              onTap: () {
                                //进入圈集
                                Get.to(CircleHome(widget.circleId,
                                    model.dataCircle['id'] as int));
                              },
                            ),
                            GestureDetector(
                              child: UiUtil.getContainer(
                                  36.0,
                                  15.0,
                                  model.colorButton,
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        join(AssetsUtil.assetsDirectoryMarket,
                                            "fx.png"),
                                        width: 17.0,
                                        height: 17.0,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        model.showTitle,
                                        style: UiUtil.getTextStyle(255, 17.0,
                                            isBold: true),
                                      ),
                                    ],
                                  ),
                                  mWidth: 150.0),
                              onTap: () {
                                if (model.isMineCircle) {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return UiUtil.getOkButtonCon(
                                            MediaQuery.of(context).size.width -
                                                100.0,
                                            120.0,
                                            "你确定要解散吗", () {
                                          Get.back(result: true);
                                        }, () {
                                          Get.back(result: false);
                                        });
                                      }).then((value) {
                                    if (value != null) {
                                      if (value) {
                                        model.addIntoMarketCircle();
                                      }
                                    }
                                  });
                                } else {
                                  model.addIntoMarketCircle();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )));
      },
    );
  }

  void _loadCircleMembers() {
    var params = {'marketCircleId': widget.circleId};
    DioUtil.request('/market/getCircleUser', parameters: params)
        .then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData);
      if (success) {
        List<dynamic> dataList = responseData['data'];
        mainUserId = dataList[0]["userid"];
        setState(() {
          _circleMemberList = dataList.map((memberJson) {
            return CircleMemberModel.fromJson(memberJson);
          }).toList();
        });
      }
    });
  }
}
