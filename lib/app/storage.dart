import 'package:shared_preferences/shared_preferences.dart';

var g_storageManager = new StorageManager();

class StorageManager {
  // 是否同意隐私政策
  static final String keyIsAcceptAgreement = 'KeyIsAcceptAgreement';
  // 本地用户信息key
  static final String keyLocalUserInfo = 'KeyLocalUserInfo';
  // 当前用户类型1 个人；2 企业
  static final String keyCurrentUserType = 'KeyCurrentUserType';
  //搜索历史
  static final String USER_SEARCH_HISTORY = "searchHistory";
  //用户sessionID
  static final String MY_SESSION_ID = "mySessionId";

  //自定义消息--音视频邀请，音视频取消，正在进行其他音视频，拒绝邀请
  static final String RTC_YAOQING = "rtcYaoQing";
  static final String RTC_QUXIAO = "rtcQuXiao";
  static final String RTC_FANMANG = "rtcFanMang";
  static final String RTC_JUJUE = "rtcJuJue";
  static final String RTC_JIESHOU = "rtcJieShou";

  static final String RTC_SWITCH = "rtcSwitch"; // 求职铃开关

  // 私有构造函数
  StorageManager._internal();

  // 保存单例
  static StorageManager _singleton = new StorageManager._internal();

  // 工厂构造函数
  factory StorageManager() => _singleton;

  // 将变量存储到本地缓存，并制定key值
  Future setStorage(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value is bool) {
      await prefs.setBool(key, value);
    } else {
      await prefs.setString(key, value);
    }
  }

  //追加list,一次加一条
  Future addStorageList(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list;
    if(prefs.containsKey(key)){
      list = await getStorageList(key);
      prefs.remove(key).then((v){
        list.add(value);
        prefs.setStringList(key, list);
      });
    }else{
      list = [value];
      prefs.setStringList(key, list);
    }
  }

  //取list
  Future<List<dynamic>> getStorageList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(key)){
      return prefs.getStringList(key);
    }else{
      return [];
    }
  }


  // 从本地缓存中通过key来取值
  Future<dynamic> getStorage(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
  Future<bool> getStorageBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  // 删除缓存
  Future<void> removeStorage(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}