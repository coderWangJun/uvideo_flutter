import 'package:flutter/cupertino.dart';

class SizeUtil {
  // 屏幕宽度
  double screenWidth;
  // 屏幕高度
  double screenHeight;

  // 私有构造函数
  SizeUtil._internal();

  // 保存单例
  static SizeUtil _singleton = new SizeUtil._internal();

  // 工厂构造函数
  factory SizeUtil() => _singleton;

  void init(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
  }
}

// 全部变量，引入文件即可使用，无需再new一次
var g_sizeUtil = new SizeUtil();