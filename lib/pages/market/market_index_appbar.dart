import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/market/circle_find_route.dart';
import 'package:youpinapp/utils/assets_util.dart';

class MarketIndexAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TabBar tabBar;

  MarketIndexAppBar(this.tabBar);

  @override
  _MarketIndexAppBarState createState() => _MarketIndexAppBarState(this.tabBar);
  
  @override
  Size get preferredSize => Size.fromHeight(44);
}

class _MarketIndexAppBarState extends State<MarketIndexAppBar> with SingleTickerProviderStateMixin {
  final TabBar tabBar;

  _MarketIndexAppBarState(this.tabBar);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstants.themeColorBlue,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            width: ScreenUtil.mediaQueryData.size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: _buildTabBar(),
                ),
                _buildIconButton(context)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return this.tabBar;
  }

  Widget _buildIconButton(context) {
    return ButtonTheme(
      minWidth: 40,
      child: FlatButton.icon(
        icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_more.png')),
        label: SizedBox.shrink(),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return CircleFindRoute();
          }));
        })
    );
  }
}