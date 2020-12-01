import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:youpinapp/app/storage.dart';
import 'package:youpinapp/models/account_model.dart';
import 'package:youpinapp/pages/login/choose_identity_route.dart';
import 'package:youpinapp/pages/login/login_route.dart';
import 'package:youpinapp/third/tencent_kit.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/event_bus.dart';

var g_accountManager = new AccountManager();

class AccountManager with ChangeNotifier {
  bool ringSwitch = false;
  AccountModel currentUser;

  factory AccountManager() => _getInstance();
  static AccountManager _instance;
  static AccountManager get instance => _getInstance();

  // 初始化
  AccountManager._internal() {
    g_storageManager.getStorage(StorageManager.keyLocalUserInfo).then((jsonString) {
      if (jsonString != null) {
        Map<String, dynamic> jsonObj = convert.jsonDecode(jsonString);
        currentUser = AccountModel.fromJson(jsonObj);
      }
      g_storageManager.getStorageBool(StorageManager.RTC_SWITCH).then((value) {
        this.ringSwitch = value;
        g_eventBus.emit(GlobalEvent.accountInitialized);
      });
    });
  }

  // 获取实例
  static AccountManager _getInstance() {
    if (_instance == null) {
      _instance = new AccountManager._internal();
    }

    return _instance;
  }

  // 根据本地是否缓存用户信息来判断用户是否登录
  Future<bool> get isLogin async {
    String localUserJsonString = await g_storageManager.getStorage(StorageManager.keyLocalUserInfo);
    if (localUserJsonString == null) {
      return false;
    } else {
      return true;
    }
  }

  // 登录检查，如果未登录，自动跳转到登录页面
  Future<bool> checkLogin({bool pushLoginRoute = true}) async {
    return this.isLogin.then((isLogin) async {
      if (isLogin) {
        int typeId = this.currentUser.typeId;
        if (typeId != 1 && typeId != 2) {
          Get.to(ChooseIdentityRoute());
          return false;
        }
      } else {
        if (pushLoginRoute) {
          Get.to(LoginRoute());
        }
      }

      return isLogin;
    });
  }

  // 重置本地已缓存的用户信息
  Future<void> refreshLocalUser(userJson) async {
    if (userJson != null) {
      this.currentUser = AccountModel.fromJson(userJson);

      String userJsonString = convert.jsonEncode(userJson);
      await g_storageManager.setStorage(StorageManager.keyLocalUserInfo, userJsonString);

      // 初始化腾讯SDK
//      TencentKit.instance.initSdk();

      notifyListeners();
    }
  }

  // 调用服务器接口获取用户信息，并刷新本地缓存
  Future<void> refreshRemoteUser() async {
    // 调用服务器接口获取用户信息
    var responseData = await DioUtil.request('/user/getLoginUser');
    // 刷新本地缓存
    await this.refreshLocalUser(responseData['data']);
  }

  // 清空本地缓存
  Future<void> clearLocalUser() async {
    await g_storageManager.removeStorage(StorageManager.keyLocalUserInfo);
    g_eventBus.emit(GlobalEvent.accountInitialized);
  }
}