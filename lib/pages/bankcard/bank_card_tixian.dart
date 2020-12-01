import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/bankcard/bank_card_add.dart';
import 'package:youpinapp/pages/bankcard/bank_card_tixian_end.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/uiUtil.dart';

class BankCardTitian extends StatelessWidget{

  TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: BankCardTitianProvider(),
      onReady: (model){_controller = TextEditingController();model.init();},
      onDispose: (model){
        if(_controller!=null){_controller.dispose();}
      },
      builder: (context,model,child){
        return Scaffold(
          backgroundColor: UiUtil.getColor(238),
          appBar: UiUtil.getAppBar("提现"),
          body: _getBody(context,model),
        );
      },
    );
  }

  Widget _getBody(BuildContext context,BankCardTitianProvider model) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          GestureDetector(child:Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("${model.cardHeadText} ",style: UiUtil.getTextStyle(51, 15),),
                Expanded(child: Text("${model.cardEndText}",
                  style: UiUtil.getTextStyle(153, 12),)),
                Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_forward_small.png'))
              ],
            ),
          ),onTap: (){
            showDialog(
                context: context,
              barrierDismissible: true,
              builder: (context){
                  return _showDialog(context,model);
              }
            ).then((value){
              if(value!=null){
                model.chooseCard(value);
              }
            });
          },),
          SizedBox(height: 10.0,),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: UiUtil.getColor(191),width: 1))
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("￥",style: UiUtil.getTextStyle(51, 17,isBold: true),),
                      Expanded(child:TextField(
                        controller: _controller,
                        maxLines: 1,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                        style: UiUtil.getTextStyle(51, 30),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none
                          )
                        ),
                      ))
                    ],
                ),),
                
                Text("可提现余额${model.hasUnicoNum}元",style: UiUtil.getTextStyle(153, 13),)
              ],
            ),
          ),
          
          SizedBox(height: 40,),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child:GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: UiUtil.getContainer(44, 5, ColorConstants.themeColorBlue,
                  Text("确认提现",style: UiUtil.getTextStyle(255, 15),),
                      constraints: BoxConstraints(minWidth: 200,maxHeight: 44)),
                  onTap: (){
                    model.sub(_controller.text);
                  },
          ))

        ],
      ),
    );
  }


  Widget _showDialog(BuildContext context,BankCardTitianProvider model){
    List<Widget> mList = [];
    for(int i = 0;i<model.mList.length;i++){
      mList.add(_getCardItem(i,model));
    }
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 10,
          constraints: BoxConstraints(maxHeight: 280),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(height: 40,child: Center(child: Text("选择银行卡",style: UiUtil.getTextStyle(52, 17,isBold: true),),),),
              model.moreThanOne?Expanded(child:SingleChildScrollView(
                padding: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: mList,
                ),
              )):_getToAddCard(model)
            ],
          )
        )
      ],
    );
  }

  Widget _getToAddCard(BankCardTitianProvider model){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: UiUtil.getContainer(40, 10, ColorConstants.themeColorBlue,
          Text("还没有银行卡，去添加",style: UiUtil.getTextStyle(255, 13),),
          constraints: BoxConstraints(minWidth: 200,maxHeight: 40)
        ),onTap: (){
          Get.to(BankCardAdd()).then((value){
            if(value!=null){
              model.init(flags: false);
            }
          });
      },
      ),
    );
  }

  Widget _getCardItem(int index,BankCardTitianProvider model){
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child:Container(
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: UiUtil.getColor(191),width: 1)
            )
          ),
          height: 50,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child:Text("${model.mList[index]['bankName']}",style: UiUtil.getTextStyle(52, 14),maxLines: 1,overflow: TextOverflow.ellipsis,)),
              Text("  尾号${model.mList[index]['bandCardNo']}",style: UiUtil.getTextStyle(52, 14),maxLines: 1,),
            ],)
    ),onTap: (){
          Get.back(result: index);
    },);
  }

}

class BankCardTitianProvider extends ChangeNotifier{
  bool moreThanOne = false;

  String cardHeadText = "请选择银行卡";
  String cardEndText = "";

  int chooseIndex = -1;

  String hasUnicoNum = "???";

  List mList = [];

  init({bool flags = true}){
    if(flags){DioUtil.request("/user/getMyIncome").then((value){
        if(DioUtil.checkRequestResult(value,showToast: true)){
          if(value['data']!=null){
            hasUnicoNum = (value['data'] as double).toString();
            notifyListeners();
          }
        }
      });}
    DioUtil.request("/user/queryUserBandCardList").then((value){
      if(DioUtil.checkRequestResult(value,showToast: true)){
        if(value['data']!=null){
          mList = value['data'] as List;
          moreThanOne = true;
          notifyListeners();
        }
      }
    });
  }

  chooseCard(int index){
    chooseIndex = index;
    cardHeadText = mList[index]['bankName'];
    cardEndText = mList[index]['bandCardNo'];
    notifyListeners();
  }

  sub(String text){
    num x =  num.parse(text);
    num ids = mList[chooseIndex]['id'] as num;
    DioUtil.request("/user/applyForWithdrawal",parameters: {
      'id' : ids,
      'tradeAmount' : x
    }).then((value){
      if(DioUtil.checkRequestResult(value)){
        String bankCard = "$cardHeadText($cardEndText)";
        Get.off(BankCardTitianEnd(x,bankCard));
      }
    });
  }

}