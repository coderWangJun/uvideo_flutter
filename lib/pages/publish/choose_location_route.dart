import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/pages/common/baidu_map_tool.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';

class ChooseLocationRoute extends StatefulWidget {
  @override
  _ChooseLocationRouteState createState() => _ChooseLocationRouteState();
}

class _ChooseLocationRouteState extends State<ChooseLocationRoute> {
  Map<String, dynamic> _cityMap;
  List<dynamic> _locationList = [];
  TextEditingController _textEditingController = new TextEditingController();

  void _initData() async {
    // BaiduMapTool.getLocation().then((location) {
    //   _loadLocationList(location.longitude, location.latitude);
    // });
  }

  @override
  void initState() {
    super.initState();

    _textEditingController.addListener(() {
      _loadLocationListByKeyword();
    });

    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWhite(title: "选择所在位置"),
      body: Column(
        children: <Widget>[
          _buildSearchWidget(),
          Expanded(
            child: _buildListWidget(),
          )
        ],
      ),
    );
  }

  Widget _buildSearchWidget() {
    return Container(
      height: 66,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(238, 238, 238, 1),
              borderRadius: BorderRadius.circular(25)
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 45,
                child: Icon(Icons.search, color: Color.fromRGBO(140, 140, 140, 1)),
              ),
              Expanded(
                child: Container(
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      isDense: false,
                      contentPadding: EdgeInsets.only(right: 10, bottom: 11),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  Widget _buildListWidget() {
    return ListView.builder(
      itemCount: _locationList.length,
      itemExtent: 49,
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (BuildContext context, int index) {
        Map<String, dynamic> locationMap = _locationList[index];

        return InkWell(
          child: Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: ColorConstants.dividerColor.withOpacity(0.5), width: 1))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(locationMap["title"], style: TextStyle(fontSize: 14, color: ColorConstants.textColor51)),
                      Text(locationMap["address"], style: TextStyle(fontSize: 12, color: Colors.grey))
                    ],
                  ),
                ),
                Image.asset(join(AssetsUtil.assetsDirectoryCommon, "icon_forward_small.png"))
              ],
            ),
          ),
          onTap: () {
            locationMap.addAll(_cityMap);
            Get.back(result: locationMap);
          },
        );
      }
    );
  }

  void _loadLocationList(double lng, double lat) {
    var params = { "lon": lng, "lat": lat };
    params = { "lon": 106.582128, "lat": 29.667359 };
    BotToast.showLoading();
    DioUtil.request("/utils/getNearByPlace", parameters: params).then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: false);
      if (success) {
        var data = responseData["data"];
        List<dynamic> dataList = data["entityList"] ?? [];
        _locationList = dataList;
        _cityMap = data["address"];
      }

      setState(() { });
    }).whenComplete(() => BotToast.closeAllLoading());
  }

  void _loadLocationListByKeyword() {
    String keyword = _textEditingController.text;
    var params = {"keyword": keyword};
    BotToast.showLoading();
    DioUtil.request("/utils/getPlaceKeywordsList", parameters: params).then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: false);
      if (success) {
        List<dynamic> dataList = responseData["data"] ?? [];
        _locationList = dataList;
      }

      setState(() { });
    }).whenComplete(() => BotToast.closeAllLoading());
  }

  @override
  void dispose() {
    super.dispose();

    _textEditingController.dispose();
  }
}