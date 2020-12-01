import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:youpinapp/utils/assets_util.dart';

class inputIntroduce extends StatefulWidget{

  String _textValue;
  bool isCompany = true;

  inputIntroduce(this._textValue,{this.isCompany = true});

  @override
  _inputIntroduceState createState() {
   return _inputIntroduceState();
  }
}
class _inputIntroduceState extends State<inputIntroduce>{

  String _value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(preferredSize: Size(double.infinity,44.0),
          child: AppBar(
            actions: <Widget>[
              GestureDetector(
                child: Center(child:Text("保 存",style: TextStyle(fontSize: 15.0,color: Color.fromRGBO(51, 51, 51, 1)))),
                onTap: (){
                  Navigator.of(context)..pop(_value);
                },
              ),
              SizedBox(width: 20.0,)
            ],
            leading: IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon,"nav_back_black.png")),onPressed: (){
              ///back返回上一步
              Navigator.of(context)..pop(widget._textValue);
            },),
            elevation: 0,
            brightness:Brightness.light,
            backgroundColor: Colors.white,
          ),
        ),
        body: SingleChildScrollView(child:Container(
            width: double.infinity,
//              height: MediaQuery.of(context).size.height-44,
            color: Colors.white,
            padding: EdgeInsets.only(left: 20.0,right: 20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30.5,),
                  Text(widget.isCompany?"编辑公司简介":"编辑圈子简介",style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1),fontSize: 24.0,fontWeight: FontWeight.bold),),
                  SizedBox(height: 14.0,),
                  Text(widget.isCompany?"可以简单介绍一下公司发展状况、服务领域、主要产品等等信息":"可以简单介绍一下你的圈子",style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1),fontSize: 13.0,fontWeight: FontWeight.w500),),
                  SizedBox(height: 30.0,),
                  Container(child:TextField(
                    style: TextStyle(fontSize: 15.0),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintStyle: TextStyle(fontSize: 15.0),
                      hintText: widget._textValue == "" ? (widget.isCompany?"填写公司简介":"填写圈子简介") : widget._textValue,
                      border: OutlineInputBorder(borderSide: BorderSide.none)
                    ),
                    maxLines: 5,
                    maxLength: 1000,

                    onChanged: (text){
                      _value = text;
                    },
                  ),
                    padding: EdgeInsets.only(bottom: 14.0),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1)))
                    ),
                  )
                ])

        ),
        ));
  }
}