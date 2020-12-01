import 'package:youpinapp/utils/dio_util.dart';

class Gloabl {
  static Future init() {
    Gloabl.initRemoteDictionary();
  }

  static void initRemoteDictionary() {
    DioUtil.request("/resource/getPublishAndSearchOptions", method: "GET").then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: false);
      if (success) {

      }
    });
  }
}