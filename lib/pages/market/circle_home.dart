import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/common/floating_button.dart';
import 'package:youpinapp/pages/common/sort_widget.dart';
import 'package:youpinapp/pages/market/circle_switch_widget.dart';
import 'package:youpinapp/pages/market/market_post_list.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';

class CircleHome extends StatefulWidget implements PreferredSizeWidget {
  final int typeId; // 圈子类型id，12345对应推荐、校友、同乡、行业、创业
  final int circleId;

  CircleHome(this.typeId, this.circleId);

  @override
  _CircleHomeState createState() => _CircleHomeState();

  @override
  Size get preferredSize => Size.fromHeight(44);
}

class _CircleHomeState extends State<CircleHome> with TickerProviderStateMixin {
  int _currentTabBarIndex = 0;
  var _tabBarList = ['最新', '精华'];
  var _sortTitles = ['U币'];
  CircleDetailModel _circleDetailModel = new CircleDetailModel();
  TabController _tabController;

  Map params, paramsJh;

  _CircleHomeState() {
    _tabController = TabController(
        initialIndex: _currentTabBarIndex,
        length: _tabBarList.length,
        vsync: this);
  }

  MarketPostListProvider marketPostListProvider = new MarketPostListProvider();
  MarketPostListProvider marketPostListProviderJH =
      new MarketPostListProvider();
  @override
  void initState() {
    super.initState();
    params = {'marketCircleId': widget.circleId};
    paramsJh = {'marketCircleId': widget.circleId, 'likesOrder': -1};
    _loadCircleDetail();
  }

  int indexFlag = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: <Widget>[
          _buildHead(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _buildTabBar(),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: SortWidget(_sortTitles),
                    onTap: () {
                      if (indexFlag == 1) {
                        indexFlag = -1;
                      } else {
                        indexFlag = 1;
                      }
                      params['ucoinAmountOrder'] = indexFlag;
                      paramsJh['ucoinAmountOrder'] = indexFlag;
                      marketPostListProvider.getRefresh(
                          "/market/getMarketList", params);
                      marketPostListProviderJH.getRefresh(
                          "/market/getMarketList", paramsJh);
                    },
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: 15),
                child: CircleSwitchWidget(
                    [marketPostListProvider, marketPostListProviderJH],
                    "/market/getMarketList",
                    [params, paramsJh]),
              )
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Container(
                    constraints: BoxConstraints.expand(),
                    child: MarketPostList([], "/market/getMarketList", params,
                        refreshByMine: true,
                        marketPostListProvider: marketPostListProvider,
                        scrollerFlag: true)),
                Container(
                    constraints: BoxConstraints.expand(),
                    child: MarketPostList([], "/market/getMarketList",
                        {'marketCircleId': widget.circleId, 'likesOrder': -1},
                        refreshByMine: true,
                        marketPostListProvider: marketPostListProviderJH,
                        scrollerFlag: true)),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingButton.buildMarketPublishButton(
          context, 'float', widget.typeId,
          circleId: widget.circleId),
    );
  }

  // AppBar
  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Image.asset(
            join(AssetsUtil.assetsDirectoryCommon, 'nav_back_black.png')),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: 30,
            child: IconButton(
                icon: Image.asset(join(
                    AssetsUtil.assetsDirectoryMarket, 'icon_circle_msg.png'))),
          ),
          Container(
            width: 30,
            margin: EdgeInsets.only(left: 3),
            child: IconButton(
                icon: Image.asset(join(AssetsUtil.assetsDirectoryMarket,
                    'icon_circle_search.png'))),
          ),
          Container(
            width: 30,
            child: IconButton(
                icon: Image.asset(join(AssetsUtil.assetsDirectoryMarket,
                    'icon_circle_share.png'))),
          ),
        ],
      ),
    );
  }

  // 圈子头像
  Widget _buildHead(BuildContext parentContext) {
    CircleDetailMasterModel masterModel =
        _circleDetailModel.marketCircleLeaderEntity ??
            CircleDetailMasterModel();
    String currentUserId = g_accountManager.currentUser.id;
    String circleMasterId = masterModel.id;

    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                        color: ColorConstants.backgroundColor,
                        child: CachedNetworkImage(
                          imageUrl: _circleDetailModel.logoUrl ?? "",
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ))),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_circleDetailModel.circleName ?? "",
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(1, 1, 1, 1),
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Container(
                                color: ColorConstants.backgroundColor,
                                child: CachedNetworkImage(
                                  imageUrl: masterModel.headPortraitUrl ?? "",
                                  width: 18,
                                  height: 18,
                                  fit: BoxFit.cover,
                                ))),
                        Container(
                          margin: EdgeInsets.only(left: 4.5, right: 4.5),
                          child: Text(masterModel.nickname ?? "",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: ColorConstants.textColor153)),
                        ),
                        (currentUserId == circleMasterId)
                            ? Container(
                                padding: EdgeInsets.only(
                                    top: 2.5,
                                    bottom: 2.5,
                                    left: 3.5,
                                    right: 3.5),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(238, 238, 238, 1),
                                    borderRadius: BorderRadius.circular(3)),
                                child: Text('圈主',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: ColorConstants.textColor153)),
                              )
                            : SizedBox.shrink()
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 80,
              padding: EdgeInsets.only(
                top: 4,
                bottom: 6,
              ),
              color: Color.fromRGBO(0, 0, 0, 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 2,
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 2,
                    ),
                    child: Text(
                      '已加入',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建TabBar
  Widget _buildTabBar() {
    return Container(
      height: 40,
      padding: EdgeInsets.only(left: 20, right: 10),
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelPadding: EdgeInsets.only(right: 7.5, left: 7.5),
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: ColorConstants.textColor51,
        indicatorPadding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 0,
        ),
        unselectedLabelColor: ColorConstants.textColor51.withOpacity(0.5),
        unselectedLabelStyle:
            TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        labelColor: ColorConstants.textColor51,
        labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        tabs: _tabBarList.map((title) {
          return Tab(text: title);
        }).toList(),
      ),
    );
  }

  void _loadCircleDetail() {
    var params = {'id': widget.circleId};
    DioUtil.request('/market/getMarketCircleDetails', parameters: params)
        .then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData);
      if (success) {
        setState(() {
          _circleDetailModel = CircleDetailModel.fromJson(responseData['data']);
        });
      }
    });
  }
}
