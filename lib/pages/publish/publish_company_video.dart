import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/publish/choose_industry_route.dart';
import 'package:youpinapp/pages/publish/choose_location_route.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/widgets/video_picker.dart';

class PublishCompanyVideo extends StatefulWidget {
  @override
  _PublishCompanyVideoState createState() => _PublishCompanyVideoState();
}

class _PublishCompanyVideoState extends State<PublishCompanyVideo> {
  File _pickedFile;
  String _thumbImagePath;
  Map<String, dynamic> _locationMap;
  Map<String, dynamic> _industryMap;

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 44),
        child: _buildAppBarWidgets(),
      ),
      body: GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _buildInputWidgets(context),
            ),
            _buildPublishButton()
          ],
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
      )
    );
  }

  Widget _buildAppBarWidgets() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      leading: IconButton(
        icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'nav_back_black.png')),
        onPressed: () {
          Get.back();
        },
      ),
      title: Text('发布宣传片', style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
      centerTitle: true,
    );
  }

  Widget _buildInputWidgets(parentContext) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCameraButton(parentContext),
          SizedBox(height: 10),
          _buildTitleInputWidget(),
          _buildIntroInputWidget(),
          _buildLocationRow(),
          _buildIndustryRow()
        ],
      ),
    );
  }

  Widget _buildCameraButton(parentContext) {
    return InkWell(
      child: (_pickedFile == null) ? _buildVideoButtonUnselect() : _buildVideoButtonSelected(),
      onTap: () async {
        File pickedFile = await VideoPicker.showVideoPicker(parentContext);

        if (pickedFile != null) {
          _pickedFile = pickedFile;
          _thumbImagePath = await VideoThumbnail.thumbnailFile(video: _pickedFile.path);
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
    return Container(
        width: 160,
        height: 90,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          //child: _thumbImage,
          child: Image.file(File(_thumbImagePath), fit: BoxFit.cover),
        )
    );
  }

  Widget _buildTitleInputWidget() {
    return TextField(
      controller: _titleController,
      style: TextStyle(fontSize: 17, color: ColorConstants.textColor51),
      decoration: InputDecoration(
        hintText: '填写标题让人一目了然~',
        hintStyle: TextStyle(fontSize: 17, ),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorConstants.dividerColor, width: 1)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorConstants.dividerColor, width: 1)),
      ),
    );
  }

  Widget _buildIntroInputWidget() {
    return TextField(
      controller: _descController,
      maxLines: 5,
      maxLength: 1000,
      style: TextStyle(fontSize: 13, color: ColorConstants.textColor51),
      decoration: InputDecoration(
        hintText: '填写公司简介...',
        hintStyle: TextStyle(fontSize: 13, color: ColorConstants.textColor153),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorConstants.dividerColor, width: 1)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorConstants.dividerColor, width: 1))
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
                Text(_locationMap != null ? _locationMap["title"] : "所在位置", style: TextStyle(fontSize: 15, color: _locationMap != null ? ColorConstants.themeColorBlue : ColorConstants.textColor51))
              ],
            ),
            Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_forward_small.png'))
          ],
        ),
      ),
      onTap: () {
        FocusManager.instance.primaryFocus.unfocus();
        Get.to(ChooseLocationRoute()).then((location) {
          setState(() {
            _locationMap = location;
          });
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
        FocusManager.instance.primaryFocus.unfocus();
        Get.to(ChooseIndustryRoute()).then((map) {
          setState(() {
            _industryMap = map;
          });
        });
      },
    );
  }

  Widget _buildPublishButton() {
    return Container(
      height: 64,
      padding: EdgeInsets.only(bottom: 20, left: 42.5, right: 42.5),
      child: InkWell(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorConstants.themeColorBlue,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text('发布', style: TextStyle(fontSize: 17, color: Colors.white)),
        ),
        onTap: _uploadAndSaveCompanyVideo,
      ),
    );
  }

  void _uploadAndSaveCompanyVideo() {
    FocusManager.instance.primaryFocus.unfocus();

    String title = _titleController.text;
    String desc = _descController.text;

    if (_pickedFile == null) {
      BotToast.showText(text: "请选择或拍摄视频");
      return;
    }

    Map<String, dynamic> paramMap = {
      "cover": MultipartFile.fromFileSync(_thumbImagePath),
      "video": MultipartFile.fromFileSync(_pickedFile.path),
      "title": title,
      "details": desc
    };

    if (_locationMap != null) {
      paramMap["latitude"] = _locationMap["lat"];
      paramMap["longitude"] = _locationMap["lng"];
      paramMap["cityName"] = _locationMap["city"];
    }

    if (_industryMap != null) {
      paramMap["industryNo"] = _industryMap["id"];
      paramMap["industryName"] = _industryMap["name"];
    }

    BotToast.showLoading();
    FormData formData = FormData.fromMap(paramMap);
    DioUtil.request("/company/addCompanyPromo", parameters: formData).then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData);
      if (success) {
        BotToast.showText(text: responseData["msg"]);
        Get.back();
      }
    }).whenComplete(() => BotToast.closeAllLoading());
  }
}