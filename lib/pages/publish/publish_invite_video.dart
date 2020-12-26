import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as GetRequest;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/home_company_detailed_model.dart';
import 'package:youpinapp/models/home_company_model.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/pages/person/person_basic_edit_01.dart';
import 'package:youpinapp/pages/publish/choose_industry_route.dart';
import 'package:youpinapp/pages/publish/choose_location_route.dart';
import 'package:youpinapp/provider/editPerson/person_edit_01.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/widgets/bottom_picker.dart';
import 'package:youpinapp/widgets/salary_picker.dart';
import 'package:youpinapp/widgets/video_picker.dart';

class PublishInviteVideo extends StatefulWidget {
  final int jobId;

  PublishInviteVideo({this.jobId});

  @override
  _PublishInviteVideoState createState() => _PublishInviteVideoState();
}

class _PublishInviteVideoState extends State<PublishInviteVideo> {
  File _pickedFile;
  String _thumbImagePath;
  dynamic _selectedSalary;
  dynamic _selectedExpr;
  dynamic _selectedEdu;
  Map<String, dynamic> _locationMap;
  Map<String, dynamic> _industryMap;
  HomeCompanyDetailedModel _companyDetailedModel;
  VideoPlayerController _playerController;
  PersonEditSecond _personEdit = new PersonEditSecond();

  List<dynamic> _salaryOptionList;
  List<dynamic> _exprOptionList;
  List<dynamic> _eduOptionList;

  TextEditingController _jobNameController = new TextEditingController();
  TextEditingController _jobDescController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _personEdit.initValue();

    // if (widget.jobModel != null) {
    //   _jobNameController.text = widget.jobModel.title ?? "";
    //   _jobDescController.text = widget.jobModel.jobDetails ?? "";
    //   print("=====${widget.jobModel.jobDetails}=====${widget.jobModel.minSalary}");
    //
    //   if (widget.jobModel.minSalary != null && widget.jobModel.minSalary > 0) {
    //     _selectedSalary = {"minSalary": widget.jobModel.minSalary, "maxSalary": widget.jobModel.maxSalary};
    //   }
    // }

    _loadRemoteDictionary();

