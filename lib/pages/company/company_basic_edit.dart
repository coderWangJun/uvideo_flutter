import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as GetRequest;
import 'package:image_picker/image_picker.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/home/home_route.dart';
import 'package:youpinapp/utils/dio_util.dart';

class CompanyBasicEditRoute extends StatefulWidget {
  @override
  _CompanyBasicEditRouteState createState() => _CompanyBasicEditRouteState();
}

class _CompanyBasicEditRouteState extends State<CompanyBasicEditRoute> {
  // TODO: 在页面消失的时候将状态栏改为白色，否则进入下个页面状态栏是黑色的，目前没有找到合适的方法，所以才先这样来实现的
  bool _pageWillDisappear = false;

  File _pickedFile;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _introController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: GestureDetector(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTitleWidgets(),
              _buildLogoWidgets(),
              _buildNameInputWidgets(),
              _buildIntroInputWidgets(),
              _buildCommitButton()
            ],
          ),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
      )
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size(double.infinity, 44),
      child: AppBar(
        elevation: 0,
        brightness: _pageWillDisappear ? Brightness.dark : Brightness.light,
        backgroundColor: Colors.white,
        actions: <Widget>[
          FlatButton(
            child: Text('跳过', style: TextStyle(fontSize: 15, color: ColorConstants.textColor51)),
            onPressed: () {
              setState(() {
                _pageWillDisappear = true;
              });
              GetRequest.Get.offAll(HomeRoute());
            },
          )
        ],
      ),
    );
  }

  // 标题
  Widget _buildTitleWidgets() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('填写公司基本资料', style: TextStyle(fontSize: 24, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
          Text('可以简单介绍一下公司发展状况、服务领域、主要产品等等信息', style: TextStyle(fontSize: 13, color: ColorConstants.textColor51)),
        ],
      )
    );
  }

  // 公司logo
  Widget _buildLogoWidgets() {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 20),
        child: Column(
          children: <Widget>[
            Container(
              width: 90,
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(color: ColorConstants.dividerColor, width: 1),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: (_pickedFile != null) ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File(_pickedFile.path), width: 90, height: 100, fit: BoxFit.cover),
              ) : SizedBox.shrink(),
            ),
            SizedBox(height: 10),
            Container(
              width: 90,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: ColorConstants.themeColorBlue,
                  borderRadius: BorderRadius.circular(14)
              ),
              child: Text('上传LOGO', style: TextStyle(fontSize: 15, color: Colors.white)),
            )
          ],
        ),
      ),
      onTap: () async {
        var pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
        setState(() {
          _pickedFile = pickedFile;
        });
      },
    );
  }

  Widget _buildNameInputWidgets() {
    return Container(
      height: 90,
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorConstants.dividerColor, width: 1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('姓名', style: TextStyle(fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1))),
          TextField(
            controller: _nameController,
            style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '请填写公司名称',
              hintStyle: TextStyle(fontSize: 17, color: ColorConstants.textColor153)
            ),
          )
        ],
      ),
    );
  }


  Widget _buildIntroInputWidgets() {
    return Container(
      height: 175,
      padding: EdgeInsets.only(top: 15, bottom: 15),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1), width: 1)),
      ),
      child: SizedBox(
        height: double.infinity,
        child: TextField(
          controller: _introController,
          maxLines: 5,
          maxLength: 1000,
          decoration: InputDecoration(
            hintText: '填写公司简介',
            hintStyle: TextStyle(fontSize: 15, color: ColorConstants.textColor153),
            border: InputBorder.none,
          ),
        ),
      )
    );
  }

  Widget _buildCommitButton() {
    return Container(
      height: 146,
      padding: EdgeInsets.only(left: 12.5, right: 12.5, top: 30, bottom: 72),
      child: InkWell(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: ColorConstants.themeColorBlue,
              borderRadius: BorderRadius.circular(8)
          ),
          child: Text('提交', style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        onTap: _saveCompanyInfo,
      ),
    );
  }

  void _saveCompanyInfo() {
    String companyName = _nameController.text;
    String companyIntro = _introController.text;

    if (companyName == '') {
      BotToast.showText(text: '请输入公司名称');
      return;
    }

    BotToast.showLoading();
    var saveParams = {'companyName': companyName, 'introduce': companyIntro};
    
    if (_pickedFile != null) {
      FormData formData = FormData.fromMap({'file': MultipartFile.fromFileSync(_pickedFile.path)});
      DioUtil.request('/company/uploadCompanyLogo', parameters: formData).then((responseData) {
        bool success = DioUtil.checkRequestResult(responseData);
        if (success) {
          var data = responseData["data"];
          saveParams["logoUrl"] = data["worksUrl"];
          _saveCompanyInfoAfterUploadLogo(saveParams);
        } else {
          BotToast.closeAllLoading();
        }
      }).catchError((error) {
        BotToast.closeAllLoading();
      });
    } else {
      _saveCompanyInfoAfterUploadLogo(saveParams);
    }
  }

  void _saveCompanyInfoAfterUploadLogo(saveParams) {
    DioUtil.request("/company/updateCompany", parameters: saveParams).then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData);
      if (success) {
        setState(() { _pageWillDisappear = true; });
        g_accountManager.refreshRemoteUser().then((value) {
          GetRequest.Get.to(HomeRoute());
        }).whenComplete(() => BotToast.closeAllLoading());
      } else {
        BotToast.closeAllLoading();
      }
    }).catchError((error) {
      BotToast.closeAllLoading();
    });
  }
}