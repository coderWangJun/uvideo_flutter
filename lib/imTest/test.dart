import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youpinapp/imTest/provider/testProvider.dart';
import 'package:youpinapp/provider/baseView.dart';

class ImTest extends StatelessWidget{

  String valueText = "";

  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: ImTestProvider(),
      onReady: (model){model.init();},
      onDispose: (model){model.dis();},
      builder: (context,model,child){
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("聊天测试",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.black),),
            centerTitle: true,
            elevation: 0,
          ),
          body: SingleChildScrollView(child:Column(
            children: <Widget>[

              Container(
                width: 400,
                height: 500,
                child: Text(model.text),
              ),

              Container(
                  width: 400,
                  height: 110,
                  child: Row(
                    children: <Widget>[
                      Expanded(child:
                        TextField(
                          onChanged: (value){
                            valueText = value;
                          },
                        )
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        child: FlatButton(child: Text("发送"),onPressed: (){
                          ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50).then((value){
                            model.path = value.path;
                            model.sendMess();
                          });
//                          model.sendText = valueText;
                        },),
                      )
                    ],
                  )
              )
            ],)
        ));
      },
    );
  }
}