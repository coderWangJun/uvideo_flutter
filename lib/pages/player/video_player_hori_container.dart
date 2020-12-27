import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/app.dart';
import 'package:youpinapp/app/storage.dart';
import 'package:youpinapp/models/home_resume_model.dart';
import 'package:youpinapp/pages/common/custom_notification.dart';
import 'package:youpinapp/pages/common/floating_button.dart';
import 'package:youpinapp/pages/person/user_detail_route.dart';
import 'package:youpinapp/pages/player/nearby_video_list.dart';
import 'package:youpinapp/pages/player/player_state_provider.dart';
import 'package:youpinapp/pages/player/video_player_vert_container.dart';
import 'package:youpinapp/pages/publish/publish_menu.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/event_bus.dart';

// 字体颜色白色
/// System overlays should be drawn with a light color. Intended for
/// applications with a dark background.
const SystemUiOverlayStyle light = SystemUiOverlayStyle(
  systemNavigationBarColor: Color(0xFF000000),
  systemNavigationBarDividerColor: null,
  statusBarColor: null,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);

// 字体颜色黑色
/// System overlays should be drawn with a dark color. Intended for
/// applications with a light background.
const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
  systemNavigationBarColor: Color(0xFF000000),
  systemNavigationBarDividerColor: null,
  statusBarColor: null,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);

class VideoPlayerHoriContainer extends StatefulWidget {
  final VideoPlayType playType;
  final HomeResumeModel currentResumeModel;

  VideoPlayerHoriContainer(this.playType, {this.currentResumeModel});

  @override
  _VideoPlayerHoriContainerState createState() => _VideoPlayerHoriContainerState();
}

class _VideoPlayerHoriContainerState extends State<VideoPlayerHoriContainer> with TickerProviderStateMixin {
  int _topSelectedIndex = 1;
  int _bottomSelectedIndex = 0;
  PlayerStateProvider _playerStateProvider = new PlayerStateProvider();

  PageController _pageController;
  TabController _topTabController;
  TabController _bottomTabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _playerStateProvider.playType = widget.playType;
    _playerStateProvider.currentResumeModel = widget.currentResumeModel;

    _pageController = new PageController(keepPage: false);
    _topTabController = TabController(length: 3, initialIndex: 1, vsync: this);
    _bottomTabController = TabController(length: 5, vsync: this);

    g_eventBus.on(GlobalEvent.videoPageEvent, (pageIndex) {
      _pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    });

    _pageController.addListener(() {
      // 翻到第二页的时候停止播放
      if (_pageController.page == 1) {
        g_eventBus.emit(GlobalEvent.stopPlayEvent);
      }
    });

