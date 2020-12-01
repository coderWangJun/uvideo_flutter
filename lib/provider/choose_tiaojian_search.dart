
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChooseTiaoJian with ChangeNotifier{

  ///未选中
   Map<String,Object> _un ={
    "dec" : BoxDecoration(color: Color.fromRGBO(239, 239, 239, 1),border: Border.all(color: Color.fromRGBO(239, 239, 239, 1))),
    "color" : Color.fromRGBO(51, 51, 51, 1),
     "flag" : false
  };

  ///选中
  Map<String,Object> _on ={
    "dec" : BoxDecoration(color: Colors.white,border: Border.all(color: Color.fromRGBO(79, 154, 247, 1))),
    "color" : Color.fromRGBO(79, 154, 247, 1),
    "flag" : true
  };

  List<List> data = [
    [],[],[],
    [],[],[],[]
  ];


  void add(int index,bool flag){
    data[index].add(flag?_on:_un);
  }

  void tap(int index,int position){
//    if(index==0||index==1||index==4||index==5){
      onlyOne(index, position);
//    }else{
//      canMany(index, position);
//    }
  }

  ///清除方法
  void reset(){
    print("清除");
    for(int i = 0 ;i<data.length;i++){
      if(data[i]!=null&&data[i].isNotEmpty){
          data[i][0] = _on;
          for(int j = 1;j<data[i].length;j++){
            data[i][j] = _un;
          }
      }
    }
    notifyListeners();
  }

  ///可以多选
  void canMany(int index,int position){
    if(data[index][position]["flag"]){
      data[index][position] = _un;
    }else{
      data[index][position] = _on;
    }
    notifyListeners();
  }

  ///只能单选
  void onlyOne(int index,int position){
    for(int i=0;i<data[index].length;i++){
      data[index][i] = _un;
    }
    data[index][position] = _on;
    notifyListeners();
  }
}