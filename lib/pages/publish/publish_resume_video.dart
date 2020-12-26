import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as GetRequest;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/pages/person/chooseWorkName.dart';
import 'package:youpinapp/pages/person/person_basic_edit_01.dart';
import 'package:youpinapp/pages/publish/choose_location_route.dart';
import 'package:youpinapp/provider/editPerson/person_edit_01.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/widgets/salary_picker.dart';
import 'package:youpinapp/widgets/video_picker.dart';

class PublishResumeVideo extends StatefulWidget {
  @override
  _PublishResumeVideoState createState() => _PublishResumeVideoState();
}

class _PublishResumeVideoState extends State<PublishResumeVideo> {
  File _pickedFile;
  String _thumbImagePath;
  dynamic _selectedSalary;
  VideoPlayerController _playerController;
  PersonEditSecond _personEdit = new PersonEditSecond();

  Map<String, dynamic> _currentJob;
  Map<String, dynamic> _locationMap;
  List<dynamic> _salaryOptionList;

  TextEditingController _jobNameController = new TextEditingController();
  TextEditingController _jobDescController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _loadRemoteDictionary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWhite(title: "发布简历"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildVideoButton(context),
            _buildTitleInputWidgets(),
            _buildDescInputWidgets(),
            _buildSalaryWidgets(context),
            _buildSkillWidgets(),
            _buildLocationRow(),
            _buildJobRow(),
            _buildPublishButton()
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
          File pickedFile = await VideoPicker.showVideoPicker(parentContext);

          if (pickedFile != null) {
            _pickedFile = pickedFile;
            //_thumbImagePath = await VideoThumbnail.thumbnailFile(video: _pickedFile.path);

            var tempPath = (await getTemporaryDirectory()).path;
            _thumbImagePath = await VideoThumbnail.thumbnailFile(
                video: _pickedFile.path,
                thumbnailPath: tempPath,
                imageFormat: ImageFormat.JPEG,
                quality: 100);
          }

          setState(() {});
        });
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          //child: _thumbImage,
          child: Image.file(File(_thumbImagePath), fit: BoxFit.cover),
        ));
  }

  Widget _buildTitleInputWidgets() {
    return TextField(
      controller: _jobNameController,
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

  Widget _buildDescInputWidgets() {
    return Column(children: <Widget>[
      TextField(
        controller: _jobDescController,
        style: TextStyle(fontSize: 13, color: ColorConstants.textColor51),
        maxLength: 1000,
        maxLines: 5,
        decoration: InputDecoration(
            hintText: "填写个人优势...",
            hintStyle:
                TextStyle(fontSize: 13, color: ColorConstants.textColor153),
            border: InputBorder.none),
      ),
      SizedBox(height: 15),
      Container(height: 1, color: ColorConstants.dividerColor)
    ]);
  }

  Widget _buildSalaryWidgets(parentContext) {
    FocusManager.instance.primaryFocus.unfocus();

    return InkWell(
      child: Container(
        height: 90,
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: ColorConstants.dividerColor, width: 1))),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("期望薪资",
                      style: TextStyle(
                          fontSize: 13, color: ColorConstants.textColor51)),
                  SizedBox(height: 10),
                  Text(
                      _selectedSalary != null
                          ? "${_selectedSalary["minSalary"]} - ${_selectedSalary["maxSalary"]}"
                          : "请选择薪资要求",
                      style: TextStyle(
                          fontSize: 17,
                          color: _selectedSalary != null
                              ? ColorConstants.themeColorBlue
                              : ColorConstants.textColor153))
                ],
              ),
            ),
            Image.asset(join(
                AssetsUtil.assetsDirectoryCommon, "icon_forward_small.png"))
          ],
        ),
      ),
      onTap: () async {
        var result = await SalaryPicker.show(parentContext, _salaryOptionList);
        if (result != null) {
          _selectedSalary = result;
        }

        setState(() {});
      },
    );
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
                height: 25,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 12),
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
                GetRequest.Get.to(PersonBasicEditSecond(_personEdit))
                    .then((value) {
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
        GetRequest.Get.to(ChooseLocationRoute()).then((location) {
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
        GetRequest.Get.to(ChooseWorkName()).then((value) {
          if (value != null) {
            setState(() {
              _currentJob = value;
            });
          }
        });
      },
    );
  }

  Widget _buildPublishButton() {
    return Container(
      height: 74,
      padding: EdgeInsets.only(top: 30),
      child: InkWell(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorConstants.themeColorBlue,
            borderRadius: BorderRadius.circular(6),
          ),
          child:
              Text('发布', style: TextStyle(fontSize: 17, color: Colors.white)),
        ),
        onTap: () {
          _uploadAndSaveInviteInfo();
        },
      ),
    );
  }

  // 加载服务器数据字典
  void _loadRemoteDictionary() {
    DioUtil.request("/resource/getPublishAndSearchOptions", method: "GET")
        .then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: false);
      if (success) {
        var data = responseData["data"];

        setState(() {
          _salaryOptionList = data["salaryChooseList"];
        });
      }
    });
  }

  void _uploadAndSaveInviteInfo() {
    String jobName = _jobNameController.text;
    String jobDesc = _jobDescController.text;

    if (_pickedFile == null) {
      BotToast.showText(text: "请选择或拍摄简历视频");
      return;
    }

    if (jobName == "") {
      BotToast.showText(text: "请填写简历名称");
      return;
    }

    if (_selectedSalary == null) {
      BotToast.showText(text: "请选择薪资范围");
      return;
    }

    var params = {
      "cover": MultipartFile.fromFileSync(_thumbImagePath),
      "video": MultipartFile.fromFileSync(_pickedFile.path),
      "title": jobName,
      "introduction": jobDesc,
      "minSalary": _selectedSalary["minSalary"],
      "maxSalary": _selectedSalary["maxSalary"]
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

    BotToast.showLoading();
    FormData formData = FormData.fromMap(params);
    DioUtil.request("/resume/uploadMediaResume", parameters: formData)
        .then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData);
      if (success) {
        BotToast.showText(text: responseData["msg"]);
        GetRequest.Get.back();
      }
    }).whenComplete(() => BotToast.closeAllLoading());
  }
}
