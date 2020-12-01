import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';

class PayDialog extends StatefulWidget {
  int freeSeconds; // 免费观看的秒数
  int tradeFrom; // 交易来源 1.充值提现2.集市3.付费作品
  int tradeType; // 交易类型 1.收入2.支出
  double tradeAmount; // 交易金额(U币)
  int goodsId; // 商品id (作品/集市)

  PayDialog({this.freeSeconds, this.tradeFrom, this.tradeType, this.tradeAmount, this.goodsId});

  static Future<bool> show(BuildContext context, {int freeSeconds, int tradeFrom, int tradeType, double tradeAmount, int goodsId}) {
    return showGeneralDialog(
      context: context,
      barrierLabel: "",
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 300),
      barrierColor: Colors.black38,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Center(
          child: PayDialog(freeSeconds: freeSeconds, tradeFrom: tradeFrom, tradeType: tradeType, tradeAmount: tradeAmount, goodsId: goodsId),
        );
      }
    );
  }

  @override
  _PayDialogState createState() => _PayDialogState();
}

class _PayDialogState extends State<PayDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 235,
            height: 188,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("付费视频可免费观看${widget.freeSeconds}秒", style: TextStyle(fontSize: 12, color: ColorConstants.textColor153)),
                Text("支付U币后观看完整版", style: TextStyle(fontSize: 15, color: Colors.black)),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("${widget.tradeAmount}", style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold)),
                      SizedBox(width: 5),
                      Image.asset(imagePath("home", "dialog_pay_ucoin.png"))
                    ],
                  ),
                ),
                InkWell(
                  child: Container(
                    width: 160,
                    height: 44,
                    decoration: BoxDecoration(
                        color: ColorConstants.themeColorBlue,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    alignment: Alignment.center,
                    child: Text("立即支付", style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  onTap: () {
                    _ucoinPayRequest();
                  },
                )
              ],
            ),
          ),
          Container(
            height: 70,
            alignment: Alignment.center,
            child: InkWell(
              child: Image.asset(imagePath("home", "dialog_pay_close.png")),
              onTap: () {
                Get.back(result: false);
              },
            ),
          )
        ],
      ),
    );
  }

  void _ucoinPayRequest() {
    var params = {"tradeFrom": widget.tradeFrom, "tradeType": widget.tradeType, "tradeAmount": widget.tradeAmount, "goodsId": widget.goodsId};
    BotToast.showLoading();
    DioUtil.request("/user/updateUcoin", parameters: params).then((response) {
      BotToast.showText(text: response["msg"]);

      bool success = DioUtil.checkRequestResult(response);
      Get.back(result: success);
    }).whenComplete(() => BotToast.closeAllLoading());
  }
}