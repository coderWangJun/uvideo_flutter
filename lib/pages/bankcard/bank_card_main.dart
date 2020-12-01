import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/bankcard/bank_card_add.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/uiUtil.dart';

class BankCardMain extends StatelessWidget{

  bool isCanBack = true;

  Color fixColor1 = UiUtil.getColor(54,num1: 113,num2: 183);
  Color fixColor2 = UiUtil.getColor(192,num1: 87,num2: 66);
  
  final double paddingHorizontal = 25;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: BankCardMainProvider(),
      onReady: (model){model.init(contexts:context);},
      onDispose: (model){},
      builder: (context,model,child){
        return WillPopScope(child:Scaffold(
          backgroundColor: Colors.white,
          appBar: UiUtil.getAppBar("银行卡",
              leadingWidget: IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon,"nav_back_black.png")),onPressed: (){
                if(doBack(model)){
                  Get.back();
                }
              },)
          ),
          body: _getBody(context,model),
        ),onWillPop: () async{
          return doBack(model);
        });
      },
    );
  }

  bool doBack(BankCardMainProvider model){
    if(model.chooseSwitch == 999){
      return true;
    }else{
      return model.backRoute();
    }
  }

  Widget _getBody(BuildContext context,BankCardMainProvider model) {
    List<Widget> mWidget = [];
    for(int i = 0;i<model.data.length;i++){
      mWidget.add(_getBankCardItem(model, i));
      mWidget.add(SizedBox(height: 10));
    }
    Widget mWidgetEnd =
      GestureDetector(
          behavior: HitTestBehavior.opaque,
          child:UiUtil.getContainer(45, 10, ColorConstants.themeColorBlue,
            Text(model.chooseSwitch==999?"添加银行卡":"解除绑定",style: UiUtil.getTextStyle(255, 14),)
          ),
        onTap: (){
            model.subClick();
        },
      );
    mWidget.add(SizedBox(height: 10));
    mWidget.add(mWidgetEnd);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 30,horizontal: paddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: mWidget
      ),
    );
  }
  
  
  Widget _getBankCardItem(BankCardMainProvider model,int i){
    return Visibility(
        visible: model.chooseSwitch == 999 || model.chooseSwitch == i,
        child:GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Center(child:UiUtil.getContainer(75, 10, i%2==1?fixColor1:fixColor2,Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child:Text("  ${model.data[i]['bankName']}",style: UiUtil.getTextStyle(255, 14,isBold: true),maxLines: 1,overflow: TextOverflow.ellipsis,)),
              Text("${model.data[i]['bandCardNo']}  ",style: UiUtil.getTextStyle(255, 16,isBold: true),maxLines: 1)
            ],
          ),mWidth: model.mWidth - paddingHorizontal*2)),
          onTap: (){
            model.itemClick(i);
          },
    ));
  }
}

class BankCardMainProvider extends ChangeNotifier{
  //选中的卡
  num chooseSwitch = 999;

  List data = [];
  //context宽度
  double mWidth;
  void init({BuildContext contexts}){
    if(contexts!=null){mWidth = MediaQuery.of(contexts).size.width;}
    DioUtil.request("/user/queryUserBandCardList").then((value){
      if(DioUtil.checkRequestResult(value,showToast: true)){
        if(value['data']!=null){
          data = value['data'] as List;
          notifyListeners();
        }
      }
    });
  }

  bool backRoute({bool refresh = false}){
    if(chooseSwitch == 999){
      return true;
    }else{
      chooseSwitch = 999;
      notifyListeners();
      return false;
    }
  }

  void subClick(){
    if(chooseSwitch == 999){
      //添加银行卡
      Get.to(BankCardAdd()).then((value){
        if(value!=null){
          init();
        }
      });
    }else{
      //解绑
      DioUtil.request("/user/delBandCard",parameters: {
        'id':data[chooseSwitch]['id'] as num
      }).then((value){
        if(DioUtil.checkRequestResult(value)){
          BotToast.showText(text: "解绑成功");
          data.removeAt(chooseSwitch);
          backRoute();
        }else{
          BotToast.showText(text: "解绑失败");
        }
      });
      print("解绑$chooseSwitch");
    }
  }

  void itemClick(int index){
    if(chooseSwitch==999){
      chooseSwitch = index;
      notifyListeners();
    }
  }
}