import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/company_video_model.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/chat/chat_route/chat_route.dart';
import 'package:youpinapp/pages/common/custom_notification.dart';
import 'package:youpinapp/pages/market/market_post_list.dart';
import 'package:youpinapp/pages/person/short_video_list_widget.dart';
import 'package:youpinapp/pages/player/player_state_provider.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/event_bus.dart';

// 用户详情模式
enum UserDetailShowMode {
  dark, // 深色模式
  light // 浅色模式
}

class UserDetailRoute extends StatefulWidget {
  final String userId;
  final UserDetailShowMode showMode;
  final bool isProduction;
  bool isCanGotoChat = true;

  UserDetailRoute({
    this.showMode = UserDetailShowMode.light,
    this.userId,
    this.isCanGotoChat = true,
    this.isProduction,
  });

  @override
  _HomeVideoPersonal createState() => _HomeVideoPersonal();
}

class _HomeVideoPersonal extends State<UserDetailRoute>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<UserDetailRoute> {
  String _currentUserId;
  OtherUserModel _currentUserModel = new OtherUserModel();
  ShortVideoModel _currentVideoModel;
  List<String> _tagNames = ['知书达理', '温文尔雅', '脾气暴躁'];
  List<String> _tabTitles = ['作品', '集市'];
  List<Map<String, dynamic>> _countArray = [];
  List<dynamic> _videoList = [];
  List<MarketPostModel> _marketPostList = [];

  ScrollController _scrollController;
  ScrollController _marketScrollController;
  TabController _tabController;

  DragStartDetails _dragStartDetails;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

//    _currentVideoModel = context.read<PlayerStateModel>().currentVideoModel;
    _scrollController = new ScrollController();
    _marketScrollController = new ScrollController();
    _tabController = new TabController(length: _tabTitles.length, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.userId != null) {
      _currentUserId = widget.userId;
    } else {
      _currentVideoModel =
          context.read<PlayerStateProvider>().currentVideoModel;
      if (_currentVideoModel != null) {
        _currentUserId = _currentVideoModel.userid;
      } else {
        _currentUserId = widget.userId;
      }
    }

    _loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    _countArray.clear();
    _countArray.add({
      'title': '关注',
      'count':
          "${_currentUserModel.countMap != null ? _currentUserModel.countMap.careCount : 0}"
    });
    _countArray.add({
      'title': '粉丝',
      'count':
          "${_currentUserModel.countMap != null ? _currentUserModel.countMap.fansCount : 0}"
    });
   _countArray.add({'title': '集圈', 'count': "${_currentUserModel.countMap != null ? _currentUserModel.countMap.effectScore : 0}"});
   _countArray.add({'title': '诚信分', 'count': "${_currentUserModel.countMap != null ? _currentUserModel.countMap.honestyScore : 0}"});

