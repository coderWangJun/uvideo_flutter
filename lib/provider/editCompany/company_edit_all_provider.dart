import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:youpinapp/utils/dio_util.dart';

class CompanyEditAllProvider with ChangeNotifier {
  String title = "完善公司信息";
  String titleMore = "丰富的公司介绍，能获得更多求职者的青睐，为你的职位带来更多的查看与沟通";
  String proValueTitle = "完善进度";
  double proValue = 45;

  int proAll = 0;
  int proAllMAx = 8;

  String address = "";
  String companyName = "";
  String corporateWelfare = ""; // 公司福利
  String productIntroduction = ""; // 产品介绍
  String url = "";
  String introduce = "";

  String financingStage = "";
  String staffScaleName = "";

  int financingStageNo = 1;
  int staffScaleNameNo = 1;

  List<Map> itemList;

  List dataFinancing = [];
  List dataStaff = [];

  Widget itemStatusJXWS = Container(
      constraints: BoxConstraints(minWidth: 60.0),
      height: 27.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.5),
        color: Color.fromRGBO(75, 152, 244, 1),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "继续完善",
          style: TextStyle(color: Colors.white, fontSize: 12.0),
          textAlign: TextAlign.center,
        ),
      ));

  Widget getStringStatus(String status) {
    return Text(
      status,
      style: TextStyle(fontSize: 13.0, color: Color.fromRGBO(153, 153, 153, 1)),
    );
  }

  //初始化一些数据
  init() {
    DioUtil.request("/company/getCompany").then((value) {
      if (DioUtil.checkRequestResult(value)) {
        proAll = 0;
        if (value["data"]["logoUrl"] != null &&
            value["data"]["logoUrl"] != "") {
          url = value["data"]["logoUrl"];
          print("url:$url");
          proAll++;
        }
        if (value["data"]["companyName"] != null &&
            value["data"]["companyName"] != "") {
          companyName = value["data"]["companyName"];
          proAll++;
        }
        if (value["data"]["corporateWelfare"] != null &&
            value["data"]["corporateWelfare"] != "") {
          corporateWelfare = value["data"]["corporateWelfare"];
          proAll++;
        }
        if (value["data"]["productIntroduction"] != null &&
            value["data"]["productIntroduction"] != "") {
          productIntroduction = value["data"]["productIntroduction"];
          proAll++;
        }
        if (value["data"]["introduce"] != null &&
            value["data"]["introduce"] != "") {
          introduce = value["data"]["introduce"];
          proAll++;
        }
        String completeness = value["data"]["completeness"];
        proValue = double.parse(completeness.split("%")[0]);
        if (value["data"]["address"] != null &&
            value["data"]["address"] != "") {
          address = value["data"]["address"];
          proAll++;
        }

        if (value["data"]["financingStageName"] != null &&
            value["data"]["financingStageName"] != "") {
          financingStageNo = value["data"]["financingStage"] as num;
          financingStage = value["data"]["financingStageName"] as String;
          proAll++;
        }

        if (value["data"]["staffScaleName"] != null &&
            value["data"]["staffScaleName"] != "") {
          staffScaleNameNo = value["data"]["staffScale"] as num;
          staffScaleName = value["data"]["staffScaleName"];
          proAll++;
        }
        notifyListeners();
      }
    });
  }

  initData() {
    DioUtil.request("/resource/getFinancingStageList", method: 'GET')
        .then((value) {
      if (DioUtil.checkRequestResult(value)) {
        dataFinancing = value["data"];
      }
    });

    DioUtil.request("/resource/getStaffScaleList", method: 'GET').then((value) {
      if (DioUtil.checkRequestResult(value)) {
        dataStaff = value["data"];
      }
    });
  }

  changeCompanyName(String value) {
    DioUtil.request("/company/updateCompany",
        parameters: {"companyName": value}).then((value) {
      if (DioUtil.checkRequestResult(value)) {
        init();
      }
    });
  }

  changeCorporateWelfare(String value) {
    DioUtil.request("/company/updateCompany",
        parameters: {"corporateWelfare": value}).then((value) {
      if (DioUtil.checkRequestResult(value)) {
        init();
      }
    });
  }

  changeProductIntroduction(String value) {
    DioUtil.request("/company/updateCompany",
        parameters: {"productIntroduction": value}).then((value) {
      if (DioUtil.checkRequestResult(value)) {
        init();
      }
    });
  }

  changeAddress(String value) {
    DioUtil.request("/company/updateCompany", parameters: {"address": value})
        .then((value) {
      if (DioUtil.checkRequestResult(value)) {
        init();
      }
    });
  }

  changeIntroduce(String value) {
    DioUtil.request("/company/updateCompany", parameters: {"introduce": value})
        .then((value) {
      if (DioUtil.checkRequestResult(value)) {
        init();
      }
    });
  }

  changeFinancingStage(int value) {
    DioUtil.request("/company/updateCompany",
        parameters: {"financingStageNo": value}).then((value) {
      if (DioUtil.checkRequestResult(value)) {
        init();
      }
    });
  }

  changeStaffScaleName(int value) {
    DioUtil.request("/company/updateCompany",
        parameters: {"staffScaleNo": value}).then((value) {
      if (DioUtil.checkRequestResult(value)) {
        init();
      }
    });
  }

  uploadLogoImage(File pickFile) {
    FormData formData =
        FormData.fromMap({'file': MultipartFile.fromFileSync(pickFile.path)});
    DioUtil.request("/company/uploadCompanyLogo", parameters: formData)
        .then((responseData) {
      if (DioUtil.checkRequestResult(responseData)) {
        var data = responseData["data"];
        url = data["worksUrl"];
        DioUtil.request("/company/updateCompany", parameters: {"logoUrl": url})
            .then((value) {
          if (DioUtil.checkRequestResult(value)) {
            print("ok");
            init();
          }
        });
      }
    });
  }
}