    // 点击左上角切换按钮事件
    g_eventBus.on(GlobalEvent.mainFlipSwitch, (reverse) {
      setState(() { });
    });
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
      )),
      body: ChangeNotifierProvider.value(
        value: _playerStateProvider,
        child: PageView(
          controller: _pageController,
          children: widget.currentResumeModel == null ? <Widget>[
            _buildPlayerPage(context),
          ] : <Widget>[
            _buildPlayerPage(context),
            _buildDetailWidgets(),
          ],
        ),
      ),
      // floatingActionButton: FloatingButton.buildJobRingButton('HomeVideo', margin: EdgeInsets.only(bottom: 80, right: 10))
    );
  }

  Widget _buildPlayerPage(parentContext) {
    return Stack(
      children: <Widget>[
        _topSelectedIndex == 2 ? NearbyVideoList() : VideoPlayerVertContainer(),
        _buildTopAppBar(),
        // _buildBottomTabBar(parentContext)
      ],
    );
  }
  
  Widget _buildTopAppBar() {
    String switchIconName = "switch_youqi.png";
    if (AccountManager.instance.currentUser != null && AccountManager.instance.currentUser.typeId ==2) {
      switchIconName = "switch_youcai.png";
    }

    return Positioned(
      top: 0,
      left: 5,
      width: ScreenUtil.mediaQueryData.size.width - 10,
      height: 60,
      child: SafeArea(
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          // leading: widget.playType == VideoPlayType.shortVideo ? InkWell(
          //   child: Image.asset(AssetsUtil.pathForAsset(AssetsUtil.assetsDirectoryHome, switchIconName)),
          //   onTap: () {
          //     _flipToHomeListRoute();
          //   },
          // ) : InkWell(
          //   child: Image.asset(imagePath("common", "nav_back.png")),
          //   onTap: () {
          //     Get.back();
          //   },
          // ),
          centerTitle: true,
          title: SizedBox(
            width: 180,
            child: TabBar(
              controller: _topTabController,
              labelPadding: EdgeInsets.all(0),
              indicatorWeight: 2,
              indicatorPadding: EdgeInsets.only(bottom: 6, left: 5, right: 5),
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Color.fromRGBO(254, 254, 254, 1),
              labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              unselectedLabelColor: Color.fromRGBO(255, 255, 255, 0.5),
              unselectedLabelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              tabs: <Widget>[
                Tab(text: "关注"),
                Tab(text: "推荐"),
                Tab(text: "附近"),
              ],
              onTap: (index) {
                if (index == 0 || index == 1) {
                  _playerStateProvider.currentVideoType = index;
                }

                setState(() {
                  _topSelectedIndex = index;
                });
              },
            ),
          ),
          actions: <Widget>[
            // InkWell(
            //   child: Icon(Icons.search, color: Colors.white),
            // )
          ],
        ),
      ),
    );
  }
  
  Widget _buildBottomTabBar(parentContext) {
    return widget.playType == VideoPlayType.shortVideo ? Positioned(
        bottom: 0,
        left: 0,
        width: ScreenUtil.mediaQueryData.size.width,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Color.fromRGBO(155, 155, 155, 0.3), width: 0.5))
            ),
            child: Theme(
              data: Theme.of(parentContext).copyWith( splashColor: Colors.transparent ),
              child: TabBar(
                controller: _bottomTabController,
                indicator: BoxDecoration(),
                labelColor: Colors.white,
                labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                unselectedLabelColor: Colors.white.withOpacity(0.78),
                unselectedLabelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                tabs: <Widget>[
                  Tab(text: "首页"),
                  Tab(text: "集市"),
                  Tab(icon: Image.asset(AssetsUtil.pathForAsset(AssetsUtil.assetsDirectoryHome, "tb_publish1.png"))),
                  Tab(text: "消息"),
                  Tab(text: "我的"),
                ],
                onTap: (index) {
                  App.instance.showMode = AppShowMode.list;
                  g_eventBus.emit(GlobalEvent.stopPlayEvent);

                  if (index != 2) {
                    context.read<AppProvider>().bottomTabBarIndex = index;
                    _flipToHomeListRoute();
                  } else {
                    AccountManager.instance.checkLogin().then((isLogin) {
                      if (isLogin) {
                        showGeneralDialog(
                          context: context,
                          barrierLabel: "",
                          barrierDismissible: true,
                          transitionDuration: Duration(milliseconds: 300),
                          pageBuilder: (BuildContext context, Animation animation,
                              Animation secondaryAnimation) {
                            return PublishMenu();
                          },
                        );
                      }
                    });
                  }
                },
              ),
            ),
          ),
        )
    ) : SizedBox.shrink();
  }

  Widget _buildDetailWidgets() {
    String userId;
    if (widget.playType == VideoPlayType.resumeVideo) {
      HomeResumeModel videoModel = widget.currentResumeModel;
      userId = videoModel.userid;
      print("传过来的用户ID传过来的用户ID:$videoModel");
    }

    return NotificationListener<CustomNotification>(
      onNotification: (notification) {
        _pageController.position.drag(notification.userInfo, () { });

        return false;
      },
      child: UserDetailRoute(userId: userId, showMode: UserDetailShowMode.dark),
    );
  }


  // 翻转到首页视频列表去
  void _flipToHomeListRoute() {
    g_eventBus.emit(GlobalEvent.stopPlayEvent);

    AccountManager.instance.checkLogin().then((isLogin) {
      if (isLogin) {
        g_eventBus.emit(GlobalEvent.mainFlipSwitch, true);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _topTabController.dispose();
    _bottomTabController.dispose();

    super.dispose();
  }
}