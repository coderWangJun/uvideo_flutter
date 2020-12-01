import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youpinapp/app/app.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/event_bus.dart';
import 'package:youpinapp/utils/uiUtil.dart';

class UpDataApp extends StatelessWidget{

  Map mapParam = {};
  UpDataApp({this.mapParam});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: UiUtil.getAppBar("检查更新"),
      body: BaseView(
       model: UpDataAppProvider(),
       onReady: (model){
         // warnning:这里要闪退，先注释掉
         // g_eventBus.emit(GlobalEvent.stopPlayEvent);
         if(mapParam!=null){
           if(mapParam.length>0){
             model.initMap(mapParam);
           }else{model.init();}
         }else{model.init();}
       },
       onDispose: (model){},
       builder: (context,model,child){
         return getContainer(context,model);
       },
      )
    );
  }

  Widget getContainer(BuildContext context,UpDataAppProvider model) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 30,horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(join(AssetsUtil.assetsDirectorySetting,"ic_launcher.png"),width: 70,height: 70,fit: BoxFit.cover,),
              model.updateIs?GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: UiUtil.getContainer(100, 10, ColorConstants.themeColorBlue, Text("下载",style: UiUtil.getTextStyle(255, 13),),constraints: BoxConstraints(maxHeight: 35,minWidth: 80)),
                onTap: () async{
                  if(await Permission.storage.request().isGranted){
                                Directory i = await getExternalStorageDirectory();
                                String path = i.path+'youshi.apk';
                                model.changeDowning();
                                Dio().download(model.versionInfo['androidAddr'], path,onReceiveProgress: (a,b){
                                  model.loading(a,b);
                                }).then((value){
                                  print("ok");
                                  InstallPlugin.installApk(path, "com.ypin.youpinapp");
                                });
                  }
                },
              ):(model.downing?UiUtil.getContainer(100, 10, ColorConstants.themeColorBlue, Text("${model.percent}%",style: UiUtil.getTextStyle(255, 13),),constraints: BoxConstraints(maxHeight: 35,minWidth: 80)):SizedBox.shrink())
            ],
          ),

          SizedBox(height: 50,),
          Container(
          constraints: BoxConstraints(minWidth: 200,minHeight: 70),
          child: Text(model.update?"已是最新版本":model.versionInfo['title'],style: UiUtil.getTextStyle(207, 15,isBold: true),softWrap: true,),
          ),

          Container(
            constraints: BoxConstraints(minWidth: 200,minHeight: 250),
            child: Text(model.update?"":model.versionInfo['content'],style: UiUtil.getTextStyle(187, 13),softWrap: true,),
          )
        ],
      ),
    );
  }

}

class UpDataAppProvider extends ChangeNotifier{

  bool updateIs = false;
  bool update = true;
  Map versionInfo = {};

  num percent = 100;

  bool downing = false;

  void init(){
    DioUtil.request("/sysInfo/getSYSInfo",method: 'GET').then((value){
      if(DioUtil.checkRequestResult(value)){
        if(value['data']!=null){
          num versionCode =  value['data']['updateF'] as num;
          if(versionCode>App.VERSIONCODE){
            versionInfo = value['data'] as Map;
            updateIs = true;
            update = false;
            notifyListeners();
          }
        }
      }
    });
  }

  void initMap(Map map){
    versionInfo = map;
    updateIs = true;
    update = false;
    notifyListeners();
  }

    void changeDowning(){
      updateIs = false;
      downing = true;
      notifyListeners();
    }

    void loading(int a,int b){
      percent = ((a*100)/b).round();
      notifyListeners();
    }

}