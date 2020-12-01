import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/account_model.dart';
import 'package:youpinapp/pages/agreement/agreement_detail_route.dart';
import 'package:youpinapp/pages/bankcard/bank_card_main.dart';
import 'package:youpinapp/pages/bankcard/bank_card_tixian_end.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/pages/login/login_route.dart';
import 'package:youpinapp/pages/setting/help.dart';
import 'package:youpinapp/pages/setting/identity_switch_route.dart';
import 'package:youpinapp/pages/setting/updataApp.dart';
import 'package:youpinapp/utils/assets_util.dart';

class SettingIndex extends StatefulWidget {
  @override
  _SettingIndexState createState() => _SettingIndexState();
}

class _SettingIndexState extends State<SettingIndex> {
  String _identityString = "";

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    AccountModel currentUser = g_accountManager.currentUser;
    int typeId = currentUser.typeId;

    if (typeId == 1) {
      _identityString = "个人";
    } else {
      _identityString = "企业";
    }

    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWhite(title: "设置"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _buildMenuList(),
          ),
          _buildLogoutButton(context)
        ],
      ),
    );
  }

  Widget _buildMenuList() {
    return ListView(
      padding: EdgeInsets.only(left: 20, right: 20),
      itemExtent: 50,
      children: <Widget>[
        _buildMenuListRow("身份切换", menuIndex: 0, value: _identityString, forwardWidget: IdentitySwitchRoute()),
        _buildMenuListRow("银行卡绑定", menuIndex: 1,forwardWidget: BankCardMain()),
//        _buildMenuListRow("通知与提醒", menuIndex: 2),
        _buildMenuListRow("隐私政策 | 服务协议", menuIndex: 3,forwardWidget: AgreementDetailRoute("隐私政策 | 服务协议",index: 3,)),
        _buildMenuListRow("帮助与反馈", menuIndex: 4,forwardWidget: UserHelp()),
        _buildMenuListRow("检查更新", menuIndex: 5, value: "1.1.0",forwardWidget: UpDataApp()),
//        _buildMenuListRow("开发票", menuIndex: 6),
      ],
    );
  }

  Widget _buildMenuListRow(String title, {String value = "", int menuIndex, bool canForward = true, Widget forwardWidget}) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 15, color: ColorConstants.textColor51)),
          Row(
            children: <Widget>[
              Text(value, style: TextStyle(fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1))),
              SizedBox(width: 10),
              Image.asset(join(AssetsUtil.assetsDirectoryCommon, "icon_forward_small.png"))
            ],
          )
        ],
      ),
      onTap: () async {
        if (forwardWidget != null) {
          await Get.to(forwardWidget);
        }

        _refreshData();
      },
    );
  }

  Widget _buildLogoutButton(BuildContext parentContext) {
    return Container(
      height: 134,
      child: UnconstrainedBox(
        child: Container(
          width: (ScreenUtil.mediaQueryData.size.width - 65),
          height: 44,
          decoration: BoxDecoration(
              color: Color.fromRGBO(238, 238, 238, 0.5),
              borderRadius: BorderRadius.circular(5)
          ),
          child: FlatButton(
            child: Text("退出登录", style: TextStyle(fontSize: 15, color: Color.fromRGBO(102, 102, 102, 1), fontWeight: FontWeight.bold)),
            onPressed: () {
              showDialog(
                  context: parentContext,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("温馨提示"),
                      content: Text("确定要退出吗？"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("取消"),
                          onPressed: () => Navigator.of(parentContext).pop(),
                        ),
                        FlatButton(
                          child: Text("确定"),
                          onPressed: () {
                            g_accountManager.clearLocalUser();
                            TencentImPlugin.logout().then((value){
                              Get.offAll(LoginRoute());
                            }).catchError((e){
                              Get.offAll(LoginRoute());
                            });
                          },
                        )
                      ],
                    );
                  }
              );
            },
          ),
        ),
      )
    );
  }
}