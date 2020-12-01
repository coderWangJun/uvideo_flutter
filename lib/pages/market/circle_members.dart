import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/circle_member_model.dart';
import 'package:youpinapp/pages/common/search_bar.dart';
import 'package:youpinapp/pages/market/circle_member_row.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';

class CircleMembers extends StatefulWidget {
  final int circleId;

  CircleMembers(this.circleId);

  @override
  _CircleMembersState createState() => _CircleMembersState();
}

class _CircleMembersState extends State<CircleMembers> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 88),
        child: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'nav_back_black.png')),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Padding(
            padding: EdgeInsets.only(right: 50),
            child: Container(
              width: double.infinity,
              child: SearchBar('集圈搜索'),
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: ColorConstants.textColor51,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            unselectedLabelColor: Color.fromRGBO(102, 102, 102, 1),
            unselectedLabelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            indicatorWeight: 2,
            indicatorColor: ColorConstants.themeColorBlue,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.only(bottom: 10),
            tabs: _titles.map((title) {
              return Tab(text: title);
            }).toList(),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.15)))
          ),
          child: ListView.builder(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            itemCount: _circleMemberList.length,
            itemBuilder: (BuildContext context, int index) {
              return CircleMemberRow(_circleMemberList[index],mainUserId);
            }
          ),
        )
      ),
    );
  }

  void _loadCircleMembers() {
    var params = {'marketCircleId': widget.circleId};
    DioUtil.request('/market/getCircleUser', parameters: params).then((responseData) {
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