import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youpinapp/pages/common/floating_button.dart';
import 'package:youpinapp/pages/market/market_circle.dart';
import 'package:youpinapp/pages/market/market_index_appbar.dart';
import 'package:youpinapp/pages/market/market_recommend_post_list.dart';

class MarketIndex extends StatefulWidget {
  @override
  _MarketIndexState createState() => _MarketIndexState();
}

class _MarketIndexState extends State<MarketIndex> with SingleTickerProviderStateMixin {
  int _currentTypeId = 1;
  List<String> _tabbarTitles = ['推荐', '校友', '同乡', '行业', '创业'];

  TabBar _tabBar;
  TabController _tabController;

  _MarketIndexState() {
    _tabController = TabController(length: _tabbarTitles.length, vsync: this);

    _tabBar = TabBar(
      isScrollable: true,
      controller: _tabController,
      unselectedLabelColor: Colors.white.withOpacity(0.6),
      unselectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      labelColor: Colors.white,
      labelStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
      indicatorColor: Colors.white,
      indicatorPadding: EdgeInsets.only(bottom: 8),
      indicatorSize: TabBarIndicatorSize.label,
      tabs: _tabbarTitles.map((title) {
        return Tab(text: title);
      }).toList(),
      onTap: (index) {
        setState(() {
          _currentTypeId = index + 1;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MarketIndexAppBar(_tabBar),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          MarketRecommendPostList(),
          MarketCircle(2, '校友'),
          MarketCircle(3, '同乡'),
          MarketCircle(4, '行业'),
          MarketCircle(5, '创业'),
        ],
      ),
      floatingActionButton: FloatingButton.buildMarketPublishButton(context, 'MarketIndex', _currentTypeId),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}