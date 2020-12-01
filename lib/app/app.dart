import 'package:flutter/cupertino.dart';

enum AppShowMode {
  player, // 播放器模式
  list, // 首页列表模式
}

class App {

  //版本号，检测是否更新
  static final VERSIONCODE = 3;

  AppShowMode showMode = AppShowMode.player;

  // 私有的实例变量
  static App _instance;

  // 公开的实例变量
  static App get instance => _getInstance();

  // 内部构造函数
  App._internal();

  // 公开的构造函数
  factory App() => _getInstance();

  // 内部获取实例变量
  static App _getInstance() {
    if (_instance == null) {
      _instance = new App._internal();
    }

    return _instance;
  }

  // App启动的时候调用此函数进行一些全局的初始化操作
  void initApp() async {
  }
}


class AppProvider extends ChangeNotifier {
  int _bottomTabBarIndex;

  get bottomTabBarIndex => _bottomTabBarIndex ?? 0;
  set bottomTabBarIndex(int tabBarIndex) {
    _bottomTabBarIndex = tabBarIndex;
    notifyListeners();
  }
}