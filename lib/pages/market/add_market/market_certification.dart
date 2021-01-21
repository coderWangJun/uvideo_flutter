import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/app/search.dart';
import 'package:youpinapp/pages/home/home_choose_city.dart';
import 'package:youpinapp/pages/person/chooseWorkName.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/provider/editCompany/companyEditIntroduce.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/chooseScrollFragment.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/head_image_crop.dart';
import 'package:youpinapp/utils/uiUtil.dart';
import 'package:youpinapp/widgets/video_picker.dart';

class MarketCertificationProvide extends ChangeNotifier {
  num marketId;

  bool mFlags;
  String marketName = "";
  num marketCount = -1;

  String marketInCity = "请选择圈子地理位置";
  num nowInCityId = -1;

  String marketVar = "请选择圈集分类";
  num marketVarId = -1;

  String marketNote = "请输入有关本圈的简介";
  String marketNoteValue = "";
  String marketUrl = ImProvider.DEF_HEAD_IMAGE_URL;
  String marketPath = "";

  bool changeVideo = false;
  File pickFileVideo;
  String pickFileVideoPath = "";
  String pickFileVideoUrl = "";

  List marketVarList = [];

  setPath(String pathImage) {
    marketPath = pathImage;
    notifyListeners();
  }

  setMarketInCity(String cityWhere, num cityCount) {
    marketInCity = cityWhere;
    nowInCityId = cityCount;
    notifyListeners();
  }

  setMarketVar(String marketVarName, num marketVarIds) {
    marketVar = marketVarName;
    marketVarId = marketVarIds;
    notifyListeners();
  }

  setMarketNote(String marketNotes) {
    marketNote = marketNotes;
    marketNoteValue = marketNotes;
    notifyListeners();
  }

  setPickFileVideoPath(String paths) {
    pickFileVideoPath = paths;
    notifyListeners();
  }

  init(bool mFlag) {
    mFlags = mFlag;
    if (marketCount == 2) {
      DioUtil.request("/resource/getSchoolList", method: 'GET').then((value) {
        if (DioUtil.checkRequestResult(value)) {
          if (value['data'] != null) {
            marketVarList = value['data'] as List;
            notifyListeners();
          }
        }
      });
    }
    if (!mFlag) {
      //编辑圈子
      DioUtil.request("/market/getMarketCircleDetails",
          parameters: {"id": marketId}).then((value) {
        if (DioUtil.checkRequestResult(value)) {
          if (value['data'] != null) {
            marketName = value['data']['circleName'] as String;
            marketCount = value['data']['marketTypeId'] as num;

            marketInCity = value['data']['cityName'] as String;
            nowInCityId = value['data']['cityNo'] as num;

            // todo--->
            marketVar = (value['data']['marketSubTypeName'] as String) ?? "";
            marketVarId = (value['data']['marketSubTypeId'] as num) ?? -1;

            marketNote = value['data']['shortContent'] ??=
                value['data']['content'] as String;
            marketNoteValue = value['data']['shortContent'] ??=
                value['data']['content'] as String;

            marketUrl =
                value['data']['logoUrl'] ?? ImProvider.DEF_HEAD_IMAGE_URL;
            marketPath = "";

            pickFileVideoUrl = value['data']['worksUrl'] as String;

            notifyListeners();
          }
        }
      });
    }
  }

