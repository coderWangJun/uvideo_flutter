import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/account_company_model.dart';
import 'package:youpinapp/pages/home/home_route.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/head_image_crop.dart';

import '../../utils/assets_util.dart';

enum Gender { male, female }

class CompanyBasicEdit01 extends StatefulWidget {

  bool changeTypeId = false;
  bool firstIntoFlag = false;
  CompanyBasicEdit01({this.changeTypeId = false,this.firstIntoFlag = false});

  @override
  _CompanyBasicEditImpl createState() => _CompanyBasicEditImpl();
}

class _CompanyBasicEditImpl extends State<CompanyBasicEdit01> {
  // TODO: 在页面消失的时候将状态栏改为白色，否则进入下个页面状态栏是黑色的，目前没有找到合适的方法，所以才先这样来实现的
  bool _pageWillDisappear = false;

  Gender _gender = Gender.male;

  ///保存头像
  File _pickedFile;

  Widget headImg = SizedBox.shrink();
  String _logoUrl;

  TextEditingController _nameController = new TextEditingController();
//  TextEditingController _companyController = new TextEditingController();
  TextEditingController _myWorkNameController = new TextEditingController();
  TextEditingController _myEmailController = new TextEditingController();
  
  ///方便全局获取context使用
  BuildContext _context;


  @override
  void dispose() {
    _nameController.dispose();
    _myWorkNameController.dispose();
    _myEmailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    DioUtil.request('/company/getCompanyStaff',parameters: {'isManager':1,'queryType':2}).then((value){
      if(DioUtil.checkRequestResult(value)){
        if(value["data"]!=null){
        Map m = value["data"][0];
        setState(() {
          if(m['headPortraitUrl']!=null && m['headPortraitUrl']!=""){
            headImg = Image.network(m['headPortraitUrl'] as String,width: 50, height: 50, fit: BoxFit.cover);
          }
          if((m['sex'] as num)==2){_gender = Gender.female;}
          if(m['name']!=null && m['name']!=""){
            _nameController.text = m['name'] as String;
          }
          if(m['position']!=null && m['position']!=""){
          _myWorkNameController.text = m['position'] as String;
          }
          if(m['email']!=null && m['email']!=""){
          _myEmailController.text = m['email'] as String;
          }
        });}
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    _context = context;

    return
//      MaterialApp(title: "company01",debugShowCheckedModeBanner: false,home:
        Scaffold(
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
//                  _buildCompanyInputWidgets(),
                  _buildMyWorkNameInputWidgets(),
                  _buildMyEmailInputWidgets(),
                  _buildCommitButton()
                ],
              ),
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          )
//      ),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
        preferredSize: Size(double.infinity, 44),
        child: AppBar(
          leading: IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon,"nav_back_black.png")),onPressed: (){
          ///back返回上一步
          Navigator.of(_context)..pop();
        },),
          elevation: 0,
          brightness: _pageWillDisappear ? Brightness.dark : Brightness.light,
          backgroundColor: Colors.white,

//          actions: <Widget>[
//
//            FlatButton(
//              child: Text('跳过', style: TextStyle(fontSize: 15, color: ColorConstants.textColor51)),
//              onPressed: () {
//                setState(() {
//                  _pageWillDisappear = true;
//                });
//                Get.offAll(HomeRoute());
//              },
//            )
//
//          ],

        )
    );
  }

  Widget _buildTitleWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('我的名片', style: TextStyle(fontSize: 24, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
        Text('向人才介绍一下自己', style: TextStyle(fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1), fontWeight: FontWeight.w500))
      ],
    );
  }

  ///头像
  Widget _buildAvatarWidgets() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('头像', style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
              ],
            ),
          ),
          InkWell(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: ColorConstants.themeColorBlue,
                  borderRadius: BorderRadius.circular(25)
              ),
              child: _pickedFile != null ? ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.file(File(_pickedFile.path), width: 50, height: 50, fit: BoxFit.cover)
              ) : headImg,
            ),
            onTap: () async {
              var pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
              if(pickedFile != null){
                Get.to(HeadImageCrop(pickedFile.path)).then((value){
                  if(value != null){
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

  ///性别
  Widget _buildGenderWidgets() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('性别', style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
          Row(
            children: <Widget>[
              SizedBox(
                width: 90,
                child: RadioListTile(
                    title: Text('男'),
                    value: Gender.male,
                    groupValue: _gender,
                    onChanged: (Gender value) {
                      setState(() {
                        _gender = value;
                      });
                    }
                ),
              ),
              SizedBox(
                width: 90,
                child: RadioListTile(
                    title: Text('女'),
                    value: Gender.female,
                    groupValue: _gender,
                    onChanged: (Gender value) {
                      setState(() {
                        _gender = value;
                      });
                    }
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  ///姓名
  Widget _buildNameInputWidgets() {
    return Container(
        height: 90,
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: ColorConstants.dividerColor, width: 1))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('姓名', style: TextStyle(fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1),fontWeight: FontWeight.w500,)),
            TextField(
              controller: _nameController,
              style: TextStyle(fontSize: 17, color: ColorConstants.textColor51),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请填写真实姓名',
                hintStyle: TextStyle(fontSize: 17, color: ColorConstants.textColor153),
              ),
            )
          ],
        )
    );
  }

  ///我的公司
  /*
  Widget _buildCompanyInputWidgets() {
    return Container(
        height: 90,
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: ColorConstants.dividerColor, width: 1))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('我的公司', style: TextStyle(fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1),fontWeight: FontWeight.w500,)),
            Container(height: 50,child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
              Expanded(child:
              TextField(
                    controller: _companyController,
                    style: TextStyle(fontSize: 17, color: ColorConstants.textColor51),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '你当前就职的公司',
                      hintStyle: TextStyle(fontSize: 17, color: ColorConstants.textColor153),
                    ),
                  ),),


//                IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon,"icon_forward_small.png")),onPressed: (){
//                  ///我也不知道这个到底能不能点，总之先放这儿了
//                  print("点了一下>");
//                },)


            ],),)
          ],
        )
    );
  }
*/

  ///我的职务
  Widget _buildMyWorkNameInputWidgets() {
    return Container(
        height: 90,
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: ColorConstants.dividerColor, width: 1))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('我的职务', style: TextStyle(fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1),fontWeight: FontWeight.w500,)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child:
                TextField(
                controller: _myWorkNameController,
                style: TextStyle(fontSize: 17, color: ColorConstants.textColor51),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '明确的职务。更能赢得人才的信任',
                  hintStyle: TextStyle(fontSize: 17, color: ColorConstants.textColor153),
                ),
              ),),


//              IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon,"icon_forward_small.png")),onPressed: (){
//                ///我也不知道这个到底能不能点，总之先放这儿了
//                print("点了一下>");
//              },)


            ],)
          ],
        )
    );
  }


  ///我的邮箱(选填)
  Widget _buildMyEmailInputWidgets() {
    return Container(
        height: 90,
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: ColorConstants.dividerColor, width: 1))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('我的邮箱', style: TextStyle(fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1),fontWeight: FontWeight.w500,)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Expanded(child:
              TextField(
                controller: _myEmailController,
                style: TextStyle(fontSize: 17, color: ColorConstants.textColor51),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请填写邮箱(选填)',
                  hintStyle: TextStyle(fontSize: 17, color: ColorConstants.textColor153),
                ),
              ),),


