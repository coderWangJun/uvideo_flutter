import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/pages/person/chooseWorkName.dart';
import 'package:youpinapp/pages/person/person_basic_edit_01.dart';
import 'package:youpinapp/pages/publish/choose_location_route.dart';
import 'package:youpinapp/pages/publish/publish_ucoin_dialog.dart';
import 'package:youpinapp/provider/editPerson/person_edit_01.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/toast_util.dart';
import 'package:youpinapp/widgets/video_picker.dart';

class PublishShortVideo extends StatefulWidget {
  @override
  _PublishShortVideoState createState() => _PublishShortVideoState();
}

class _PublishShortVideoState extends State<PublishShortVideo> {
  File _pickedFile;
  String _thumbImagePath;
  Map<String, dynamic> _currentJob;
  Map<String, dynamic> _locationMap;
  PersonEditSecond _personEdit = new PersonEditSecond();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();
  VideoPlayerController _playerController;

  @override
  void initState() {
    super.initState();

    _personEdit.initValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWhite(title: "发布作品"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildVideoButton(context),
            _buildJobNameInputWidgets(),
            _buildJobDescInputWidgets(),
            _buildSkillWidgets(),
            _buildLocationRow(),
            _buildJobRow(),
            _buildPublishButton(context)
          ],
        ),
      ),
    );
  }

  Widget _buildVideoButton(parentContext) {
    return InkWell(
      child: (_pickedFile == null)
          ? _buildVideoButtonUnselect()
          : _buildVideoButtonSelected(),
      onTap: () async {
        var pickedFile = await VideoPicker.showVideoPicker(parentContext);
        if (pickedFile != null) {
          _pickedFile = pickedFile;
          print("video path${_pickedFile.path}");

          _thumbImagePath =
              await VideoThumbnail.thumbnailFile(video: _pickedFile.path);

//          File pickedFile = await VideoPicker.showVideoPicker(parentContext);
//
//          if (pickedFile != null) {
//            _pickedFile = pickedFile;
//            _thumbImagePath = await VideoThumbnail.thumbnailFile(video: _pickedFile.path);
//          }
        }
        setState(() {});
      },
    );
  }

  Widget _buildVideoButtonUnselect() {
    return Container(
      width: 160,
      height: 185,
      decoration: BoxDecoration(
          color: Color.fromRGBO(238, 238, 238, 0.5),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
              join(AssetsUtil.assetsDirectoryCommon, "icon_camera.png")),
          SizedBox(height: 10),
          Text("添加视频",
              style:
                  TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.5)))
        ],
      ),
    );
  }

  Widget _buildVideoButtonSelected() {
    return Container(
        width: 160,
        height: 185,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorConstants.dividerColor, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(File(_thumbImagePath),
                width: 160, height: 185, fit: BoxFit.cover),
          ),
        ));
  }

  Widget _buildJobNameInputWidgets() {
    return TextField(
      controller: _nameController,
      style: TextStyle(fontSize: 17, color: ColorConstants.textColor51),
      decoration: InputDecoration(
        hintText: "填写标题让人一目了然~",
        hintStyle: TextStyle(fontSize: 17, color: ColorConstants.textColor153),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.dividerColor)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.dividerColor)),
      ),
    );
  }

  Widget _buildJobDescInputWidgets() {
    return Column(children: <Widget>[
      TextField(
        controller: _descController,
        style: TextStyle(fontSize: 13, color: ColorConstants.textColor51),
        maxLength: 1000,
        maxLines: 5,
        decoration: InputDecoration(
            hintText: "填写作品描述...",
            hintStyle:
                TextStyle(fontSize: 13, color: ColorConstants.textColor153),
            border: InputBorder.none),
      ),
      SizedBox(height: 15),
      Container(height: 1, color: ColorConstants.dividerColor)
    ]);
  }

  Widget _buildSkillWidgets() {
    List<String> tagList = [];
    if (_personEdit != null && _personEdit.tag != "") {
      tagList = _personEdit.tag.split(",");
    }
    tagList.add("+添加技能");

    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 10),
      child: Wrap(
        spacing: 10,
        children: tagList.map((title) {
          return InkWell(
            child: UnconstrainedBox(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 12),
                height: 25,
                decoration: BoxDecoration(
                    color: ColorConstants.backgroundColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(title,
                    style: TextStyle(
                        fontSize: 12, color: ColorConstants.textColor153)),
              ),
            ),
            onTap: () {
              if (title == "+添加技能") {
                FocusManager.instance.primaryFocus.unfocus();
                Get.to(PersonBasicEditSecond(_personEdit)).then((value) {
                  if (value != null) {
                    setState(() {
                      _personEdit = value;
                    });
                  }
                });
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLocationRow() {
    return InkWell(
      child: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(join(
                    AssetsUtil.assetsDirectoryPublish,
                    _locationMap != null
                        ? "publish_menu_area1.png"
                        : "publish_menu_area.png")),
                SizedBox(width: 10),
                Text(_locationMap != null ? _locationMap["title"] : "所在位置",
                    style: TextStyle(
                        fontSize: 15,
                        color: _locationMap != null
                            ? ColorConstants.themeColorBlue
                            : ColorConstants.textColor51))
              ],
            ),
            Image.asset(join(
                AssetsUtil.assetsDirectoryCommon, 'icon_forward_small.png'))
          ],
        ),
      ),
      onTap: () {
        Get.to(ChooseLocationRoute()).then((location) {
          if (location != null) {
            setState(() {
              _locationMap = location;
            });
          }
        });
      },
    );
  }

  Widget _buildJobRow() {
    return InkWell(
      child: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(join(
                    AssetsUtil.assetsDirectoryPublish,
                    _currentJob != null
                        ? "publish_menu_at1.png"
                        : "publish_menu_at.png")),
                SizedBox(width: 10),
                Text(_currentJob != null ? _currentJob["name"] : "提及岗位",
                    style: TextStyle(
                        fontSize: 15,
                        color: _currentJob != null
                            ? ColorConstants.themeColorBlue
                            : ColorConstants.textColor51))
              ],
            ),
            Image.asset(join(
                AssetsUtil.assetsDirectoryCommon, 'icon_forward_small.png'))
          ],
        ),
      ),
      onTap: () {
        FocusManager.instance.primaryFocus.unfocus();
        Get.to(ChooseWorkName()).then((value) {
          if (value != null) {
            print(value);
            setState(() {
              _currentJob = value;
            });
          }
        });
      },
    );
  }

  Widget _buildPublishButton(parentContext) {
    return Container(
        height: 56,
        padding: EdgeInsets.only(top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorConstants.textColor153.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('普通发布',
                      style: TextStyle(
                          fontSize: 17, color: ColorConstants.textColor153)),
                ),
                onTap: () {
                  _saveShortVideo(0);
                },
              ),
            ),
            SizedBox(width: 55),
            Expanded(
              child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorConstants.themeColorBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('收费发布',
                      style: TextStyle(fontSize: 17, color: Colors.white)),
                ),
                onTap: () async {
                  int ucoin =
                      await PublishUcoinDialog.showUcoinDialog(parentContext);
                  if (ucoin != null && ucoin > 0) {
                    _saveShortVideo(ucoin);
                  }
                },
              ),
            )
          ],
        ));
  }

  void _saveShortVideo(int coint) {
    String title = _nameController.text;
    String desc = _descController.text;

    if (_pickedFile == null) {
      BotToast.showText(text: "请选择或拍摄视频");
      return;
    }

    if (title == "") {
      BotToast.showText(text: "请输入标题");
      return;
    }

    if (desc == "") {
      BotToast.showText(text: "请输入描述");
      return;
    }

    var params = {
      "cover": MultipartFile.fromFileSync(_thumbImagePath),
      "video": MultipartFile.fromFileSync(_pickedFile.path),
      "title": title,
      "content": desc
    };

    if (_personEdit != null && _personEdit.tag != "") {
      params["skillTags"] = _personEdit.tag;
    }

    if (_locationMap != null) {
      params["latitude"] = _locationMap["lat"];
      params["longitude"] = _locationMap["lng"];
      params["cityName"] = _locationMap["city"];
    }

    if (_currentJob != null) {
      params["positionNo"] = _currentJob["id"];
      params["positionName"] = _currentJob["name"];
    }

    if (coint > 0) {
      params["needUcoin"] = 2;
      params["ucoinAmount"] = coint;
    } else {
      params["needUcoin"] = 1;
    }

    BotToast.showLoading();
    FormData formData = FormData.fromMap(params);
    DioUtil.request("/user/uploadMediaWorks", parameters: formData)
        .then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData);
      if (success) {
        BotToast.showText(text: responseData["msg"]);
        Get.back();
      }
    }).whenComplete(() => BotToast.closeAllLoading());
  }
}
