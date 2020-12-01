import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:youpinapp/pages/market/add_market/market_edit.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/uiUtil.dart';

class AddMarketProvide extends ChangeNotifier{

  int nowLength = 0;
  int maxLength = 14;

  String text = "";

  TextEditingController controllerText;
  init(TextEditingController controller){
    controllerText = controller;
  }

  changeValue(String value){
    if(value==null){
      controllerText.text = "";
      text = "";
      nowLength = 0;
    }else{
      if(value.length>maxLength){
        controllerText.text = text;
        nowLength = text.length;
      }else{
        nowLength = value.length;
        text = value;
      }
    }
    notifyListeners();
  }
}

class AddMarket extends StatefulWidget{
  num MarketCounts;
  AddMarket(this.MarketCounts);

  @override
  _AddMarketState createState() => _AddMarketState();
}
class _AddMarketState extends State<AddMarket>{

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: AddMarketProvide(),
      onReady: (model){model.init(_controller);},
      onDispose: (model){},
      builder: (context,model,child){
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: UiUtil.getAppBar("创建圈集"),
          body: _getBody(context,model),
        );
      },
    );
  }

  _getBody(BuildContext context,AddMarketProvide model){
    return SingleChildScrollView(padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 30.0),child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text.rich(TextSpan(children: [
            TextSpan(text:"1",style:UiUtil.getTextStyle(51, 50.0,isBold: true)),
            TextSpan(text:"/2",style:UiUtil.getTextStyle(51, 38.0,isBold: true)),
          ])),
          Text("  基础信息",style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1),fontSize: 18.0,fontWeight: FontWeight.bold),),
        ],),
        SizedBox(height: 22.0,),
        Container(width:double.infinity,height:48.0,child:Row(crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
          Expanded(child:TextField(decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: "请输入圈集名称",
            hintStyle: UiUtil.getTextStyle(153, 17.0),
            border: OutlineInputBorder(borderSide:BorderSide.none)
          ),controller: _controller,onChanged: (value){model.changeValue(value);},),),
          SizedBox(width: 20.0,),
          Text("${model.nowLength}/${model.maxLength}",style: UiUtil.getTextStyle(153, 12.0),),
        ],),decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: UiUtil.getColor(237)))
          ),),
        SizedBox(height: 90.0,),
        GestureDetector(child:
          UiUtil.getContainer(34.0, 15.0, UiUtil.getColor(75,num1: 151,num2: 243),
            Text("下一步",style: UiUtil.getTextStyle(255, 15.0,isBold: true),)),
          onTap: (){
          //下一步
            if(model.text!=null&&model.text!=""){
              Get.off(MarketEdit(model.text, widget.MarketCounts,mFlagIsAdd: true,));
            }else{
              BotToast.showText(text: "圈子名称不能没有吧");
            }
          },)
      ],
    ),);
  }

}