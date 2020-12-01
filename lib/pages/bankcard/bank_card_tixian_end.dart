import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/uiUtil.dart';

class BankCardTitianEnd extends StatelessWidget{
  
  num uNum = 0;
  String bankName = "???";

  BankCardTitianEnd(this.uNum,this.bankName);
  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: BankCardTitianEndProvider(),
      onReady: (model){},
      onDispose: (model){},
      builder: (context,model,child){
        return Scaffold(
          backgroundColor: UiUtil.getColor(238),
          appBar: UiUtil.getAppBar(
            "提现详情",
            actionsListWidget: [
              Center(child:GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Text("完成",style: UiUtil.getTextStyle(154, 13),),
                onTap: (){
                  Get.back();
                },
              )),
              SizedBox(width: 24,)
            ]
          ),
          body: _getBody(context,model),
        );
      },
    );
  }

  Widget _getBody(BuildContext context,BankCardTitianEndProvider model) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Container(
            height: 90,
            color: Colors.white,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(join(AssetsUtil.assetsDirectoryMine,"iconv.png")),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("申请成功",style: UiUtil.getTextStyle(52, 20),),
                      Text("预计三个工作日内到账",style: UiUtil.getTextStyle(154, 12),)
                    ],
                  )
                ],
              ),
            )
          ),

          SizedBox(height: 10,),
          Container(
            color: Colors.white,
            constraints: BoxConstraints(minHeight: 100),
            padding: EdgeInsets.symmetric(vertical: 23,horizontal: 20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("提现金额",style: UiUtil.getTextStyle(154, 13),),
                    Text("$uNum元",style: UiUtil.getTextStyle(52, 13),)
                  ],
                ),
                SizedBox(height: 18,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("提现银行",style: UiUtil.getTextStyle(154, 13),),
                    Text("$bankName",style: UiUtil.getTextStyle(52, 13),)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BankCardTitianEndProvider extends ChangeNotifier{

}