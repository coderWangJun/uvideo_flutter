import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bmflocation/bdmap_location_flutter_plugin.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_android_option.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_ios_option.dart';
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
  LocationFlutterPlugin _locationPlugin = new LocationFlutterPlugin();
  StreamSubscription<Map<String, Object>> _locationListener;


  @override
  void initState() {
    super.initState();

    _textEditingController.addListener(() {
      _loadLocationListByKeyword();
    });

    getCity();
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
    // params = { "lon": 106.582128, "lat": 29.667359 };
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
  void getCity(){
    /// 动态申请定位权限
    _locationPlugin.requestPermission();
    _locationListener = _locationPlugin.onResultCallback().listen((Map<String, Object> result) {
        try {
          BaiduLocation _baiduLocation = BaiduLocation.fromMap(result);
          if (null != _locationListener&&_baiduLocation.longitude!=null) {
            _loadLocationList(_baiduLocation.longitude, _baiduLocation.latitude);
            _locationListener.cancel(); // 停止定位
          }
        } catch (e) {}
    });
    if (null != _locationPlugin) {
      BaiduLocationAndroidOption androidOption = new BaiduLocationAndroidOption();
      androidOption.setCoorType("bd09ll"); // 设置返回的位置坐标系类型
      androidOption.setIsNeedAltitude(true); // 设置是否需要返回海拔高度信息
      androidOption.setIsNeedAddres(true); // 设置是否需要返回地址信息
      androidOption.setIsNeedLocationPoiList(true); // 设置是否需要返回周边poi信息
      androidOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
      androidOption.setIsNeedLocationDescribe(true); // 设置是否需要返回位置描述
      androidOption.setOpenGps(true); // 设置是否需要使用gps
      androidOption.setLocationMode(LocationMode.Hight_Accuracy); // 设置定位模式
      androidOption.setLocationPurpose(BDLocationPurpose.SignIn);//定位1次
      androidOption.setScanspan(1000); // 设置发起定位请求时间间隔
      Map androidMap = androidOption.getMap();

      /// ios 端设置定位参数
      BaiduLocationIOSOption iosOption = new BaiduLocationIOSOption();
      iosOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
      iosOption.setBMKLocationCoordinateType("BMKLocationCoordinateTypeBMK09LL"); // 设置返回的位置坐标系类型
      iosOption.setActivityType("CLActivityTypeAutomotiveNavigation"); // 设置应用位置类型
      iosOption.setLocationTimeout(10); // 设置位置获取超时时间
      iosOption.setDesiredAccuracy("kCLLocationAccuracyBest"); // 设置预期精度参数
      iosOption.setReGeocodeTimeout(10); // 设置获取地址信息超时时间
      iosOption.setDistanceFilter(100); // 设置定位最小更新距离
      iosOption.setAllowsBackgroundLocationUpdates(true); // 是否允许后台定位
      iosOption.setPauseLocUpdateAutomatically(true); //  定位是否会被系统自动暂停
      Map iosMap = iosOption.getMap();
      _locationPlugin.prepareLoc(androidMap, iosMap);
      _locationPlugin.startLocation();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (null != _locationListener) {
      _locationListener.cancel(); // 停止定位
    }
    _textEditingController.dispose();
  }
}