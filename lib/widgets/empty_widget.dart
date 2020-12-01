import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/utils/assets_util.dart';

class EmptyWidget extends StatelessWidget {

  String showTitle = "列表空空如也~快去添加吧！";
  double mHeight = double.infinity;

  EmptyWidget({this.showTitle = "列表空空如也~快去添加吧！",this.mHeight = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      height: mHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(join(AssetsUtil.assetsDirectoryCommon, "empty_img.png")),
          SizedBox(height: 20),
          Text(showTitle, style: TextStyle(fontSize: 18, color: ColorConstants.textColor153))
        ],
      )
    );
  }
}