import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_baidu_map/flutter_baidu_map.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/app.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/app/search.dart';
import 'package:youpinapp/app/web_socket.dart';
import 'package:youpinapp/pages/agreement/agreement_route.dart';
import 'package:youpinapp/pages/home/home_route.dart';
import 'package:youpinapp/pages/setting/updataApp.dart';
import 'package:youpinapp/utils/event_bus.dart';

void main() {
  // App初始化，加载缓存数据，初始化第三方SDK
  App.instance.initApp();
  runApp(
      MultiProvider(
        providers: [
          //创建时进行初始化操作，添加监听器
          ChangeNotifierProvider(create: (_){
            ImProvider provider = ImProvider();
            provider.initImProvider();
            return provider;
            //关闭懒加载，app启动直接初始化聊天消息监听
          },lazy: false,),
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => AccountManager()),
//          ChangeNotifierProvider(create: (_) {
//            AccountManager acc = AccountManager();
//            acc.refreshRemoteUser();
//            return acc;
//          }),
          ChangeNotifierProvider(create: (_) {
            SearchManager sea = SearchManager();
            sea.init();
            return sea;
          }),
          ChangeNotifierProvider(create: (_){
            WebSocketProvide socketProvide = WebSocketProvide();
            g_eventBus.on(GlobalEvent.accountInitialized, (arg) {
              if(g_accountManager.ringSwitch){
                  socketProvide.init();
                }
            });
            return socketProvide;
          },lazy: false,)
        ],
        child: YouPinApp(),
      )
  );
}

class YouPinApp extends StatefulWidget {
  @override
  YouPinAppState createState() => YouPinAppState();
}

class YouPinAppState extends State<YouPinApp> {
  bool _isLogin = false;
  bool _isInitialized = false;
  var pageRoutes = {};

  ThemeData themeData = new ThemeData(
    fontFamily: 'HanSans',
    primaryColor: Color.fromRGBO(79, 154, 247, 1),
    splashColor: Colors.transparent,
  );

  void _checkLoginState() async {
    bool isLogin = await g_accountManager.isLogin;
    setState(() {
      _isLogin = isLogin;
      _isInitialized = true;
    });
  }

  YouPinAppState() {
    _checkLoginState();

    _initBaiduSDK();
  }

  void _initBaiduSDK() async {
    // FlutterBaiduMap.setAK("pdXG6yLQ9QAGGxhy5uSZ8nf8F5KfGhXe");

//    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
//    bool hasPermission = permission == PermissionStatus.granted;
//    if(!hasPermission){
//      Map<PermissionGroup, PermissionStatus> map = await PermissionHandler().requestPermissions([
//        PermissionGroup.location
//      ]);
//      if(map.values.toList()[0] != PermissionStatus.granted){
//        return;
//      }
//    }

    // BaiduLocation location = await FlutterBaiduMap.getCurrentLocation();
    // print("百度地图定位：${location.longitude},${location.latitude}");

  }

  @override
  void initState() {
    super.initState();
  }

  DateTime now;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CN'),
        // const Locale('en', 'US'),
      ],
      theme: themeData,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: AnnotatedRegion<SystemUiOverlayStyle> (
          value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.black,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarIconBrightness: Brightness.dark
          ),
          //child: WillPopScope(child:HomeRoute(),onWillPop: () async{
          child: WillPopScope(child:AgreementRoute(),onWillPop: () async{
            if(now == null){
              now = DateTime.now();
              BotToast.showText(text: '再次操作确认退出');
              return false;
            }else{
              if(DateTime.now().difference(now).inMilliseconds<1000){
                return true;
              }else{
                now = DateTime.now();
                BotToast.showText(text: '再次操作确认退出');
                return false;
              }
            }
          },)
      ),
    );
  }
}