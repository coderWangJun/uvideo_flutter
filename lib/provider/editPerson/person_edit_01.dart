import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/pages/home/home_route.dart';

class PersonEditSecond with ChangeNotifier{

  String url = "";

  bool firstInit = false;
  String companyName = "";
  //保存真实姓名
  String realName = "";

  //保存生日
  String birthdayString = "";

  //保存首次工作时间
  String workTimeString = "";

  //保存性别
  int genderInt = 0;

  //保存行业
  Map mapWork = {};

  //元素未选中时的方案
  Map unItem = {
    "textColor" : Color.fromRGBO(153, 153, 153, 1),
    "backColor" : Color.fromRGBO(238, 238, 238, 1)
  };

  //元素选中时的方案
  Map onItem = {
    "textColor" : Color.fromRGBO(255, 255, 255, 1),
    "backColor" : Color.fromRGBO(75, 152, 244, 1)
  };

  //最多能够同时选中的个数
  static final int MAX_COUNT = 3;
  //保存以选中的个数
  int count = 0;

  //保存数据---List<Map>
  //      "skillName" : 技能名,
  //      "skillNo"   : 技能ID，自定义的技能为-1,
  //      "flag"      : 是否选中，true选中
  List skillText = [];

  //保存技能名字的数组
  List<String> tagList = [];

  //保存已经选择的技能--用，连接
  String tag = "";

  //初始化方法
  initValue(){
    DioUtil.request("/resource/getSkillTagsList",method: 'GET').then((value){
      if(DioUtil.checkRequestResult(value)){
        firstInit = true;
        List list = value["data"] as List;
        //遍历list添加一个flag字段代表选中与否，默认没有选中
        list.forEach((element) {
          element["flag"] = false;
        });
        if(list.length>0){
          skillText = list;
        }
      }else{
        skillText = [];
      }
      notifyListeners();
    });
  }

  //修改元素状态
  changeItemState(int position){
    if(skillText[position]["flag"]){
      skillText[position]["flag"] = false;
      count--;
      notifyListeners();
    }else{
      if(count>=MAX_COUNT){
        BotToast.showText(text: "最多只能选择三个哦");
      }else{
        skillText[position]["flag"] = true;
        count++;
        notifyListeners();
      }
    }
  }

  //添加自定义标签
  addUserInputSkill(String skillName){
    bool flag = false;
    if(count<MAX_COUNT){
      flag = true;
    }else{
      BotToast.showText(text: "超出了最大可选个数");
    }
    skillText.add({
      "skillName" : skillName,
      "skillNo"   : -1,
      "flag"      : flag
    });
    notifyListeners();
  }


  saveTags(){
    skillText.forEach((skill) {
      if(skill["flag"]){
        tagList.add(skill['skillName']);
        tag = tag + "${skill['skillName']},";
      }
    });
    if(tag!=""){
      tag = tag.substring(0,tag.length-1);
    }
  }

  //更新用户信息
  saveAndUpdateUser({bool flag = false}){
    var params = {
      'headPortraitUrl' : url,
      'sexId': genderInt,
      'realname': realName,
      'birthday': birthdayString,
      'startWorkingTime': workTimeString,
      'positionNo' : mapWork["id"],
      'positionName' : mapWork["name"],
      'companyName' : companyName,
      'tags':tag
    };
    print(params);

    if(flag){
      int typeId = 0;
      if(g_accountManager.currentUser.typeId==1){typeId = 2;}
      else{typeId = 1;}
          DioUtil.request('/user/updateUser', parameters: params).then((responseData) {
            bool success = DioUtil.checkRequestResult(responseData);
            if(success){
              DioUtil.request("/user/switchIdentities",parameters: {"typeId":typeId}).then((value){
                if(DioUtil.checkRequestResult(value)){
              //刷新本地用户信息
                g_accountManager.refreshRemoteUser().then((value){
                Get.back();
              });
              print("ok");
            }
          });
        }
      });
    }else{
      DioUtil.request('/user/updateUser', parameters: params).then((responseData) {
        bool success = DioUtil.checkRequestResult(responseData);
        if(success){
          //刷新本地用户信息
          g_accountManager.refreshRemoteUser();
          Get.offAll(HomeRoute());
//          Get.back(result: 1);
          print("ok");
        }
      });
    }

  }
}