//              IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon,"icon_forward_small.png")),onPressed: (){
//                ///我也不知道这个到底能不能点，总之先放这儿了
//                print("点了一下>");
//              },)


            ],)
          ],
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
          child: Text(widget.changeTypeId?'确认切换身份':'保存', style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        onTap: _savePersonInfo,
      ),
    );
  }

  void _savePersonInfo() {
    BotToast.showLoading();
    if (_pickedFile != null) {
      FormData formData = FormData.fromMap({'file': MultipartFile.fromFileSync(_pickedFile.path)});
      DioUtil.request('/company/uploadCompanyLogo', parameters: formData).then((responseData) {
        bool success = DioUtil.checkRequestResult(responseData);
        if (success) {
          var data = responseData["data"];
          _logoUrl = data["worksUrl"];
          _saveCompanyInfoAfterUploadLogo();
        } else {
          BotToast.closeAllLoading();
        }
      }).catchError((error) {
        BotToast.closeAllLoading();
      });
    } else {
      _saveCompanyInfoAfterUploadLogo();
    }
  }

  void _saveCompanyInfoAfterUploadLogo() {
    String realName = _nameController.text;
//    String companyName = _companyController.text;
    String workName = _myWorkNameController.text;
    String email = _myEmailController.text;
    int genderInt = 0; // 性别 0.保密1.男2.女

    if (realName == '') {
      BotToast.showText(text: '请输入真实姓名');
      BotToast.closeAllLoading();
      return;
    }

//    if (companyName == '') {
//      BotToast.showText(text: '请输入公司名称');
//      return;
//    }

    if (workName == '') {
      BotToast.showText(text: '请输入职务名称');
      BotToast.closeAllLoading();
      return;
    }

    if(email != "" && email != null && !email.contains("@")){
      BotToast.showText(text: '你输入邮箱格式错误');
      BotToast.closeAllLoading();
      return;
    }

    if (_gender == Gender.male) {
      genderInt = 1;
    } else if (_gender == Gender.female) {
      genderInt = 2;
    }


    var saveParams = {
      'headPortraitUrl' : _logoUrl,
      'sex' : genderInt,
      'name' : realName,
      'email' : email,
      'position' : workName
    };
    BotToast.closeAllLoading();

    if(widget.changeTypeId){
      int typeId = 0;
      if(g_accountManager.currentUser.typeId==1){typeId = 2;}
      else{typeId = 1;}
      saveParams['userid'] = g_accountManager.currentUser.id;
          DioUtil.request("/company/addCompanyStaff", parameters: saveParams).then((responseData) {
            bool success = DioUtil.checkRequestResult(responseData);
            if (success) {
            DioUtil.request("/user/switchIdentities",parameters: {"typeId":typeId}).then((value){
              if(DioUtil.checkRequestResult(value)){
                setState(() { _pageWillDisappear = true; });
                g_accountManager.refreshRemoteUser().then((value) {
                  Get.back();
                }).whenComplete(() => BotToast.closeAllLoading());
            } else {
              BotToast.closeAllLoading();
            }
          }).catchError((error) {
            BotToast.closeAllLoading();
          });
        }
      });
    }else{
        DioUtil.request("/company/addCompanyStaff", parameters: saveParams).then((responseData) {
          bool success = DioUtil.checkRequestResult(responseData);
          if (success) {
            setState(() { _pageWillDisappear = true; });
            g_accountManager.refreshRemoteUser().then((value) {
              Get.back(result: widget.firstIntoFlag);
            }).whenComplete(() => BotToast.closeAllLoading());
          } else {
            BotToast.closeAllLoading();
          }
        }).catchError((error) {
          BotToast.closeAllLoading();
        });
    }
  }
}