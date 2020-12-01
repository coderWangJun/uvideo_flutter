import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/uiUtil.dart';

class Transfer extends StatefulWidget{

  Map map = {};
  //传入的map是否是查询用户信息的参数，默认否（其他页面转账时使用）---->暂时没用，不用管
  bool isParam = false;
  Transfer(this.map,{this.isParam = false});

  @override
  TransferState createState() => TransferState();

}
class TransferState extends State<Transfer>{

  TextEditingController _controller = new TextEditingController();

  String valueNum;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: new TransferProvider(),
      onReady: (model){},
      onDispose: (model){_controller.dispose();},
      builder: (context,model,child){
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: UiUtil.getAppBar("转U币"),
          body: SingleChildScrollView(child:getContainer(context)),
        );
      },
    );
  }

  Widget getContainer(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 30.0),
          child: getBody(context),
            ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
              child:UiUtil.getContainer(
                1, 15,
                ColorConstants.themeColorBlue,
                Text("转账",style: UiUtil.getTextStyle(255, 17.0),),
              constraints: BoxConstraints(minWidth: 20,minHeight: 50)
            ),),
            onTap: (){
              if(_controller.text!="" && _controller.text!=null){
                if(!_controller.text.contains(".")){
                  valueNum = _controller.text;
                  showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context){
                        return Stack(children: <Widget>[
                          Center(child:Padding(
                              padding: EdgeInsets.symmetric(vertical:0,horizontal: 36),
                              child: getDialog()))
                        ],);
                      }
                  ).then((value){
                    if(value == 1){//确认转账
                      DioUtil.request("/user/updateUcoin",parameters: {
                        'tradeFrom' : 4,
                        'tradeType' : 2,
                        'tradeAmount' : num.parse(valueNum),
                        'receiveUserid' : widget.map['userid']
                      }).then((values){
                        if(DioUtil.checkRequestResult(values)){
                          Get.back(result: valueNum);
                        }else{
                          BotToast.showText(text: "转账失败");
                        }
                      });
                    }
                  });
                }else{
                  _controller.text = "";
                }
              }
            },
          ),
        )
      ],
    );
  }


  Widget getBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20,),
        UiUtil.getHeadImage(widget.map['headImageUrl'], 90,isOval: false),
        SizedBox(height: 20,),
        Text(widget.map['userName'],style: UiUtil.getTextStyle(200, 17.0),),

        SizedBox(height: 50,),
        Row(
          children: <Widget>[
              SizedBox(width: 20,),
              Expanded(child:TextField(
                controller: _controller,
                maxLines: 1,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: "转出U币数值",
                  hintStyle: TextStyle(fontSize: 17.0),
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(borderSide: BorderSide.none,),
                ),
              ),)
          ],),
        Container(height: 1,color: Colors.black54,)

      ],
    );
  }


  Widget getDialog(){
    return Container(
      padding: EdgeInsets.only(top: 30,bottom: 10,left: 30,right: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      constraints: BoxConstraints(maxWidth: 500,maxHeight: 500),
      child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("要确认向 ${widget.map['userName']} 转账 ${_controller.text} U币吗?",style: TextStyle(
                color: Colors.black54,
                fontSize: 15.0,
                decoration: TextDecoration.none
            ),),
            SizedBox(height: 30.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(onPressed: (){
                  Get.back();
                  }, child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(150, 150, 150, 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    width: 100.0,height: 36.0,
                    child: Center(child:Text("取消",style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                    ),textAlign: TextAlign.center,),)
                )
                ),

                FlatButton(onPressed: (){
                  Get.back(result: 1);
                  }, child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(33, 187, 137, 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    width: 100.0,height: 36.0,
                    child: Center(child:Text("确认",style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                    ),textAlign: TextAlign.center),)
                )
                ),
              ],
            )
          ],
        ),
    );
  }

}

class TransferProvider extends ChangeNotifier{

}