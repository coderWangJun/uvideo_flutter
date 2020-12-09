import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/account_person_model.dart';
import 'package:youpinapp/pages/person/chooseWorkName.dart';
import 'package:youpinapp/pages/person/person_basic_edit_01.dart';
import 'package:youpinapp/provider/editPerson/person_edit_01.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/head_image_crop.dart';
import 'package:youpinapp/utils/ossUpload.dart';

enum Genders { male, female }

class PersonBasicEdit extends StatefulWidget {
  bool changeTypeId = false;

  PersonBasicEdit({this.changeTypeId = false});

  @override
  _PersonBasicEditState createState() => _PersonBasicEditState();
}

class _PersonBasicEditState extends State<PersonBasicEdit> {
  // TODO: 在页面消失的时候将状态栏改为白色，否则进入下个页面状态栏是黑色的，目前没有找到合适的方法，所以才先这样来实现的
  bool _pageDisappeared = false;

  Genders _gender = Genders.male;
  File _pickedFile;

  AccountPersonModel accountPersonModel;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _birthdayController = new TextEditingController();
  TextEditingController _workTimeController = new TextEditingController();
  TextEditingController _skillNameItemsController = new TextEditingController();
  TextEditingController _workNameItemsController = new TextEditingController();
  TextEditingController _companyNameController = new TextEditingController();

  ///全局保存当前context
  BuildContext _context;

  PersonEditSecond _personEdit = PersonEditSecond();

  Widget headImg = SizedBox.shrink();

