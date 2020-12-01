import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/publish/publish_company_video.dart';
import 'package:youpinapp/pages/publish/publish_invite_video.dart';
import 'package:youpinapp/pages/publish/publish_resume_video.dart';
import 'package:youpinapp/pages/publish/publish_short_video.dart';
import 'package:youpinapp/utils/assets_util.dart';

class PublishMenu extends StatefulWidget {
  @override
  _PublishMenuState createState() => _PublishMenuState();
}

class _PublishMenuState extends State<PublishMenu> {
  @override
  Widget build(BuildContext context) {
    var btnShortVideo = FlatButton(
      padding: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Image.asset(join(AssetsUtil.assetsDirectoryPublish, 'pub_menu_zuopin.png')),
          SizedBox(height: 10),
          Text('作品', style: TextStyle(fontSize: 15, color: ColorConstants.textColor51))
        ],
      ),
      onPressed: () {
        Get.off(PublishShortVideo());
      },
    );

    var btnResumeVideo = FlatButton(
      padding: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Image.asset(join(AssetsUtil.assetsDirectoryPublish, 'pub_menu_zhaopin.png')),
          SizedBox(height: 10),
          Text(g_accountManager.currentUser.typeId == 1 ? "简历" : "招聘", style: TextStyle(fontSize: 15, color: ColorConstants.textColor51))
        ],
      ),
      onPressed: () {
        if (g_accountManager.currentUser.typeId == 1) { // 个人
          Get.off(PublishResumeVideo());
        } else if (g_accountManager.currentUser.typeId == 2) { // 企业
          Get.off(PublishInviteVideo());
        }
      },
    );

    var btnCompanyVideo = FlatButton(
      padding: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Image.asset(join(AssetsUtil.assetsDirectoryPublish, 'pub_menu_qixuan.png')),
          SizedBox(height: 10),
          Text("企宣", style: TextStyle(fontSize: 15, color: ColorConstants.textColor51))
        ],
      ),
      onPressed: () {
        Get.off(PublishCompanyVideo());
      },
    );

    List<Widget> childWidgets = [btnShortVideo, btnResumeVideo];
    if (g_accountManager.currentUser.typeId == 2) {
      childWidgets.add(btnCompanyVideo);
    }

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: childWidgets,
            ),
            SizedBox(
              height: 158,
              child: Container(
                padding: EdgeInsets.only(top: 50),
                alignment: Alignment.topCenter,
                child: IconButton(
                  icon: Image.asset(join(AssetsUtil.assetsDirectoryPublish, 'pub_menu_close.png')),
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}