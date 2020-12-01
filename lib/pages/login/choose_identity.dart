import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/storage.dart';
import 'package:youpinapp/pages/home/home_route.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/size_util.dart';

class ChooseIdentity extends StatefulWidget {
  @override
  _ChooseIdentityState createState() => _ChooseIdentityState();
}

class _ChooseIdentityState extends State<ChooseIdentity> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    g_sizeUtil.init(context); // 初始化尺寸工具类
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Container(
          padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight.h + 40.h, left: 30.w, right: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildText1(),
              _buildText2(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildButton1(context),
                    _buildButton2(context),
                    _buildButton3(context),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText1() {
    return Container(
      margin: EdgeInsets.only(left: 12.w),
      child: Text('请选择您的身份', style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold, color: Color.fromRGBO(57, 49, 49, 1))),
    );
  }

  Widget _buildText2() {
    return Container(
      margin: EdgeInsets.only(top: 10.h, left: 12.w),
      child: Text('方便我们为您提供更准确的服务', style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold, color: Color.fromRGBO(57, 49, 49, 0.5))),
    );
  }

  Widget _buildButton1(BuildContext context) {
    return Container(
//      margin: EdgeInsets.only(top: 200.h),
      child: GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset(join(AssetsUtil.assetsDirectoryLogin, 'bg_identity_choose.png')),
            Positioned(
              left: 5,
              child: Image.asset(join(AssetsUtil.assetsDirectoryLogin, 'identity_worker.png'), height: 170.h, fit: BoxFit.cover)
            ),
            Positioned(
              right: 60.w,
              child: Text('个人', style: TextStyle(fontSize: 32.sp, color: Color.fromRGBO(57, 49, 49, 1)))
            )
          ],
        ),
        onTap: () {
          var params = {
            'vcode': '123456',
            'phonenumber': '17777777777'
          };

          // userType为2表示企业
          setState(() { _saving = true; });
          DioUtil.request('/user/login', parameters: params).then((responseData) {
            print(responseData);
            bool success = DioUtil.checkRequestResult(responseData, showToast: true);
            if (success) {
              g_accountManager.refreshLocalUser(responseData['data']);

              // userType为2表示企业
              g_storageManager.setStorage(StorageManager.keyCurrentUserType, '2').then((value) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return HomeRoute();
                  }
                ));
              });
            }
          }).whenComplete(() {
            setState(() { _saving = false; });
          });
        },
      ),
    );
  }

  Widget _buildButton2(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 30.h),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset(join(AssetsUtil.assetsDirectoryLogin, 'bg_identity_choose.png')),
            Positioned(
              left: 5,
              child: Image.asset(join(AssetsUtil.assetsDirectoryLogin, 'identity_boss.png'), height: 170.h, fit: BoxFit.cover),
            ),
            Positioned(
              right: 60.w,
              child: Text('企业', style: TextStyle(fontSize: 32.sp, color: Color.fromRGBO(57, 49, 49, 1)))
            )
          ],
        ),
      ),
      onTap: () {
        var params = {
          'vcode': '123456',
          'phonenumber': '15178763584'
        };

        // userType为1表示个人
        setState(() { _saving = true; });
        DioUtil.request('/user/login', parameters: params).then((responseData) {
          setState(() { _saving = false; });

//          print(convert.jsonEncode(responseData));
          bool success = DioUtil.checkRequestResult(responseData, showToast: true);
          if (success) {
            g_accountManager.refreshLocalUser(responseData['data']);

            // userType为1表示个人
            g_storageManager.setStorage(StorageManager.keyCurrentUserType, '1').then((value) {
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                return HomeRoute();
              }));
            });
          }
        });
      },
    );
  }

  Widget _buildButton3(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 30.h),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset(join(AssetsUtil.assetsDirectoryLogin, 'bg_identity_choose.png')),
            Positioned(
              left: 5,
              child: Image.asset(join(AssetsUtil.assetsDirectoryLogin, 'identity_boss.png'), height: 170.h, fit: BoxFit.cover),
            ),
            Positioned(
              right: 60.w,
              child: Text('游客', style: TextStyle(fontSize: 32.sp, color: Color.fromRGBO(57, 49, 49, 1)))
            )
          ],
        ),
      ),
      onTap: () {
        var params = {
          'vcode': '123456',
          'phonenumber': '15178763584'
        };

        // userType为1表示个人
        setState(() { _saving = true; });
        DioUtil.request('/user/login', parameters: params).then((responseData) {
          setState(() { _saving = false; });

          bool success = DioUtil.checkRequestResult(responseData, showToast: true);
          if (success) {
            g_accountManager.refreshLocalUser(responseData['data']);

            // userType为1表示个人
            g_storageManager.setStorage(StorageManager.keyCurrentUserType, '3').then((value) {
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                return HomeRoute();
              }));
            });
          }
        });
      },
    );
  }
}