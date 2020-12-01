import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/widgets/empty_widget.dart';

class UcoinDetailRoute extends StatefulWidget {
  @override
  _UcoinDetailRouteState createState() => _UcoinDetailRouteState();
}

class _UcoinDetailRouteState extends State<UcoinDetailRoute> {
  String _monthString = "";
  double _paymentIn = 0;
  double _paymentOut = 0;
  List<UcoinFlowModel> _flowList = [];

  @override
  void initState() {
    super.initState();

    var today = DateTime.now();
    _monthString = DateFormat("yyyy-MM").format(today);

    _loadUcoinDetailList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWhite(title: "账单"),
      body: Column(
        children: <Widget>[
          _buildDateWidget(context),
          Expanded(
            child: _buildListWidget(),
          )
        ],
      ),
    );
  }

  Widget _buildDateWidget(parentContext) {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            child: Container(
              width: 90,
              height: 30,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 0.5),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_monthString, style: TextStyle(fontSize: 13, color: ColorConstants.textColor51)),
                  SizedBox(width: 5),
                  Image.asset(imagePath("mine", "arrow_down_solid.png"))
                ],
              ),
            ),
            onTap: () {
              DatePicker.showDatePicker(
                parentContext,
                maxDateTime: DateTime.now(),
                dateFormat: "yyyy-MM",
                locale: DateTimePickerLocale.zh_cn,
                onConfirm: (DateTime dateTime, List<int> selectedIndex) {
                  _monthString = DateFormat("yyyy-MM").format(dateTime);
                  _loadUcoinDetailList();

                  setState(() { });
                }
              );
            },
          ),
          Text.rich(TextSpan(
            children: [
              TextSpan(text: "支出：", style: TextStyle(fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1))),
              TextSpan(text: "${_paymentOut}U币", style: TextStyle(fontSize: 15, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
              TextSpan(text: "   "),
              TextSpan(text: "收入：", style: TextStyle(fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1))),
              TextSpan(text: "${_paymentIn}U币", style: TextStyle(fontSize: 15, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
            ]
          ))
        ],
      ),
    );
  }

  Widget _buildListWidget() {
    return _flowList.length > 0 ? Container(
      color: Color.fromRGBO(250, 250, 250, 1),
      child: ListView.separated(
        cacheExtent: 10,
        itemCount: _flowList.length,
//        padding: EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (BuildContext context, int index) {
          UcoinFlowModel flowModel = _flowList[index];
          String tradeString = "";
          if (flowModel.tradeType == 1) {
            tradeString = "+${flowModel.tradeAmount}U币";
          } else {
            tradeString = "-${flowModel.tradeAmount}U币";
          }

          return Container(
            height: 44,
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(flowModel.createdTime, style: TextStyle(fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1))),
                Text(tradeString, style: TextStyle(fontSize: 15, color: ColorConstants.themeColorBlue))
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(height: 1, color: Color.fromRGBO(238, 238, 238, 0.5));
        },
      )
    ) : EmptyWidget();
  }

  void _loadUcoinDetailList() {
    var params = {"date": _monthString};
    DioUtil.request("/user/queryUcoinRecord", parameters: params).then((response) {
      bool success = DioUtil.checkRequestResult(response);
      if (success) {
        _flowList.clear();

        var data = response["data"];
        if (data != null) {
          List<dynamic> dataList = data["ucoinRecordEntityList"];
          if (dataList != null && dataList.length > 0) {
            List<UcoinFlowModel> modelList = dataList.map((json) {
              return UcoinFlowModel.fromJson(json);
            }).toList();

            _flowList.addAll(modelList);
          }

          _paymentIn = double.parse("${data["paymentIn"]}");
          _paymentOut = double.parse("${data["paymentOut"]}");
        }

        setState(() { });
      }
    });
  }
}