    if (widget.jobId != null) {
      _loadJobDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWhite(title: "发布职位"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildVideoButton(context),
            _buildJobNameInputWidgets(),
            _buildRequirementInputWidgets(),
            _buildSalaryWidgets(context),
            _buildExperienceWidgets(context),
            _buildEducationWidgets(context),
            _buildSkillWidgets(),
            _buildLocationRow(),
            _buildIndustryRow(),
            _buildPublishButton()
          ],
        ),
      ),
    );
  }

  Widget _buildVideoButton(parentContext) {
    return InkWell(
      child: (_pickedFile == null && _companyDetailedModel == null) ? _buildVideoButtonUnselect() : _buildVideoButtonSelected(),
      onTap: () async {
        File pickedFile = await VideoPicker.showVideoPicker(parentContext);
        if (pickedFile != null) {
          _pickedFile = pickedFile;

          var tempPath = (await getTemporaryDirectory()).path;
          _thumbImagePath = await VideoThumbnail.thumbnailFile(
            video: _pickedFile.path,
            thumbnailPath: tempPath,
            imageFormat: ImageFormat.JPEG,
            quality: 100
          );
        }

        setState(() { });
      },
    );
  }
  Widget _buildVideoButtonUnselect() {
    return Container(
      width: 160,
      height: 90,
      decoration: BoxDecoration(
          color: Color.fromRGBO(238, 238, 238, 0.5),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(join(AssetsUtil.assetsDirectoryCommon, "icon_camera.png")),
          SizedBox(height: 10),
          Text("添加视频", style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.5)))
        ],
      ),
    );
  }
  Widget _buildVideoButtonSelected() {
    Widget coverImageWidget;
    if (_pickedFile != null) {
      coverImageWidget = Image.file(File(_thumbImagePath), fit: BoxFit.cover);
    } else {
      coverImageWidget = CachedNetworkImage(
        imageUrl: _companyDetailedModel.coverUrl ?? "",
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: 160,
      height: 90,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        //child: _thumbImage,
        child: coverImageWidget,
      )
    );
  }

  Widget _buildJobNameInputWidgets() {
    return TextField(
      controller: _jobNameController,
      style: TextStyle(fontSize: 17, color: ColorConstants.textColor51),
      decoration: InputDecoration(
        hintText: "填写招聘岗位",
        hintStyle: TextStyle(fontSize: 17, color: ColorConstants.textColor153),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorConstants.dividerColor)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorConstants.dividerColor)),
      ),
    );
  }

  Widget _buildRequirementInputWidgets() {
    return Column(
      children: <Widget>[
        TextField(
          controller: _jobDescController,
          style: TextStyle(fontSize: 13, color: ColorConstants.textColor51),
          maxLength: 1000,
          maxLines: 5,
          decoration: InputDecoration(
              hintText: "填写岗位需求...",
              hintStyle: TextStyle(fontSize: 13, color: ColorConstants.textColor153),
              border: InputBorder.none
          ),
        ),
        SizedBox(height: 15),
        Container(height: 1, color: ColorConstants.dividerColor)
      ]
    );
  }

  Widget _buildSalaryWidgets(parentContext) {
    FocusManager.instance.primaryFocus.unfocus();

    String salaryString = "请选择薪资要求";
    if (_selectedSalary != null) {
      String minSalaryString = "面议";
      String maxSalaryString = "面议";

      if (_selectedSalary["minSalary"] > 0) {
        minSalaryString = "${_selectedSalary["minSalary"]}";
      }

      if (_selectedSalary["maxSalary"] > 0) {
        maxSalaryString = "${_selectedSalary["maxSalary"]}";
      }

      salaryString = "$minSalaryString - $maxSalaryString";
    }

    return InkWell(
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: ColorConstants.dividerColor, width: 1))
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("岗位薪资", style: TextStyle(fontSize: 13, color: ColorConstants.textColor51)),
                  SizedBox(height: 10),
                  Text(salaryString, style: TextStyle(fontSize: 17, color: _selectedSalary != null ? ColorConstants.themeColorBlue : ColorConstants.textColor153))
                ],
              ),
            ),
            Image.asset(join(AssetsUtil.assetsDirectoryCommon, "icon_forward_small.png"))
          ],
        ),
      ),
      onTap: () async {
        var selectedSalary = await SalaryPicker.show(parentContext, _salaryOptionList);
        if (selectedSalary != null) {
          _selectedSalary = selectedSalary;
        }
        print(_selectedSalary);

        setState(() { });
      },
    );
  }

  Widget _buildExperienceWidgets(parentContext) {
    FocusManager.instance.primaryFocus.unfocus();

    return InkWell(
      child: Container(
        height: 90,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: ColorConstants.dividerColor, width: 1))
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("经验要求", style: TextStyle(fontSize: 13, color: ColorConstants.textColor51)),
                  SizedBox(height: 10),
                  Text(_selectedExpr != null ? _selectedExpr["name"] : "请选择工作经验要求",
                      style: TextStyle(fontSize: 17, color: _selectedExpr != null ? ColorConstants.themeColorBlue : ColorConstants.textColor153))
                ],
              ),
            ),
            Image.asset(join(AssetsUtil.assetsDirectoryCommon, "icon_forward_small.png"))
          ],
        ),
      ),
      onTap: () async {
        var result = await BottomPicker.showPicker(parentContext, _exprOptionList, title: "经验要求");
        if (result != null) {
          _selectedExpr = result;
        }

        setState(() { });
      },
    );
  }

  Widget _buildEducationWidgets(parentContext) {
    FocusManager.instance.primaryFocus.unfocus();

    return InkWell(
      child: Container(
        height: 90,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: ColorConstants.dividerColor, width: 1))
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("最低学历", style: TextStyle(fontSize: 13, color: ColorConstants.textColor51)),
                  SizedBox(height: 10),
                  Text(_selectedEdu != null ? _selectedEdu["name"] : "请选择学历",
                      style: TextStyle(fontSize: 17, color: _selectedEdu != null ? ColorConstants.themeColorBlue : ColorConstants.textColor153))
                ],
              ),
            ),
            Image.asset(join(AssetsUtil.assetsDirectoryCommon, "icon_forward_small.png"))
          ],
        ),
      ),
      onTap: () async {
        var result = await BottomPicker.showPicker(parentContext, _eduOptionList, title: "最低学历");
        if (result != null) {
          _selectedEdu = result;
        }

        setState(() { });
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
        runSpacing: 10,
        children: tagList.map((title) {
          return InkWell(
            child: UnconstrainedBox(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 12),
                height: 25,
                decoration: BoxDecoration(
                    color: ColorConstants.backgroundColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Text(title, style: TextStyle(fontSize: 12, color: ColorConstants.textColor153)),
              ),
            ),
            onTap: () {
              if (title == "+添加技能") {
                FocusManager.instance.primaryFocus.unfocus();
                GetRequest.Get.to(PersonBasicEditSecond(_personEdit)).then((value) {
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
                Image.asset(join(AssetsUtil.assetsDirectoryPublish, _locationMap != null ? "publish_menu_area1.png" : "publish_menu_area.png")),
                SizedBox(width: 10),
                Text(_locationMap != null ? _locationMap["title"] : "所在位置", style: TextStyle(fontSize: 15, color: (_locationMap != null ? ColorConstants.themeColorBlue : ColorConstants.textColor51)))
              ],
            ),
            Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_forward_small.png'))
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

  Widget _buildIndustryRow() {
    return InkWell(
      child: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(join(AssetsUtil.assetsDirectoryPublish, _industryMap != null ? "publish_menu_at1.png" : "publish_menu_at.png")),
                SizedBox(width: 10),
                Text(_industryMap != null ? _industryMap["name"] : "提及行业", style: TextStyle(fontSize: 15, color: _industryMap != null ? ColorConstants.themeColorBlue : ColorConstants.textColor51))
              ],
            ),
            Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_forward_small.png'))
          ],
        ),
      ),
      onTap: () {
        GetRequest.Get.to(ChooseIndustryRoute()).then((map) {
          if (map != null) {
            setState(() {
              _industryMap = map;
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
          child: Text('发布', style: TextStyle(fontSize: 17, color: Colors.white)),
        ),
        onTap: () {
          _uploadAndSaveInviteInfo();
        },
      ),
    );
  }

  // 加载服务器数据字典
  void _loadRemoteDictionary() {
    DioUtil.request("/resource/getPublishAndSearchOptions", method: "GET").then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: false);
      if (success) {
        var data = responseData["data"];

        setState(() {
          _salaryOptionList = data["salaryChooseList"];
          _exprOptionList = data["yearsOfExpList"];
          _eduOptionList = data["diplomaList"];
        });
      }
    });
  }

  void _uploadAndSaveInviteInfo() async {
    String jobName = _jobNameController.text;
    String jobDesc = _jobDescController.text;

    if (_companyDetailedModel == null && _pickedFile == null) {
      BotToast.showText(text: "请选择或拍摄照片视频");
      return;
    }

    if (jobName == "") {
      BotToast.showText(text: "请填写岗位名称");
      return;
    }
    
    if (jobDesc == "") {
      BotToast.showText(text: "请填写岗位需求");
      return;
    }

    if (_selectedSalary == null) {
      BotToast.showText(text: "请选择薪资范围");
      return;
    }

    Map<String, dynamic> paramsMap = {
      // "cover": MultipartFile.fromFileSync(_thumbImagePath),
      // "video": MultipartFile.fromFileSync(_pickedFile.path),
      "title": jobName,
      "jobDetails": jobDesc,
      "minSalary": _selectedSalary["minSalary"],
      "maxSalary": _selectedSalary["maxSalary"],
    };

    if (widget.jobId != null) {
      paramsMap["id"] = widget.jobId;
    }

    if (_pickedFile != null) {
      paramsMap["cover"] = MultipartFile.fromFileSync(_thumbImagePath);
      paramsMap["video"] = MultipartFile.fromFileSync(_pickedFile.path);
    }

    if (_personEdit != null) {
      paramsMap["skillTags"] = _personEdit.tag;
    }

    if (_locationMap != null) {
      paramsMap["latitude"] = _locationMap["lat"];
      paramsMap["longitude"] = _locationMap["lng"];
      paramsMap["cityName"] = _locationMap["city"];
    }

    if (_industryMap != null) {
      paramsMap["industryNo"] = _industryMap["id"];
      paramsMap["industryName"] = _industryMap["name"];
    }

    if (_selectedExpr != null) {
      paramsMap["yearsOfExp"] = _selectedExpr["index"];
    }

    if (_selectedEdu != null) {
      paramsMap["diploma"] = _selectedEdu["index"];
    }

    var requestUrl = "/company/uploadMediaResume";
    if (widget.jobId != null) {
      requestUrl = "/company/updateMediaResumeMSG";
    }

    BotToast.showLoading();
    FormData formData = FormData.fromMap(paramsMap);
    DioUtil.request(requestUrl, parameters: formData).then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData);
      if (success) {
        BotToast.showText(text: responseData["msg"]);
        GetRequest.Get.back();
      }
    }).whenComplete(() => BotToast.closeAllLoading());
  }

  void _loadJobDetail() {
    BotToast.showLoading();
    var params = {"id": widget.jobId};
    DioUtil.request("/company/getMediaResumeDetails", parameters: params).then((response) {
      bool success = DioUtil.checkRequestResult(response);
      if (success) {
        _companyDetailedModel = HomeCompanyDetailedModel.fromJson(response["data"]);
        _jobNameController.text = _companyDetailedModel.title;
        _jobDescController.text = _companyDetailedModel.jobDetails;
        _personEdit.tag = _companyDetailedModel.skillTags;

        if (_companyDetailedModel.minSalary != null && _companyDetailedModel.minSalary > 0) {
          _selectedSalary = {"minSalary": _companyDetailedModel.minSalary, "maxSalary": _companyDetailedModel.maxSalary};
        }

        if (_companyDetailedModel.cityName != null && _companyDetailedModel.cityName != "") {
          _locationMap = {"longitude": _companyDetailedModel.longitude, "latitude": _companyDetailedModel.latitude, "title": _companyDetailedModel.cityName};
        }

        if (_companyDetailedModel.yearsOfExp != null && _companyDetailedModel.yearsOfExpString != null) {
          _selectedExpr = {"index": _companyDetailedModel.yearsOfExp, "name": _companyDetailedModel.yearsOfExpString};
        }

        if (_companyDetailedModel.eduId != null && _companyDetailedModel.diploma != null) {
          _selectedEdu = {"index": _companyDetailedModel.eduId, "name": _companyDetailedModel.diploma};
        }

        if (_companyDetailedModel.industryNo != null && _companyDetailedModel.industryName != null) {
          _industryMap = {"id": _companyDetailedModel.industryNo, "name": _companyDetailedModel.industryName};
        }

        setState(() { });
      }
    }).whenComplete(() => BotToast.closeAllLoading());
  }
}