    return Theme(
      data: ThemeData(
          primaryColor: widget.showMode == UserDetailShowMode.dark
              ? ColorConstants.backgroundColor33
              : Colors.white),
      child: Scaffold(
        backgroundColor: widget.showMode == UserDetailShowMode.dark
            ? ColorConstants.backgroundColor33
            : Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerScrolled) =>
              <Widget>[_buildSliverHeader(context)],
          body: _buildSliverBody(context),
        ),
      ),
    );
  }

  // 返回按钮
  Widget _buildBackButton() {
    return IconButton(
      icon: Image.asset(
          AssetsUtil.pathForAsset(
              AssetsUtil.assetsDirectoryCommon, 'nav_back.png'),
          color: widget.showMode == UserDetailShowMode.dark
              ? Colors.white
              : Colors.black87),
      onPressed: () {
        if (widget.userId != null) {
          Get.back();
        } else {
          g_eventBus.emit(GlobalEvent.videoPageEvent, 0);
        }
      },
    );
  }

  // 关注按钮
  Widget _buildAttentionButton() {
    return IconButton(
      icon: Image.asset(
          AssetsUtil.pathForAsset(
              AssetsUtil.assetsDirectoryPerson, "top_right_more.png"),
          color: widget.showMode == UserDetailShowMode.dark
              ? Colors.white
              : Colors.black87),
      onPressed: () {
        print("aaaaaaaaaaaaaaa");
      },
    );
  }

  // 头部信息
  Widget _buildHead(parentContext) {
    return SafeArea(
        child: Container(
      padding: EdgeInsets.only(top: 44),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildHeadName(),
          _buildHeadTags(),
          _buildHeadCounts(parentContext),
          _buildResumeVideoList()
        ],
      ),
    ));
  }

  // 名字和头像
  Widget _buildHeadName() {
    String companyAndJobString = "";
    if (_currentUserModel.companyName != null &&
        _currentUserModel.companyName != "") {
      companyAndJobString = _currentUserModel.companyName;
    }
    if (_currentUserModel.positionName != null &&
        _currentUserModel.positionName != "") {
      companyAndJobString =
          "$companyAndJobString·${_currentUserModel.positionName}";
    }

    return Container(
      height: 95,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(32.5),
            child:
//            Image.asset(AssetsUtil.pathForAsset(AssetsUtil.assetsDirectoryCommon, 'def_avatar.png'), width: 65, height: 65),
                Image.network(
                    _currentUserModel.headPortraitUrl ??
                        ImProvider.DEF_HEAD_IMAGE_URL,
                    fit: BoxFit.cover,
                    width: 65,
                    height: 65),
          ),
          SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_currentUserModel.name ?? "",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 48.sp,
                      fontWeight: FontWeight.bold)),
              companyAndJobString != ""
                  ? Text(companyAndJobString,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 24.sp),
                      strutStyle: StrutStyle(height: 1.5))
                  : SizedBox.shrink()
            ],
          ),
        ],
      ),
    );
  }

  // 标签列表
  Widget _buildHeadTags() {
    String tags = _currentUserModel.tags;

    if (tags != null && tags != "") {
      _tagNames = tags.split(",");

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Wrap(
          spacing: 15.w,
          runSpacing: 15.h,
          alignment: WrapAlignment.start,
          children: _tagNames.map((name) {
            return Container(
              padding: EdgeInsets.only(
                  top: 10.h, bottom: 10.h, left: 22.w, right: 22.w),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(75, 152, 244, 0.6),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(name,
                  style: TextStyle(
                      fontSize: 24.sp,
                      color: Color.fromRGBO(255, 255, 255, 0.9))),
            );
          }).toList(),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  // 各种数量
  Widget _buildHeadCounts(parentContext) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _countArray.map((json) {
                  return ButtonTheme(
                    minWidth: 0,
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Column(
                        children: <Widget>[
                          Text(json['count'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          Text(json['title'],
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12))
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              InkWell(
                child: Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                      color: _currentUserModel.isCared == 0
                          ? ColorConstants.themeColorBlue
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                      child: Text(
                          _currentUserModel.isCared == 0 ? "关注" : "取消关注",
                          style: TextStyle(fontSize: 12, color: Colors.white))),
                ),
                onTap: () {
                  AccountManager.instance.checkLogin().then((isLogin) {
                    if (isLogin) {
                      _addOrCancelCare(parentContext);
                    }
                  });
                },
              ),
              SizedBox(width: 10),
              widget.isCanGotoChat
                  ? InkWell(
                      child: Container(
                        width: 40,
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 0.5),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Image.asset(AssetsUtil.pathForAsset(
                                AssetsUtil.assetsDirectoryPerson,
                                "btn_chat.png"))),
                      ),
                      onTap: () {
                        AccountManager.instance.checkLogin().then((isLogin) {
                          if (isLogin) {
                            Get.to(ChatRoute(_currentUserModel.txUserid, {
                              'headPortraitUrl':
                                  _currentUserModel.headPortraitUrl,
                              'name': _currentUserModel.name,
                              'companyName': _currentUserModel.companyName
                            }));
                          }
                        });
                      },
                    )
                  : SizedBox.shrink()
            ],
          )
        ],
      ),
    );
  }

  Widget _buildResumeVideoList() {
    if (_videoList.length > 0) {
      return Container(
        height: 124,
        margin: EdgeInsets.only(top: 15),
        child: Column(
          children: <Widget>[
            Container(
              height: 44,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("简历视频",
                  style: TextStyle(
                      fontSize: 17,
                      color: widget.showMode == UserDetailShowMode.dark
                          ? Colors.white
                          : Colors.white)),
            ),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _videoList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String coverUrl = "";
                    String videoUrl = "";
                    if (_currentUserModel.type == 1) {
                      ResumeVideoModel videoModel = _videoList[index];
                      coverUrl = videoModel.coverUrl;
                      videoUrl = videoModel.worksUrl;
                    } else {
                      CompanyVideoModel videoModel = _videoList[index];
                      coverUrl = videoModel.coverUrl;
                      videoUrl = videoModel.worksUrl;
                    }

                    return InkWell(
                      child: Theme(
                        data: ThemeData(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: coverUrl ?? "",
                                    width: 124,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            Image.asset(AssetsUtil.pathForAsset(
                                AssetsUtil.assetsDirectoryCommon,
                                "icon_play_on_list.png"))
                          ],
                        ),
                      ),
                      onTap: () {
                        print(videoUrl);
                      },
                    );
                  }),
            )
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildSliverHeader(parentContext) {
    double height = 440;

    if (_currentUserModel.tags == null || _currentUserModel.tags == "") {
      height -= 40;
    }

    if (_videoList.length == 0) {
      height -= 140;
    }

    return SliverAppBar(
      pinned: true,
      expandedHeight: height,
      elevation: 0,
      leading: _buildBackButton(),
      actions: <Widget>[_buildAttentionButton()],
      flexibleSpace: FlexibleSpaceBar(
          background: Stack(
        children: <Widget>[
          widget.showMode == UserDetailShowMode.light
              ? Image.asset(
                  AssetsUtil.pathForAsset(AssetsUtil.assetsDirectoryPerson,
                      "bg_top_user_detail.png"),
                  width: double.infinity,
                  fit: BoxFit.cover)
              : SizedBox.shrink(),
          _buildHead(parentContext)
        ],
      )),
      bottom: PreferredSize(
        preferredSize: Size(double.infinity, 50),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Color.fromRGBO(238, 238, 238, 1), width: 0.5))),
          child: UnconstrainedBox(
            child: SizedBox(
              width: 160,
              height: 44,
              child: Theme(
                data: ThemeData(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding:
                      EdgeInsets.only(bottom: 3, left: 5, right: 5),
                  indicatorColor: ColorConstants.themeColorBlue,
                  indicatorWeight: 3,
                  unselectedLabelColor:
                      widget.showMode == UserDetailShowMode.dark
                          ? Color.fromRGBO(255, 255, 255, 0.6)
                          : ColorConstants.textColor51.withOpacity(0.6),
                  unselectedLabelStyle:
                      TextStyle(fontSize: 26.sp, fontWeight: FontWeight.normal),
                  labelColor: widget.showMode == UserDetailShowMode.dark
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : ColorConstants.textColor51,
                  labelStyle:
                      TextStyle(fontSize: 34.sp, fontWeight: FontWeight.bold),
                  tabs: _tabTitles.map((title) {
                    return Tab(text: title);
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverBody(parentContext) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          _dragStartDetails = notification.dragDetails;
        } else if (notification is OverscrollNotification) {
          CustomNotification(_dragStartDetails).dispatch(parentContext);
        }

        return true;
      },
      child: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ShortVideoListWidget(
              userId: _currentUserId, showMode: widget.showMode),
          // PlayerDetailShowreel(),
          MarketPostList(
            _marketPostList,
            "/market/getMarketList",
            {"queryType": 1},
            refreshByMine: true,
            controller: _marketScrollController,
            darkModel: (widget.showMode == UserDetailShowMode.dark),
          ),
        ],
      ),
    );
  }

  void _loadUserInfo() {
    var params = {"userid": _currentUserId};
    DioUtil.request("/user/getHomePageUser", parameters: params)
        .then((response) {
      print('response================= %%%%% $response');
      bool success = DioUtil.checkRequestResult(response, showToast: false);
      if (success) {
        setState(() {
          _currentUserModel = OtherUserModel.fromJson(response["data"]);
        });
      }
    });
  }

  // 添加或取消关注
  void _addOrCancelCare(parentContext) {
    if (_currentUserModel.isCared == 0) {
      // 未关注，调用添加关注接口
      var params = {"targetUserid": _currentUserId};
      BotToast.showLoading();
      DioUtil.request("/user/addUserCare", parameters: params).then((response) {
        bool success = DioUtil.checkRequestResult(response);
        if (success) {
          _loadUserInfo();
        }
      }).whenComplete(() => BotToast.closeAllLoading());
    } else {
      // 已关注，调用取消关注接口
      showDialog(
          context: parentContext,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("温馨提示"),
              content: Text("确定要取消关注吗？"),
              actions: <Widget>[
                FlatButton(
                  child: Text("确定"),
                  onPressed: () {
                    Get.back();

                    var params = {"targetUserid": _currentUserId};
                    BotToast.showLoading();
                    DioUtil.request("/user/cancelUserCare", parameters: params)
                        .then((response) {
                      bool success = DioUtil.checkRequestResult(response);
                      if (success) {
                        _loadUserInfo();
                      }
                    }).whenComplete(() => BotToast.closeAllLoading());
                  },
                ),
                FlatButton(
                  child: Text("取消"),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();

    super.dispose();
  }
}
