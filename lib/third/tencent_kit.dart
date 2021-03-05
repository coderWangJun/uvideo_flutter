import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tencent_im_plugin/enums/log_print_level.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/utils/dio_util.dart';

class TencentKit {
  // 私有的单例对象
  static TencentKit _instance;

  // 公开的实例对象
  static TencentKit get instance => _getInstance();

  // 公开的构造函数
  factory TencentKit() => _getInstance();

  // 内部构造函数
  TencentKit._internal();

  // 获取实例
  static TencentKit _getInstance() {
    if (_instance == null) {
      _instance = TencentKit._internal();
    }

    return _instance;
  }

  // 初始化腾讯SDK
  Future<void> initSdk() async {
    await TencentImPlugin.init(appid: "1400432555", logPrintLevel: LogPrintLevel.error);
//      _loginWithCurrentUser();
    var responseData = await DioUtil.request("/user/getUserSig");
    bool success = DioUtil.checkRequestResult(responseData, showToast: false);
      if (success) {
        ///必须先做是否登录判断，不然后面的初始化工作被错误截断了不会执行，原生交互管道的错误try捕获不到
        if(await TencentImPlugin.getLoginUser()==null){
          debugPrint("------------------------------yes");
          String sig = responseData["data"] as String;
          String userId = g_accountManager.currentUser.tXIMUser.txUserid;
          print('************userId=***$userId========sig=***$sig========sig=***$sig');
          await TencentImPlugin.initStorage(identifier: userId);
          await TencentImPlugin.login(identifier: userId, userSig: sig);
        }else{
          debugPrint("-------------------------------nonono");
        }
      }
  }

}