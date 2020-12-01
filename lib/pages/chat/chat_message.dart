import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/chat/chat_message_look.dart';
import 'package:youpinapp/pages/chat/chat_message_market.dart';
import 'package:youpinapp/pages/chat/chat_message_ring.dart';
import 'package:youpinapp/pages/common/search_bar.dart';

class ChatMessage extends StatefulWidget {
  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> with SingleTickerProviderStateMixin {
  TabController _tabController;

//  List<String> _tabBarTitles = ['集市', '谁看了我', '求职铃'];
  List<String> _tabBarTitles = ['集市', '求职铃'];

  _ChatMessageState() {
    _tabController = TabController(length: _tabBarTitles.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SearchBar('消息搜索'),
        _buildTabBar(),
        Expanded(
          child: _buildTabBarView()
        )
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 26,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicator: BoxDecoration(),
        labelPadding: EdgeInsets.only(right: 20),
        labelColor: ColorConstants.textColor51,
        labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        unselectedLabelColor: ColorConstants.textColor153,
        unselectedLabelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        tabs: _tabBarTitles.map((title) {
          return Tab(text: title);
        }).toList(),
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        ChatMessageMarket(),
        ChatMessageRing(),
//        ChatMessageLook(),
      ]
    );
  }
}