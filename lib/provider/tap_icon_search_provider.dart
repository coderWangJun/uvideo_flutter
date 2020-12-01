import 'package:flutter/material.dart';
import 'package:youpinapp/app/storage.dart';

class TapIconSearchProvider with ChangeNotifier{

  String cityName;

  bool isShowFlag = true;

  List<String> searchHistory = [];

  List onLineWorks = [];

  //初始化数据的方法
  init(){
    g_storageManager.getStorageList("searchHistory").then((value){
      if(value!=null&&value.length>0){
        searchHistory = value;
        isShowFlag = true;
      }else{
        isShowFlag = false;
      }
    onLineWorks = [
      {"id":66, "name":"市场扩展部主管", "city":"重庆", "money":"11-22k"},
      {"id":13, "name":"文案编辑", "city":"重庆", "money":"4-6k"},
      {"id":21, "name":"文案策划", "city":"重庆", "money":"5-10k"},
      {"id":32, "name":"上班吹空调，无死角环绕", "city":"重庆", "money":"7-11k"},
      {"id":44, "name":"上班打游戏", "city":"天国", "money":"3-5k"},
    ];
    notifyListeners();
    });
  }

  void changeCity(String city){
    cityName = city;
    notifyListeners();
  }

  void changeShowFlag(){
    isShowFlag = !isShowFlag;
    notifyListeners();
  }
}