  saveData() async {
    if (marketPath == "" && marketUrl == ImProvider.DEF_HEAD_IMAGE_URL) {
      BotToast.showText(text: "未选择圈子logo");
      return;
    }
    if (nowInCityId == -1) {
      BotToast.showText(text: "未选择圈子位置");
      return;
    }
    if (marketVarId == -1 && marketCount != 5 && marketCount != 3) {
      BotToast.showText(text: "未选择圈子分类");
      return;
    }
    if (marketNoteValue == "") {
      BotToast.showText(text: "圈子简介不能为空");
      return;
    }

    if (mFlags) {
      Map<String, dynamic> params = {
        "cityNo": nowInCityId,
        "cityName": marketInCity,
        "marketTypeId": marketCount,
        "content": marketNote,
        "circleName": marketName
      };
      BotToast.showLoading();
      if (marketCount == 2 || marketCount == 3 || marketCount == 4) {
        if (marketCount == 3) {
          params['marketSubTypeId'] = nowInCityId;
          params['marketSubTypeName'] = marketInCity;
        } else {
          params['marketSubTypeId'] = marketVarId;
          params['marketSubTypeName'] = marketVar;
        }
      }
      FormData formData =
          FormData.fromMap({"file": MultipartFile.fromFileSync(marketPath)});
      DioUtil.request("/user/uploadHeadPortrait", parameters: formData)
          .then((values) {
        bool success = DioUtil.checkRequestResult(values);
        if (success) {
          params['logoUrl'] = values["data"]["worksUrl"] as String;
          FormData formDatas;
          if (pickFileVideo != null && changeVideo) {
            params['cover'] = MultipartFile.fromFileSync(pickFileVideoPath);
          }
          formDatas = FormData.fromMap(params);
          DioUtil.request("/market/updateMarketCircle", parameters: formDatas,
              callback: (a, b) {
            print("========$a=====$b=");
          }).then((value) {
            if (DioUtil.checkRequestResult(value)) {
              BotToast.closeAllLoading();
              Get.back(result: 1);
            } else {
              BotToast.showText(text: "异常导致创建失败");
              BotToast.closeAllLoading();
              Get.back();
            }
          });
        } else {
          BotToast.showText(text: "logo上传失败");
          BotToast.closeAllLoading();
          Get.back();
        }
      });
    } else {
      Map<String, dynamic> params = {
        "cityNo": nowInCityId,
        "cityName": marketInCity,
        "marketTypeId": marketCount,
        "content": marketNote,
        "id": marketId
      };
      BotToast.showLoading();
      if (marketCount == 2 || marketCount == 3 || marketCount == 4) {
        if (marketCount == 3) {
          params['marketSubTypeId'] = nowInCityId;
          params['marketSubTypeName'] = marketInCity;
        } else {
          params['marketSubTypeId'] = marketVarId;
          params['marketSubTypeName'] = marketVar;
        }
      }
      if (marketPath != "") {
        FormData formData =
            FormData.fromMap({"file": MultipartFile.fromFileSync(marketPath)});
        DioUtil.request("/user/uploadHeadPortrait", parameters: formData)
            .then((values) {
          bool success = DioUtil.checkRequestResult(values);
          if (success) {
            params['logoUrl'] = values["data"]["worksUrl"] as String;
            FormData formDatas;
            if (pickFileVideo != null && changeVideo) {
              params['cover'] = MultipartFile.fromFileSync(pickFileVideoPath);
            }
            formDatas = FormData.fromMap(params);
            DioUtil.request("/market/updateMarketCircle", parameters: formDatas,
                callback: (a, b) {
              print("========$a=====$b=");
            }).then((value) {
              if (DioUtil.checkRequestResult(value)) {
                BotToast.closeAllLoading();
                Get.back(result: 1);
              } else {
                BotToast.showText(text: "异常导致创建失败");
                BotToast.closeAllLoading();
                Get.back();
              }
            });
          } else {
            BotToast.showText(text: "logo上传失败");
            BotToast.closeAllLoading();
            Get.back();
          }
        });
      } else {
        FormData formDatas;
        if (pickFileVideo != null && changeVideo) {
          params['cover'] = MultipartFile.fromFileSync(pickFileVideoPath);
        }
        formDatas = FormData.fromMap(params);
        DioUtil.request("/market/updateMarketCircle", parameters: formDatas,
            callback: (a, b) {
          print("========$a=====$b=");
        }).then((value) {
          if (DioUtil.checkRequestResult(value)) {
            BotToast.closeAllLoading();
            Get.back(result: 1);
          } else {
            BotToast.showText(text: "异常导致创建失败");
            BotToast.closeAllLoading();
            Get.back();
          }
        });
      }
    }
  }
}

class MarketCertification extends StatefulWidget {
  bool mFlagIsAdd = false;

  String marketName;
  num marketCount;
  num marketId = 0;
  MarketCertification(this.marketName, this.marketCount,
      {this.mFlagIsAdd = false, this.marketId = 0});
  @override
  _MarketCertificationState createState() => _MarketCertificationState();
}

