import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/utils/assets_util.dart';

class CircleComments extends StatefulWidget {
  @override
  _CircleCommentsState createState() => _CircleCommentsState();
}

class _CircleCommentsState extends State<CircleComments> with SingleTickerProviderStateMixin {
  List<String> _tabBarTitles = ['全部回复', '只看楼主'];
  TabController _tabController;

  _CircleCommentsState() {
    _tabController = TabController(length: _tabBarTitles.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        leading: IconButton(
          icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'nav_back_black.png')),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(right: 50),
          child: Center(
            child: Text('重工校友集', style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          _buildHeader(),
          _buildList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: <Widget>[
                  _buildHeaderAvatar(),
                  _buildHeaderContent(),
                  _buildCommentButtons(),
                ],
              ),
            ),
            Container(
              height: 5,
              color: Color.fromRGBO(237, 237, 237, 0.5),
            ),
            _buildTabBar(),
          ],
        ),
      ),
    );
  }
  Widget _buildHeaderAvatar() {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'def_avatar.png')),
          SizedBox(width: 15),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('羡羡的小兔叽', style: TextStyle(fontSize: 15, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text('06-06 重庆', style: TextStyle(fontSize: 13, color: ColorConstants.textColor153))
            ],
          )),
          Container(
            width: 80,
            height: 32,
            decoration: BoxDecoration(
              color: ColorConstants.themeColorBlue,
              borderRadius: BorderRadius.circular(16)
            ),
            child: FlatButton.icon(
              icon: Image.asset(join(AssetsUtil.assetsDirectoryMarket, 'icon_focus_add.png')),
              label: Text('关注', style: TextStyle(fontSize: 15, color: Colors.white)),
              onPressed: () {
              }),
          )
        ],
      ),
    );
  }
  Widget _buildHeaderContent() {
    return Container(
      child: Text('有没有要学吉他和尤克里里的朋友，超低学费，感 兴趣的联系我。', style: TextStyle(fontSize: 15, color: ColorConstants.textColor51)),
    );
  }
  Widget _buildCommentButtons() {
    var textStyle = TextStyle(fontSize: 15, color: Color.fromRGBO(141, 141, 141, 1));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ButtonTheme(
          minWidth: 0,
          child: FlatButton.icon(onPressed: null, padding: EdgeInsets.only(bottom: 10, top: 10), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, icon: Image.asset(join(AssetsUtil.assetsDirectoryMarket, 'icon_circle_share.png')), label: Text('6', style: textStyle)),
        ),
        ButtonTheme(
          minWidth: 0,
          child: FlatButton.icon(onPressed: null, padding: EdgeInsets.only(bottom: 10, top: 10), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, icon: Image.asset(join(AssetsUtil.assetsDirectoryMarket, 'market_comment.png')), label: Text('6', style: textStyle)),
        ),
        ButtonTheme(
          minWidth: 0,
          child: FlatButton.icon(onPressed: null, padding: EdgeInsets.only(bottom: 10, top: 10), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, icon: Image.asset(join(AssetsUtil.assetsDirectoryMarket, 'market_praise.png')), label: Text('2596', style: textStyle)),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      width: 170,
      padding: EdgeInsets.only(left: 20),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(),
        labelPadding: EdgeInsets.zero,
        unselectedLabelColor: ColorConstants.textColor51.withOpacity(0.6),
        unselectedLabelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        labelColor: ColorConstants.textColor51,
        labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        tabs: _tabBarTitles.map((title) {
          return Tab(text: title);
        }).toList(),
      ),
    );
  }

  Widget _buildList() {
    return SliverList (
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        if (index % 2 == 0) {
          return Container(color: Colors.red, height: 25);
        } else {
          return Container(color: Colors.blue, height: 50);
        }
      }, childCount: 10),
    );
  }
}