import 'package:flutter/material.dart';

class cityFontWeight with ChangeNotifier{

//  cityFontWeight._();
//
//  static cityFontWeight _instance;
//
//  static cityFontWeight getInstace(){
//    if(_instance == null){
//      _instance = cityFontWeight._();
//    }
//    return _instance;
//  }

  List<FontWeight> list = [FontWeight.bold];

  FontWeight _fontWeight = FontWeight.w100;

  FontWeight get fontWeight => _fontWeight;


  void add(){
    list.add(_fontWeight);
  }

  void change(int index){
    for(int i = 0;i<list.length;i++){
      list[i]=_fontWeight;
    }
    list[index]=FontWeight.bold;
    notifyListeners();
  }
}