import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youpinapp/pages/chat/chat_chat.dart';
import 'package:youpinapp/pages/chat/chat_index_appbar.dart';
import 'package:youpinapp/pages/chat/chat_message.dart';
import 'package:youpinapp/pages/chat/chat_notice.dart';
import 'package:youpinapp/pages/common/floating_button.dart';

class ChatIndex extends StatefulWidget {
  @override
  _ChatIndexState createState() => _ChatIndexState();
}

class _ChatIndexState extends State<ChatIndex>
    with SingleTickerProviderStateMixin {
  TabBar _tabBar;
  TabController _tabController;

  List<String> _tabBarTitles = ['聊天', '消息', '通知'];

  _ChatIndexState() {
    _tabController = TabController(length: _tabBarTitles.length, vsync: this);

    _tabBar = TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorPadding: EdgeInsets.all(8),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: Colors.white,
      labelColor: Colors.white,
      labelStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelColor: Colors.white.withOpacity(0.5),
      unselectedLabelStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.normal,
      ),
      tabs: _tabBarTitles.map((title) {
        return Tab(text: title);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatIndexAppBar(_tabBar),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ChatChat(),
          ChatMessage(),
          ChatNotice(),
        ],
      ),
      floatingActionButton: FloatingButton.buildJobRingButton('ChatIndex'),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }
}
