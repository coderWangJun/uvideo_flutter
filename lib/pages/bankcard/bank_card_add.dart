import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/bankcard/bank_data.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/uiUtil.dart';

class BankCardAdd extends StatelessWidget{

  TextEditingController _controllerName;
  TextEditingController _controllerCardNum;
  TextEditingController _controllerCardName;

  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: BankCardAddProvider(),
      onReady: (model){
        _controllerName = new TextEditingController();
        _controllerCardNum = new TextEditingController();
        _controllerCardName = new TextEditingController();
      },
      onDispose: (model){
        if(_controllerName!=null){_controllerName.dispose();}
        if(_controllerCardNum!=null){_controllerCardNum.dispose();}
        if(_controllerCardName!=null){_controllerCardName.dispose();}
      },
      builder: (context,model,child){
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: UiUtil.getAppBar("添加银行卡"),
          body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
              child:_getBody(context,model),
          ),
        );
      },
    );
  }

  Widget _getBody(BuildContext context,BankCardAddProvider model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10,),
        _getTextEditingItem(model, _controllerName, "姓名"),
        Container(height: 1,color: UiUtil.getColor(220),),
        SizedBox(height: 10,),
        _getTextEditingItem(model, _controllerCardNum, "点击输入银卡卡号",mOnChanged: (v){
          if(v!=null && v!=""){if(v.length > 16){
              String bankName = BankData.findBankName(v);
              if(bankName!=""){
                model.changeBankCardName(false);
                _controllerCardName.text = bankName;
              }else{
                _controllerCardName.text = "";
                model.changeBankCardName(true);
              }
            }else{
            _controllerCardName.clear();
            model.changeBankCardName(true);
          }
          }
        }),
        Container(height: 1,color: UiUtil.getColor(220),),
        SizedBox(height: 10,),
        _getTextEditingItem(model, _controllerCardName, "输入开户行名称",enAble: model.bankCardName),
        Container(height: 1,color: UiUtil.getColor(220),),
        SizedBox(height: 20,),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child:UiUtil.getContainer(40, 10, ColorConstants.themeColorBlue,
                  Text("确定",style: UiUtil.getTextStyle(255, 14),)
                ),
          onTap: (){
            model.add(_controllerName.text, _controllerCardNum.text, _controllerCardName.text);
          },)
      ],
    );
  }

  Widget _getTextEditingItem(BankCardAddProvider model,TextEditingController controller,String hintString,{ValueChanged<String> mOnChanged,bool enAble = true}){
    return TextField(
      onChanged: mOnChanged,
      controller: controller,
      enabled: enAble,
      decoration: InputDecoration(
        hintText: hintString,
        hintStyle: UiUtil.getTextStyle(190, 13),
        border: OutlineInputBorder(
          borderSide: BorderSide.none
        ),
        contentPadding: EdgeInsets.zero
      ),
    );
  }
}

class BankCardAddProvider extends ChangeNotifier{
  bool flag = false;

  //输入银行卡名字是否可用
  bool bankCardName = false;

  void add(String name,String cardNum,String cardBankName){
    if(!(getBool(name) && getBool(cardNum) && getBool(cardBankName))){
      BotToast.showText(text: "请检查信息是否填写完整");
      return;
    }
    DioUtil.request("/user/addBandCard",parameters: {
      'name':name,
      'bandCardNo':cardNum,
      'bankName':cardBankName
    }).then((value){
      if(DioUtil.checkRequestResult(value)){
          Get.back(result: 1);
      }
    });
  }

  void changeBankCardName(bool l){
    if(bankCardName == l){return;}
    bankCardName = l;
    notifyListeners();
  }

  bool getBool(String s){
    if(s==null){return false;}
    if(s==""){return false;}
    return true;
  }
}