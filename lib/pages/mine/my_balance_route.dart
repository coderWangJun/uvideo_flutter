import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/bankcard/bank_card_tixian.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/pages/mine/ucoin_recharge_route.dart';
import 'package:youpinapp/utils/assets_util.dart';

class MyBalanceRoute extends StatefulWidget {
  @override
  _MyBalanceRouteState createState() => _MyBalanceRouteState();
}

class _MyBalanceRouteState extends State<MyBalanceRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWhite(title: "我的资产"),
      body: Column(
        children: <Widget>[
          _buildTitleWidget("我的余额"),
          _buildUcoinBalanceWidget(),
          _buildTitleWidget("我的收入"),
          _buildUcoinIncomeWidget()
        ],
      ),
    );
  }

  Widget _buildTitleWidget(String title) {
    return Container(
      height: 49,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(title, style: TextStyle(fontSize: 18, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildUcoinBalanceWidget() {
    return InkWell(
      child: Container(
        height: 120,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imagePath("mine", "bg_balance_blue.png"), width: double.infinity, height: double.infinity, fit: BoxFit.cover),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  Image.asset(imagePath("mine", "icon_ucoin.png")),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("U币", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text("用于作品视频、集市发布等场景消费", style: TextStyle(fontSize: 12, color: Colors.white))
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("${AccountManager.instance.currentUser.ucoinAmount}", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      InkWell(
                        child: Container(
                          width: 40,
                          height: 17,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.5)
                          ),
                          child: Center(child: Text("充值", style: TextStyle(fontSize: 10, color: ColorConstants.themeColorBlue))),
                        ),
                        onTap: () {
                          Get.to(UcoinRechargeRoute());
                        },
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {

      },
    );
  }

  Widget _buildUcoinIncomeWidget() {
    return InkWell(
      child: Container(
        height: 120,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imagePath("mine", "bg_balance_red.png"), width: double.infinity, height: double.infinity, fit: BoxFit.cover),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  Image.asset(imagePath("mine", "icon_ucoin.png")),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("U币收入", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text("查询收益明细、提现", style: TextStyle(fontSize: 12, color: Colors.white))
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("0", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Container(
                        width: 40,
                        height: 17,
                        child: Center(child: Image.asset(imagePath("mine", "little_arrow_white.png"))),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Get.to(BankCardTitian());
      },
    );
  }
}