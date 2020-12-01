import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/pages/mine/ucoin_detail_route.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';

import 'package:tobias/tobias.dart' as tobias;

class UcoinRechargeRoute extends StatefulWidget {
  @override
  _UcoinRechargeRouteState createState() => _UcoinRechargeRouteState();
}

class _UcoinRechargeRouteState extends State<UcoinRechargeRoute> {
  int _currentAmount = 0;
  int _rechargeRate = 10;
  List<int> _amountList = [1, 10, 30, 60, 90, 120];

  _UcoinRechargeRouteState() {
    if (Platform.isIOS) {
      _rechargeRate = 7;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: <Widget>[
          _buildBalanceWidget(),
          Expanded(
            child: Container(
              child: _buildRechargeWidget(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBarWhite(title: "充值", actions: <Widget>[
      FlatButton(
        padding: EdgeInsets.all(0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Text("账单", style: TextStyle(fontSize: 15, color: ColorConstants.textColor51)),
        onPressed: () {
          Get.to(UcoinDetailRoute());
        },
      )
    ]);
  }

  Widget _buildBalanceWidget() {
    return Container(
      width: double.infinity,
      height: 49,
      color: Colors.white,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text.rich(TextSpan(
        children: [
          TextSpan(text: "U币余额", style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
          TextSpan(text: "  ${AccountManager.instance.currentUser.ucoinAmount}", style: TextStyle(fontSize: 17, color: ColorConstants.themeColorBlue, fontWeight: FontWeight.bold))
        ]
      )),
    );
  }

  Widget _buildRechargeWidget() {
    double gridWidth = (ScreenUtil.mediaQueryData.size.width - 75) / 2;
    double gridHeight = 34;

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("请选择充值U币", style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text("U币充值比例为1：${_rechargeRate}，充值完成后可提现", style: TextStyle(fontSize: 12, color: ColorConstants.textColor153)),
                ),
                SizedBox(
                  height: 150,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 15,
                        crossAxisCount: 2,
                        childAspectRatio: gridWidth / gridHeight
                    ),
                    children: _amountList.map((amount) {
                      return InkWell(
                        child: Container(
                          height: 34,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: _currentAmount == amount ? ColorConstants.themeColorBlue.withOpacity(0.2) : Colors.white,
                            border: _currentAmount == amount ? Border.all(color: ColorConstants.themeColorBlue.withOpacity(0.5)) : Border.all(color: Color.fromRGBO(238, 238, 238, 0.5)),
                            borderRadius: BorderRadius.circular(17)
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(imagePath("mine", "icon_ucoin1.png")),
                              SizedBox(width: 5),
                              Expanded(
                                child: Container(
                                  child: Text("${amount * _rechargeRate}", style: TextStyle(fontSize: 15, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Text("¥$amount", style: TextStyle(fontSize: 13, color: ColorConstants.textColor153))
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _currentAmount = amount;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                InkWell(
                  child: Container(
                    width: double.infinity,
                    height: 34,
                    decoration: BoxDecoration(
                      color: ColorConstants.themeColorBlue,
                      borderRadius: BorderRadius.circular(17)
                    ),
                    child: Center(child: Text(_currentAmount == 0 ? "支付" : "支付¥$_currentAmount", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold))),
                  ),
                  onTap: () {
                    _startPay();
                  },
                )
              ],
            ),
          ),
          _buildIntroWidget()
        ],
      ),
    );
  }

  Widget _buildIntroWidget() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("温馨提示", style: TextStyle(fontSize: 15, color: ColorConstants.textColor153)),
          SizedBox(height: 20),
          Text.rich(TextSpan(
            children: [
              TextSpan(text: "1.通过App Store充值可绑定不同的支付方式，了解", style: TextStyle(fontSize: 13, color: ColorConstants.textColor153)),
              TextSpan(text: "如何设置", style: TextStyle(fontSize: 13, color: ColorConstants.themeColorBlue)),
            ]
          )),
          Text.rich(TextSpan(
              children: [
                TextSpan(text: "2.支付遇到问题请点击", style: TextStyle(fontSize: 13, color: ColorConstants.textColor153)),
                TextSpan(text: "支付问题帮助", style: TextStyle(fontSize: 13, color: ColorConstants.themeColorBlue)),
              ]
          )),
          Text.rich(TextSpan(
              children: [
                TextSpan(text: "3.如需开具发票，请点击", style: TextStyle(fontSize: 13, color: ColorConstants.textColor153)),
                TextSpan(text: "电子发票", style: TextStyle(fontSize: 13, color: ColorConstants.themeColorBlue)),
              ]
          )),
        ],
      ),
    );
  }

  void _startPay() {
    if (_currentAmount == 0) {
      BotToast.showText(text: "请选择充值金额");
      return;
    }

    var params = {"totalAmount": _currentAmount};
    BotToast.showLoading();
    DioUtil.request("/alipay/getOrderStr", parameters: params).then((response) {
      print(response);
      bool success = DioUtil.checkRequestResult(response);
      if (success) {
        String payString = response["data"];
        tobias.aliPay(payString, evn: tobias.AliPayEvn.ONLINE).then((value) {
          AccountManager.instance.refreshRemoteUser().then((value) {
            setState(() { });
          });
        });
      }
    }).whenComplete(() => BotToast.closeAllLoading());
  }
}