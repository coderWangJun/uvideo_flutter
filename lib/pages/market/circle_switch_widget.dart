import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/market/market_post_list.dart';
import 'package:youpinapp/utils/event_bus.dart';
import 'package:youpinapp/utils/uiUtil.dart';

class CircleSwitchWidget extends StatefulWidget {
  List<MarketPostListProvider> marketPostListProvider;
  String uri;
  List<Map> map;

  CircleSwitchWidget(this.marketPostListProvider, this.uri, this.map);

  @override
  _CircleSwitchWidgetState createState() =>
      _CircleSwitchWidgetState(marketPostListProvider, uri, map);
}

class _CircleSwitchWidgetState extends State<CircleSwitchWidget> {
  bool selectCircle = true;
  List<MarketPostListProvider> marketPostListProvider;
  String uri;
  List<Map> map;

  _CircleSwitchWidgetState(this.marketPostListProvider, this.uri, this.map);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 22,
      padding: EdgeInsets.symmetric(
        horizontal: 1,
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(238, 238, 238, 0.7),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: UiUtil.getContainer(
                20.0,
                10.0,
                !selectCircle
                    ? Colors.white
                    : Color.fromRGBO(238, 238, 238, 0.5),
                Text('圈外',
                    textAlign: TextAlign.center,
                    style: !selectCircle
                        ? UiUtil.getTextStyle(20, 11.0)
                        : UiUtil.getTextStyle(10, 11.0)),
                mWidth: 40.0),
            onTap: () {
              if (selectCircle) {
                setState(() {
                  selectCircle = false;
                });
                map[0]['privacy'] = 0;
                marketPostListProvider[0].getRefresh(uri, map[0]);
                map[1]['privacy'] = 0;
                marketPostListProvider[1].getRefresh(uri, map[1]);
              }
            },
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: UiUtil.getContainer(
                20.0,
                10.0,
                selectCircle
                    ? Colors.white
                    : Color.fromRGBO(238, 238, 238, 0.5),
                Text('圈内',
                    textAlign: TextAlign.center,
                    style: selectCircle
                        ? UiUtil.getTextStyle(20, 11.0)
                        : UiUtil.getTextStyle(10, 11.0)),
                mWidth: 40.0),
            onTap: () {
              if (!selectCircle) {
                setState(() {
                  selectCircle = true;
                });
                map[0]['privacy'] = 1;
                marketPostListProvider[0].getRefresh(uri, map[0]);
                map[1]['privacy'] = 1;
                marketPostListProvider[1].getRefresh(uri, map[1]);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
