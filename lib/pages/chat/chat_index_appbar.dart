import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/chat/chat_friends_list.dart';
import 'package:youpinapp/utils/assets_util.dart';

class ChatIndexAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TabBar chatTabBar;

  ChatIndexAppBar(this.chatTabBar);

  @override
  _ChatIndexAppBarState createState() => _ChatIndexAppBarState(this.chatTabBar);

  @override
  Size get preferredSize => Size.fromHeight(44);
}

class _ChatIndexAppBarState extends State<ChatIndexAppBar> {
  final TabBar chatTabBar;

  _ChatIndexAppBarState(this.chatTabBar);

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
                  child: this.chatTabBar,
                ),
                ButtonTheme(
                  minWidth: 40,
                  child: FlatButton.icon(onPressed: (){
                    Get.to(ChatFriendsList());
                  }, icon: Image.asset(join(AssetsUtil.assetsDirectoryChat, 'icon_chat_friend.png')), label: SizedBox.shrink()),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}