import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/utils/assets_util.dart';

class AppBarWhite extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;

  AppBarWhite({this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      leading: IconButton(
        icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, "nav_back_black.png")),
        onPressed: () {
          Get.back();
        },
      ),
      title: Text(title ?? "", style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
      centerTitle: true,
      actions: this.actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(44);
}