class _MarketCertificationState extends State<MarketCertification> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: MarketCertificationProvide(),
      onReady: (model) {
        model.marketName = widget.marketName;
        model.marketCount = widget.marketCount;
        model.marketId = widget.marketId;
        model.init(widget.mFlagIsAdd);
      },
      onDispose: (model) {},
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: UiUtil.getAppBar("创建圈集"),
          body: _getBody(context, model),
        );
      },
    );
  }

  _getBody(BuildContext context, MarketCertificationProvide model) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.mFlagIsAdd
              ? Row(
                  children: <Widget>[
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: "2",
                          style: UiUtil.getTextStyle(51, 50.0, isBold: true)),
                      TextSpan(
                          text: "/2",
                          style: UiUtil.getTextStyle(51, 38.0, isBold: true)),
                    ])),
                    Text("  实名认证",
                        style: UiUtil.getTextStyle(51, 18.0, isBold: true)),
                  ],
                )
              : SizedBox.shrink(),
          SizedBox(
            height: 22.0,
          ),
          Container(
            width: double.infinity,
            height: 48.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: "请输入姓名",
                        hintStyle: UiUtil.getTextStyle(153, 17.0),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                    // controller: _controller,
                    onChanged: (value) {
                      // model.changeValue(value);
                    },
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  "0/20",
                  style: UiUtil.getTextStyle(153, 12.0),
                ),
              ],
            ),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: UiUtil.getColor(237)))),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: double.infinity,
            height: 48.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: "请输入身份证号",
                        hintStyle: UiUtil.getTextStyle(153, 17.0),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                    // controller: _controller,
                    onChanged: (value) {
                      // model.changeValue(value);
                    },
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: UiUtil.getColor(237)))),
          ),
          SizedBox(
            height: 50.0,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    "请拍摄您的身份证照片",
                    style: UiUtil.getTextStyle(51, 18.0, isBold: true),
                  ),
                ),
                Container(
                  child: Text(
                    "照片仅用于身份验证",
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.4),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.06),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: GestureDetector(
                        child: Expanded(
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(75, 151, 243, 0.4),
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: model.pickFileVideoPath == "" &&
                                    model.pickFileVideoUrl == ""
                                ? Icon(
                                    Icons.add,
                                    size: 30.0,
                                    color: UiUtil.getColor(238),
                                  )
                                : UiUtil.getHeadImage(
                                    model.pickFileVideoUrl, 100,
                                    isOval: false,
                                    path: model.pickFileVideoPath),
                          ),
                        ),
                        onTap: () async {
                          var pickedFile = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            model.pickFileVideo = pickedFile;
                            model.changeVideo = true;
                            model.setPickFileVideoPath(pickedFile.path);
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 11.0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "身份证正面照",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.4),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.06),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: GestureDetector(
                        child: Expanded(
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(75, 151, 243, 0.4),
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: model.pickFileVideoPath == "" &&
                                    model.pickFileVideoUrl == ""
                                ? Icon(
                                    Icons.add,
                                    size: 30.0,
                                    color: UiUtil.getColor(238),
                                  )
                                : UiUtil.getHeadImage(
                                    model.pickFileVideoUrl, 100,
                                    isOval: false,
                                    path: model.pickFileVideoPath),
                          ),
                        ),
                        onTap: () async {
                          var pickedFile = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            model.pickFileVideo = pickedFile;
                            model.changeVideo = true;
                            model.setPickFileVideoPath(pickedFile.path);
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 11.0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "身份证背面照",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.4),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _bottomBtn(),
        ],
      ),
    );
  }

  Widget _bottomBtn() {
    return Container(
      padding: EdgeInsets.only(
        top: 50.0,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: UiUtil.getContainer(
          36.0,
          200.0,
          UiUtil.getColor(76, num1: 152, num2: 244),
          Text(
            "提交",
            style: UiUtil.getTextStyle(255, 17.0, isBold: true),
          ),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _getInputItems(String textTop, String textBot) {
    return Container(
      width: double.infinity,
      height: 100.0,
      padding: EdgeInsets.symmetric(vertical: 23.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: UiUtil.getColor(238)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            textTop,
            style: UiUtil.getTextStyle(52, 13.0),
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  textBot,
                  style: UiUtil.getTextStyle(154, 17.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Image.asset(join(
                  AssetsUtil.assetsDirectoryCommon, "icon_forward_small.png")),
            ],
          ),
        ],
      ),
    );
  }
}
