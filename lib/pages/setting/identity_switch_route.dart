import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/account_model.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/pages/company/company_basic_edit_01.dart';
import 'package:youpinapp/pages/person/person_basic_edit.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/event_bus.dart';

class IdentitySwitchRoute extends StatefulWidget {
  @override
  _IdentitySwitchRouteState createState() => _IdentitySwitchRouteState();
}

class _IdentitySwitchRouteState extends State<IdentitySwitchRoute> {
  String _identityString = "";
  String _reverseIdentityString = "";
  int typeId = 1;

  void _refreshData() {
    AccountModel currentUser = g_accountManager.currentUser;
    typeId = currentUser.typeId;
    if (typeId == 1) {
      _identityString = "牛人";
      // _identityString = "个人";
      _reverseIdentityString = "企业";
    } else if (typeId == 2) {
      _identityString = "企业";
      _reverseIdentityString = "牛人";
      // _reverseIdentityString = "个人";
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWhite(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildTopWidgets(),
          ),
          _buildBottomWidgets(context)
        ],
      ),
    );
  }

  Widget _buildTopWidgets() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
            join(AssetsUtil.assetsDirectorySetting, "switch_identity_img.png")),
        SizedBox(height: 60),
        Text("您当前的身份是“$_identityString”",
            style: TextStyle(
                fontSize: 17,
                color: ColorConstants.themeColorBlue,
                fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget _buildBottomWidgets(parentContext) {
    return Container(
      height: 130,
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          InkWell(
            child: Container(
              height: 44,
              margin: EdgeInsets.only(left: 32.5, right: 32.5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: ColorConstants.themeColorBlue,
                  borderRadius: BorderRadius.circular(6)),
              child: Text("切换为“$_reverseIdentityString”身份",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ),
            onTap: () {
              if (typeId == 1) {
                Get.off(CompanyBasicEdit01(
                  changeTypeId: true,
                ));
              } else {
                Get.off(PersonBasicEdit(
                  changeTypeId: true,
                ));
              }

//              showDialog(
//                context: parentContext,
//                barrierDismissible: false,
//                child: AlertDialog(
//                  title: Text("温馨提示"),
//                  content: Text("确定要将当前身份切换为$_reverseIdentityString吗？"),
//                  actions: <Widget>[
//                    FlatButton(
//                      child: Text("确定"),
//                      onPressed: () {
//                        _setUserIdentity(parentContext);
//                      },
//                    ),
//                    FlatButton(
//                      child: Text("取消"),
//                      onPressed: () {
//                        Navigator.of(parentContext).pop();
//                      },
//                    )
//                  ],
//                )
//              );
            },
          )
        ],
      ),
    );
  }

  void _setUserIdentity(parentContext) {
    int newTypeId = g_accountManager.currentUser.typeId;
    if (newTypeId == 1) {
      newTypeId = 2;
    } else {
      newTypeId = 1;
    }

    var params = {"typeId": newTypeId};
    BotToast.showLoading();
    DioUtil.request("/user/switchIdentities", parameters: params)
        .then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData);
      if (success) {
        g_accountManager.refreshRemoteUser().then((value) {
          _refreshData();

          BotToast.closeAllLoading();
          // TODO: 这里back不起作用，不知道是不是因为context的原因
//          Get.back();
          Navigator.of(parentContext).pop();
        });
      } else {
        BotToast.closeAllLoading();
      }
    }).catchError((error) {
      BotToast.closeAllLoading();
    });
  }
}
