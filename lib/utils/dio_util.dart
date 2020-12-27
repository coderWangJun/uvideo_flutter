import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:youpinapp/app/account.dart';

class DioUtil {
  // 服务器响应结果码：成功
  static final String HTTP_RESP_CODE_SUCCESS = '1';

//  static final String SERVER_URL = 'https://47.108.196.26:2020';
  static final String SERVER_URL = 'https://47.104.105.255:2020';
  // static final String SERVER_URL = 'https://www.im.com:2020';

  // static final String SERVER_URL = 'https://47.104.105.255:2020';
  // static final String SERVER_URL = 'https://127.0.0.1:2020';
  // static final String SERVER_URL = 'https://huangque.tech:2020';
//  static final String ERVER_URL = 'https://192.168.2.149:2020';

  // 单例对象
  static Dio _dio;

  static Dio getInstance() {
    if (_dio == null) {
      // 头部
      Map<String, dynamic> headers = {
        'Content-Type': 'application/json',
//        'token': AccountManager.instance.currentUser.token
      };

      BaseOptions options = new BaseOptions(
          baseUrl: SERVER_URL,
          connectTimeout: 300000,
          receiveTimeout: 300000,
          headers: headers,
          method: 'POST');

      _dio = new Dio(options);
    }

    // 头部
    Map<String, dynamic> headers = {'Content-Type': 'application/json'};

    if (g_accountManager.currentUser != null &&
        g_accountManager.currentUser.token != null) {
      headers['token'] = g_accountManager.currentUser.token;
    }

    _dio.options.headers = headers;

    // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      // client.findProxy = (uri) {
      //   //return "PROXY 192.168.32.173:8888";
      //   return "PROXY 192.168.0.102:8888";
      // };
      //   //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };

    return _dio;
  }

  // 校验服务器返回结果，统一处理
  static bool checkRequestResult(responseData, {showToast = false}) {
    if (responseData == null) {
      print("responseData==null");
      if (showToast) {
        BotToast.showText(text: "请求失败");
      }
      return false;
    } else {
      String respCode = responseData['code'];
      String msg = responseData['msg'];

      // 请求成功
      if (respCode == HTTP_RESP_CODE_SUCCESS) {
        return true;
      } else {
        if (msg != null) {
          if (showToast) {
            BotToast.showText(text: msg);
          }
        } else {
          if (showToast) {
            BotToast.showText(text: responseData['errorMsg'] ?? "请求失败");
          }
        }

        return false;
      }
    }
  }

  static Future<T> request<T>(String url,
      {parameters, method, ProgressCallback callback}) async {
    var result;
    parameters = parameters != null ? parameters : {};
    method = method != null ? method : 'POST';

    try {
      Dio dio = getInstance();
      print("$url\n${dio.options.headers}\n$parameters");
      Response response;
      if (callback != null) {
        response = await dio.request(url,
            data: parameters,
            options: Options(method: method),
            onSendProgress: callback);
      } else {
        response = await dio.request(
          url,
          data: parameters,
          options: Options(method: method),
        );
      }
      print("code=${response.statusCode}\n");
      var responseData = response.data;
      if (responseData is String) {
        result = convert.jsonDecode(responseData);
      } else {
        result = response.data;
      }

//      print("$url=====$result");
      if (response.statusCode != 200) {
        throw Exception(result);
      }
    } catch (e) {
      print(e);
    }
    print(result);
    return result != null ? result : null;
  }
}