  @override
  void initState() {
    accountPersonModel = g_accountManager.currentUser.userData;
    _personEdit.initValue();
    if (accountPersonModel != null) {
      if (accountPersonModel.sexName == "女") {
        _gender = Genders.female;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    if (accountPersonModel != null) {
      if (accountPersonModel.headPortraitUrl != null &&
          accountPersonModel.headPortraitUrl != "") {
        _personEdit.url = accountPersonModel.headPortraitUrl;
        headImg = Image.network(accountPersonModel.headPortraitUrl,
            width: 50, height: 50, fit: BoxFit.cover);
      }
      if (accountPersonModel.realname != null &&
          accountPersonModel.realname != "") {
        _nameController.text = accountPersonModel.realname;
      }
      if (accountPersonModel.birthday != null &&
          accountPersonModel.birthday != "") {
        _birthdayController.text = accountPersonModel.birthday;
      }
      if (accountPersonModel.startWorkingTime != null &&
          accountPersonModel.startWorkingTime != "") {
        _workTimeController.text = accountPersonModel.startWorkingTime;
      }
      if (accountPersonModel.tags != null && accountPersonModel.tags != "") {
        _skillNameItemsController.text = accountPersonModel.tags;
      }
      if (accountPersonModel.positionName != null &&
          accountPersonModel.positionName != "") {
        _personEdit.mapWork = {
          "name": accountPersonModel.positionName,
          "id": accountPersonModel.positionNo
        };
        _workNameItemsController.text = accountPersonModel.positionName;
      }
      if (accountPersonModel.companyName != null &&
          accountPersonModel.companyName != "") {
        _companyNameController.text = accountPersonModel.companyName;
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: GestureDetector(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 20, right: 20, top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTitleWidgets(),
                _buildAvatarWidgets(),
                _buildGenderWidgets(),
                _buildNameInputWidgets(),
                _buildBirthdayWidgets(context),
                _buildCompanyNameInputWidgets(),
                _buildWorkNameItems(),
                _buildWorkTimeWidgets(context),
                _buildSkillNameItems(),
                _buildCommitButton()
              ],
            ),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ));
  }

  Widget _buildAppBar() {
    return PreferredSize(
        preferredSize: Size(double.infinity, 44),
        child: AppBar(
          leading: IconButton(
            icon: Image.asset(
                join(AssetsUtil.assetsDirectoryCommon, "nav_back_black.png")),
            onPressed: () {
              ///back返回上一步
              Navigator.of(_context)..pop();
            },
          ),
          elevation: 0,
          brightness: _pageDisappeared ? Brightness.dark : Brightness.light,
          backgroundColor: Colors.white,

//        actions: <Widget>[
//          FlatButton(
//            child: Text("跳过", style: TextStyle(fontSize: 15, color: ColorConstants.textColor51)),
//            onPressed: () {
//              setState(() { _pageDisappeared = true; });
//              Get.offAll(HomeRoute());
//            },
//          )
//        ],
        ));
  }

  Widget _buildTitleWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('填写基本信息',
            style: TextStyle(
                fontSize: 24,
                color: ColorConstants.textColor51,
                fontWeight: FontWeight.bold)),
        Text('向招聘者介绍自己吧',
            style: TextStyle(
                fontSize: 13,
                color: Color.fromRGBO(102, 102, 102, 1),
                fontWeight: FontWeight.w500))
      ],
    );
  }

  Widget _buildAvatarWidgets() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('头像',
                    style: TextStyle(
                        fontSize: 17,
                        color: ColorConstants.textColor51,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text('上传求职照片被招聘者回复的几率翻倍',
                    style: TextStyle(
                        fontSize: 12, color: ColorConstants.textColor153)),
              ],
            ),
          ),
          InkWell(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: ColorConstants.themeColorBlue,
                  borderRadius: BorderRadius.circular(25)),
              child: _pickedFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.file(File(_pickedFile.path),
                          width: 50, height: 50, fit: BoxFit.cover))
                  : headImg,
            ),
            onTap: () async {
              var pickedFile = await ImagePicker.pickImage(
                  source: ImageSource.gallery, imageQuality: 50);
              if (pickedFile != null) {
                Get.to(HeadImageCrop(pickedFile.path)).then((value) {
                  if (value != null) {
                    setState(() {
                      _pickedFile = value as File;
                    });
                  }
                });
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildGenderWidgets() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('性别',
              style:
                  TextStyle(fontSize: 17, color: ColorConstants.textColor51)),
          Row(
            children: <Widget>[
              SizedBox(
                width: 90,
                child: RadioListTile(
                    title: Text('男'),
                    value: Genders.male,
                    groupValue: _gender,
                    onChanged: (Genders value) {
                      setState(() {
                        _gender = value;
                      });
                    }),
              ),
              SizedBox(
                width: 90,
                child: RadioListTile(
                    title: Text('女'),
                    value: Genders.female,
                    groupValue: _gender,
                    onChanged: (Genders value) {
                      setState(() {
                        _gender = value;
                      });
                    }),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNameInputWidgets() {
    return Container(
        height: 90,
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: ColorConstants.dividerColor, width: 1))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('姓名',
                style: TextStyle(
                    fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1))),
            TextField(
              controller: _nameController,
              style: TextStyle(fontSize: 17, color: ColorConstants.textColor51),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请填写真实姓名',
                hintStyle:
                    TextStyle(fontSize: 17, color: ColorConstants.textColor153),
              ),
            )
          ],
        ));
  }

  Widget _buildCompanyNameInputWidgets() {
    return Container(
        height: 90,
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: ColorConstants.dividerColor, width: 1))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('公司名称(选填)',
                style: TextStyle(
                    fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1))),
            TextField(
              controller: _companyNameController,
              style: TextStyle(fontSize: 17, color: ColorConstants.textColor51),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请填写上一家公司',
                hintStyle:
                    TextStyle(fontSize: 17, color: ColorConstants.textColor153),
              ),
            )
          ],
        ));
  }

  Widget _buildBirthdayWidgets(parentContext) {
    return InkWell(
      child: Container(
        height: 90,
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: ColorConstants.dividerColor, width: 1))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('出生年月',
                style: TextStyle(
                    fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _birthdayController,
                    enabled: false,
                    style: TextStyle(
                        fontSize: 17, color: ColorConstants.textColor51),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '请选择出生年月',
                        hintStyle: TextStyle(
                            fontSize: 17, color: ColorConstants.textColor153)),
                  ),
                ),
                Image.asset(
                    join(AssetsUtil.assetsDirectoryCommon, 'arrow_down.png'))
              ],
            )
          ],
        ),
      ),
      onTap: () {
        DatePicker.showDatePicker(parentContext,
            maxDateTime: DateTime.now(),
            dateFormat: 'yyyy-MM-dd',
            locale: DateTimePickerLocale.zh_cn,
            onConfirm: (DateTime dateTime, List<int> selectedIndex) {
          _birthdayController.text = DateFormat('yyyy-MM-dd').format(dateTime);
        });
      },
    );
  }

  Widget _buildWorkTimeWidgets(parentContext) {
    return InkWell(
      child: Container(
        height: 90,
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: ColorConstants.dividerColor, width: 1))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('参加工作时间',
                style: TextStyle(
                    fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1))),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _workTimeController,
                    enabled: false,
                    style: TextStyle(
                        fontSize: 17, color: ColorConstants.textColor51),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '请选择首次参加工作时间',
                        hintStyle: TextStyle(
                            fontSize: 17, color: ColorConstants.textColor153)),
                  ),
                ),
                Image.asset(
                    join(AssetsUtil.assetsDirectoryCommon, 'arrow_down.png'))
              ],
            )
          ],
        ),
      ),
      onTap: () {
        DatePicker.showDatePicker(parentContext,
            maxDateTime: DateTime.now(),
            dateFormat: 'yyyy-MM-dd',
            locale: DateTimePickerLocale.zh_cn,
            onConfirm: (DateTime dateTime, List<int> selectedIndex) {
          _workTimeController.text = DateFormat('yyyy-MM-dd').format(dateTime);
        });
      },
    );
  }

  Widget _buildSkillNameItems() {
    return InkWell(
      child: Container(
        height: 90,
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: ColorConstants.dividerColor, width: 1))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('技能标签',
                style: TextStyle(
                    fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1))),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _skillNameItemsController,
                    enabled: false,
                    style: TextStyle(
                        fontSize: 17, color: ColorConstants.textColor51),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '点击选择你的技能标签',
                        hintStyle: TextStyle(
                            fontSize: 17, color: ColorConstants.textColor153)),
                  ),
                ),
                Image.asset(
                    join(AssetsUtil.assetsDirectoryCommon, 'arrow_down.png'))
              ],
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.of(_context).push(MaterialPageRoute(builder: (context) {
          return PersonBasicEditSecond(_personEdit);
        })).then((value) {
          if (value != null) {
            _personEdit = value;
            _skillNameItemsController.text = value.tag;
          }
        });
      },
    );
  }

  Widget _buildWorkNameItems() {
    return InkWell(
      child: Container(
        height: 90,
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: ColorConstants.dividerColor, width: 1))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('岗位',
                style: TextStyle(
                    fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1))),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _workNameItemsController,
                    enabled: false,
                    style: TextStyle(
                        fontSize: 17, color: ColorConstants.textColor51),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '点击选择您的岗位',
                        hintStyle: TextStyle(
                            fontSize: 17, color: ColorConstants.textColor153)),
                  ),
                ),
                Image.asset(
                    join(AssetsUtil.assetsDirectoryCommon, 'arrow_down.png'))
              ],
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.of(_context).push(MaterialPageRoute(builder: (context) {
          return ChooseWorkName();
        })).then((value) {
          _personEdit.mapWork = value;
          if (value != null) _workNameItemsController.text = value["name"];
        });
      },
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
                borderRadius: BorderRadius.circular(8)),
            child: Text(widget.changeTypeId ? '确认切换身份' : '保存',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ),
          onTap: () {
            _savePersonInfo();
          }),
    );
  }

  void _savePersonInfo() {
    BotToast.showLoading();

    if (_pickedFile != null) {
      FormData formData = FormData.fromMap(
          {"file": MultipartFile.fromFileSync(_pickedFile.path)});
      DioUtil.request("/user/uploadHeadPortrait", parameters: formData)
          .then((responseData) {
        print(responseData);
        bool success = DioUtil.checkRequestResult(responseData);
        if (success) {
          _personEdit.url = responseData["data"]["worksUrl"] as String;
          _savePersonInfoAfterHeaderUpload();
        } else {
          BotToast.closeAllLoading();
        }
      }).catchError((error) {
        BotToast.closeAllLoading();
      });
    } else {
      BotToast.closeAllLoading();
      _savePersonInfoAfterHeaderUpload();
    }
  }

  void _savePersonInfoAfterHeaderUpload() {
    BotToast.closeAllLoading();
    String realName = _nameController.text;
    String birthdayString = _birthdayController.text;
    String workTimeString = _workTimeController.text;
    int genderInt = 0; // 性别 0.保密1.男2.女

    if (realName == '') {
      BotToast.showText(text: '请输入真实姓名');
      return;
    }

    if (birthdayString == '') {
      BotToast.showText(text: '请输入出生日期');
      return;
    }

    if (workTimeString == '') {
      BotToast.showText(text: '请输入首次工作时间');
      return;
    }

    if (_gender == Genders.male) {
      genderInt = 1;
    } else if (_gender == Genders.female) {
      genderInt = 2;
    }

    _personEdit.realName = realName;
    _personEdit.birthdayString = birthdayString;
    _personEdit.workTimeString = workTimeString;
    _personEdit.genderInt = genderInt;
    _personEdit.tag = _skillNameItemsController.text;
    _personEdit.companyName = _companyNameController.text;
    _personEdit.saveAndUpdateUser(flag: widget.changeTypeId);
  }
}
