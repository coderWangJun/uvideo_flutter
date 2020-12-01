import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:youpinapp/utils/assets_util.dart';

class inputTextFild extends StatefulWidget{

  String _title,_textValue;


  inputTextFild(this._title, this._textValue);

  @override
  _inputTextFildState createState() {
    return _inputTextFildState();
  }
}
class _inputTextFildState extends State<inputTextFild>{

  String _value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(preferredSize: Size(double.infinity,44.0),
        child: AppBar(
          leading: IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon,"nav_back_black.png")),onPressed: (){
            ///back返回上一步
            Navigator.of(context)..pop(widget._textValue);
          },),
          elevation: 0,
          brightness:Brightness.light,
          backgroundColor: Colors.white,
          actions: <Widget>[
            GestureDetector(
              child: Center(child:Text("保存",style: TextStyle(fontSize: 15.0,color: Color.fromRGBO(51, 51, 51, 1)))),
              onTap: (){
                Navigator.of(context)..pop(_value);
              },
            ),
            SizedBox(width: 20.0,)
          ],
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
              Text(widget._title,style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1),fontSize: 24.0,fontWeight: FontWeight.bold),),
              SizedBox(height: 14.0,),
              TextField(
                decoration: InputDecoration(
                  hintText: widget._textValue == "" ? "请输入${widget._title}" : widget._textValue,
                ),
                onChanged: (text){
                    _value = text;
                },
              )

              ])

      ),
    ));
  }
}