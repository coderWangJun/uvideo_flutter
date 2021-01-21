import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/app/storage.dart';
import 'package:youpinapp/app/web_socket.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/account_company_model.dart';
import 'package:youpinapp/models/account_model.dart';
import 'package:youpinapp/models/account_person_model.dart';
import 'package:youpinapp/models/home_resume_model.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/chat/chat_friends_list.dart';
import 'package:youpinapp/pages/company/setting/company_edit.dart';
import 'package:youpinapp/pages/home/home_video_widget.dart';
import 'package:youpinapp/pages/market/market_index.dart';
import 'package:youpinapp/pages/market/market_post_list.dart';
import 'package:youpinapp/pages/mine/company_job_manage.dart';
import 'package:youpinapp/pages/mine/company_video_manage.dart';
import 'package:youpinapp/pages/mine/my_balance_route.dart';
import 'package:youpinapp/pages/mine/resume_video_manage.dart';
import 'package:youpinapp/pages/person/person_basic_edit.dart';
import 'package:youpinapp/pages/person/short_video_list_widget.dart';
import 'package:youpinapp/pages/publish/publish_company_video.dart';
import 'package:youpinapp/pages/publish/publish_resume_video.dart';
import 'package:youpinapp/pages/setting/setting_index.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/widgets/custom_notification.dart';
import 'package:youpinapp/widgets/single_video_player.dart';

import 'my_deliver_list.dart';

class MineIndex extends StatefulWidget {
  @override
  _MineIndexState createState() => _MineIndexState();
}

class _MineIndexState extends State<MineIndex>
    with SingleTickerProviderStateMixin {
  bool _hasVideo = true;
  List<String> _tabBarTitles = ['作品', '集市'];

  String _name = "";
  String _job = "";

  String _headImgUrl = "";
  MyStatisticModel _statisticModel = new MyStatisticModel();
  List<ShowreelModel> _shortVideoList = [];
  List<CompanyVideoModel> _companyVideoList = [];
  List<HomeResumeModel> _resumeVideoList = [];

  ScrollController _scrollController;
  TabController _tabController;

  WebSocketProvide webSocketProvide;

  List<MarketPostModel> postModel = [];

  _MineIndexState() {
    _scrollController = ScrollController();
    _tabController = TabController(length: _tabBarTitles.length, vsync: this);
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
    g_accountManager.refreshRemoteUser().then((value) {
      setState(() {});
    });
//    g_accountManager.refreshRemoteUser();
  }

  @override
  Widget build(BuildContext context) {
    webSocketProvide = Provider.of<WebSocketProvide>(context);
    return Scaffold(
        appBar: _buildAppBar(),
        body: NotificationListener<CustomNotification>(
          onNotification: (notification) {
            if (notification.userInfo != null) {
              _shortVideoList = notification.userInfo;
              Future.delayed(Duration(milliseconds: 300)).then((value) {
                // TODO: 这里先注释掉，因为离开页面的时候回执行一次，就报错了，有空了再来分析
//              _checkVideoState();
              });
            }

            return true;
          },
          child: Stack(
            children: <Widget>[
              NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      elevation: 0,
                      pinned: true,
                      floating: true,
                      expandedHeight: (g_accountManager.currentUser.typeId == 1)
                          ? 410
                          : 480,
                      backgroundColor: Colors.white,
                      leading: SizedBox.shrink(),
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        background: Container(
                          height: double.infinity,
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  _buildNameAndHeader(context),
                                  _buildCountRow(context)
                                ],
                              ),
                              _buildOnlineJobRow(),
                              _buildMyVideoList()
                            ],
                          ),
                        ),
                      ),
                      bottom: _buildTabBar(),
                    )
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
//                  MineShortVideoList(),
                    ShortVideoListWidget(),
//                  MineMarketList()
                    MarketPostList(
                      postModel,
                      "/market/getMarketList",
                      {"queryType": 1},
                      refreshByMine: true,
                      controller: _scrollController,
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: (ScreenUtil.mediaQueryData.size.width - 168) / 2 + 11,
                  child: _hasVideo
                      ? SizedBox.shrink()
                      : Image.asset("assets/gif/publish.gif",
                          width: 168, height: 104)),
            ],
          ),
        ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshData();
  }

  void _refreshData() {
    AccountModel accountModel = g_accountManager.currentUser;
    int typeId = 1;
    if (accountModel != null) {
      typeId = accountModel.typeId; // 1 个人；2 企业
    }
    if (typeId == 1) {
      AccountPersonModel personModel = accountModel.userData;
      _name = personModel.realname ?? personModel.phonenumber;
      _headImgUrl =
          personModel.headPortraitUrl ?? ImProvider.DEF_HEAD_IMAGE_URL;
      // 加载我的简历视频
      _loadMyResumeVideos();
    } else if (typeId == 2) {
      AccountCompanyModel companyModel = accountModel.companyData;
      _name = companyModel.companyName ?? companyModel.phonenumber;
      _headImgUrl = companyModel.logoUrl ?? ImProvider.DEF_HEAD_IMAGE_URL;
      // 加载公司的招聘视频
      _loadCompanyVideos();
    }

    _loadStatistic();
  }

  // 检查视频数量，如果为0就显示中间的GIF
  void _checkVideoState() {
    if (_shortVideoList.length > 0) {
      if (g_accountManager.currentUser.typeId == 1 &&
          _resumeVideoList.length > 0) {
        _hasVideo = true;
      } else if (g_accountManager.currentUser.typeId == 2 &&
          _companyVideoList.length > 0) {
        _hasVideo = true;
      } else {
        _hasVideo = false;
      }
    } else {
      _hasVideo = false;
    }

    setState(() {});
  }

  Widget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            child: Row(
              children: <Widget>[
                Image.asset(imagePath("mine", "bell_switch.png")),
                SizedBox(width: 10),
                Container(
                  width: 62,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1)),
                  child: Text(
                      AccountManager.instance.ringSwitch ? "关闭求职铃" : "开启求职铃",
                      style: TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
            onTap: () async {
              AccountManager.instance.ringSwitch =
                  !AccountManager.instance.ringSwitch;
              g_storageManager.setStorage(StorageManager.RTC_SWITCH,
                  AccountManager.instance.ringSwitch);
              if (AccountManager.instance.ringSwitch) {
                if (await Permission.locationWhenInUse.request().isGranted &&
                    await Permission.location.request().isGranted) {
                  debugPrint("我是有权限的");
                }
                webSocketProvide.isOpen = true;
                webSocketProvide.init();
                BotToast.showText(text: "求职铃已打开");
              } else {
                webSocketProvide.isOpen = false;
                webSocketProvide.closes();
                BotToast.showText(text: "求职铃已关闭");
              }

              setState(() {});
            },
          ),
          Row(
            children: <Widget>[
//              InkWell(
//                child: Container(
//                  width: 32,
//                  height: 44,
//                  child: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_scan.png')),
//                ),
//                onTap: () {
//                  Get.to(SettingIndex());
//                },
//              ),

              InkWell(
                child: Container(
                  width: 32,
                  height: 44,
                  child: Image.asset(join(
                      AssetsUtil.assetsDirectoryCommon, 'icon_setting.png')),
                ),
                onTap: () {
                  Get.to(SettingIndex());
                },
              )
            ],
          )
        ],
      ),
    );
  }

  // 名称、头像，关注、粉丝、收藏、喜欢、影响力
  Widget _buildNameAndHeader(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 190,
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
        color: ColorConstants.themeColorBlue,
        child: Column(
          children: <Widget>[
            // 名称和头像
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(_name,
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(width: 5),
                          Text(_job,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),

                      /**
                       *    简历管理
                       *

                          ButtonTheme(
                          minWidth: 0,
                          height: 0,
                          child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                          Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_modify_white.png')),
                          SizedBox(width: 8),
                          Text(g_accountManager.currentUser.typeId == 1 ? "简历管理" : "企业管理", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500))
                          ],
                          ),
                          onPressed: () {
                          if (g_accountManager.currentUser.typeId == 1) {
                          print("开始简历管理");
                          } else {
                          print("开始企业管理");
                          }
                          },
                          ),
                          ),

                       **
                       *
                       */
                    ],
                  ),
                ),
                GestureDetector(
                  child:
//                Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'def_company_avatar.png')),
                      ClipOval(
                    child: Container(
                      width: 65.0,
                      height: 65.0,
                      child: Image.network(
                        _headImgUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    int typeId = g_accountManager.currentUser.typeId;
                    if (typeId == 1) {
                      Get.to(PersonBasicEdit()).then((value) {
                        if (value != null) {
                          g_accountManager.refreshRemoteUser().then((value) {
                            setState(() {
                              _refreshData();
                            });
                          });
                        }
                      });
                    } else if (typeId == 2) {
                      Get.to(CompanyEditAll()).then((value) {
                        g_accountManager.refreshRemoteUser().then((value) {
                          setState(() {
                            _refreshData();
                          });
                        });
                      });
                    }
                  },
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 0,
                  child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Get.to(ChatFriendsList());
                    },
                    child: Column(
                      children: <Widget>[
                        Text("${_statisticModel.careCount ?? 0}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                        Text('关注',
                            style: TextStyle(fontSize: 15, color: Colors.white))
                      ],
                    ),
                  ),
                ),
                ButtonTheme(
                  minWidth: 0,
                  child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Get.to(ChatFriendsList());
                    },
                    child: Column(
                      children: <Widget>[
                        Text('${_statisticModel.fansCount ?? 0}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                        Text('粉丝',
                            style: TextStyle(fontSize: 15, color: Colors.white))
                      ],
                    ),
                  ),
                ),
                ButtonTheme(
                  minWidth: 0,
                  child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return HomeVideoWidget();
                      }));
                    },
                    child: Column(
                      children: <Widget>[
                        Text('${_statisticModel.collectCount ?? 0}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                        Text('收藏',
                            style: TextStyle(fontSize: 15, color: Colors.white))
                      ],
                    ),
                  ),
                ),
                ButtonTheme(
                  minWidth: 0,
                  child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return HomeVideoWidget();
                      }));
                    },
                    child: Column(
                      children: <Widget>[
                        Text('${_statisticModel.likeCount ?? 0}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                        Text('喜欢',
                            style: TextStyle(fontSize: 15, color: Colors.white))
                      ],
                    ),
                  ),
                ),
                // ButtonTheme(
                //   minWidth: 0,
                //   child: FlatButton(
                //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //     padding: EdgeInsets.all(0),
                //     child: Column(
                //       children: <Widget>[
                //         Text('${_statisticModel.effectScore ?? 0}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                //         Text('影响力', style: TextStyle(fontSize: 15, color: Colors.white))
                //       ],
                //     ),
                //   ),
                // )
              ],
            )
          ],
        ));
  }

  // 投递、圈子、诚信分、我的资产
  Widget _buildCountRow(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.only(left: 15, right: 15),
      margin: EdgeInsets.only(top: 160, left: 22.5, right: 22.5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 2,
              offset: Offset(0, 2),
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ButtonTheme(
            minWidth: 0,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                Get.to(MyDeliverList());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('${_statisticModel.deliveryCount ?? 0}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.textColor51)),
                  Text('投递',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(101, 101, 101, 1))),
                ],
              ),
            ),
          ),
          ButtonTheme(
            minWidth: 0,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return MarketIndex();
                }));
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('${_statisticModel.circleCount ?? 0}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.textColor51)),
                  Text('圈子',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(101, 101, 101, 1))),
                ],
              ),
            ),
          ),
          ButtonTheme(
            minWidth: 0,
            child: FlatButton(
              onPressed: () => {},
              padding: EdgeInsets.all(0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('${_statisticModel.honestyScore ?? 0}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.textColor51)),
                  Text('诚信分数',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(101, 101, 101, 1))),
                ],
              ),
            ),
          ),
          ButtonTheme(
            minWidth: 0,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('${_statisticModel.assetsScore ?? 0}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.textColor51)),
                  Text('资产',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(101, 101, 101, 1))),
                ],
              ),
              onPressed: () {
                Get.to(MyBalanceRoute());
              },
            ),
          )
        ],
      ),
    );
  }

  // 在线职位
  Widget _buildOnlineJobRow() {
    return (g_accountManager.currentUser.typeId == 2)
        ? InkWell(
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 15, right: 15),
              margin: EdgeInsets.only(top: 20, left: 22.5, right: 22.5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 2,
                      offset: Offset(-0.5, -0.5),
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 2,
                      offset: Offset(1.5, 1.5),
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('${_statisticModel.onlineJobCount ?? 0}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: ColorConstants.textColor51)),
                      Text('个在线职位',
                          style: TextStyle(
                              fontSize: 13, color: ColorConstants.textColor51)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('管理职位',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: ColorConstants.textColor51)),
                      SizedBox(width: 5),
                      Image.asset(join(AssetsUtil.assetsDirectoryCommon,
                          'icon_forward_small.png'))
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {
              Get.to(CompanyJobManage());
            },
          )
        : SizedBox.shrink();
  }

  // 简历视频列表
  Widget _buildMyVideoList() {
    bool hasVideo = false;
    if (g_accountManager.currentUser.typeId == 1 &&
        _resumeVideoList.length > 0) {
      hasVideo = true;
    } else if (g_accountManager.currentUser.typeId == 2 &&
        _companyVideoList.length > 0) {
      hasVideo = true;
    }

    return Container(
      margin: EdgeInsets.only(top: 10),
      width: ScreenUtil.mediaQueryData.size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: Container(
              height: 44,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                      g_accountManager.currentUser.typeId == 1
                          ? "我的简历视频"
                          : "企业宣传片",
                      style: TextStyle(
                          fontSize: 17,
                          color: ColorConstants.textColor51,
                          fontWeight: FontWeight.w500)),
                  Image.asset(join(AssetsUtil.assetsDirectoryCommon,
                      'icon_forward_normal.png'))
                ],
              ),
            ),
            onTap: () {
              if (g_accountManager.currentUser.typeId == 1) {
                // 个人
                Get.to(ResumeVideoManage());
              } else {
                // 企业
                Get.to(CompanyVideoManage());
              }
            },
          ),
          hasVideo == false
              ? InkWell(
                  child: Container(
                    width: 72,
                    height: 80,
                    margin: EdgeInsets.only(left: 20),
                    child: Image.asset(
                        join(AssetsUtil.assetsDirectoryCommon,
                            "btn_add_video.png"),
                        fit: BoxFit.fill),
                  ),
                  onTap: () {
                    if (g_accountManager.currentUser.typeId == 1) {
                      Get.to(PublishResumeVideo());
                    } else if (g_accountManager.currentUser.typeId == 2) {
                      Get.to(PublishCompanyVideo());
                    }
                  },
                )
              : Container(
                  width: ScreenUtil.mediaQueryData.size.width,
                  height: 80,
                  padding: EdgeInsets.only(left: 20, right: 10),
                  child: ListView.builder(
                      itemCount: g_accountManager.currentUser.typeId == 1
                          ? _resumeVideoList.length
                          : _companyVideoList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        var coverUrl = "";
                        var videoUrl = "";

                        if (g_accountManager.currentUser.typeId == 1) {
                          HomeResumeModel resumeModel = _resumeVideoList[index];
                          coverUrl = resumeModel.coverUrl;
                          videoUrl = resumeModel.worksUrl;
                        } else {
                          CompanyVideoModel companyModel =
                              _companyVideoList[index];
                          coverUrl = companyModel.coverUrl;
                          videoUrl = companyModel.worksUrl;
                        }

                        return InkWell(
                          child: Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorConstants.dividerColor
                                              .withOpacity(0.5),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: CachedNetworkImage(
                                          imageUrl: coverUrl ?? "",
                                          width: 124,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  Image.asset(join(
                                      AssetsUtil.assetsDirectoryCommon,
                                      'icon_play_on_list.png'))
                                ],
                              )),
                          onTap: () {
                            Get.to(SingleVideoPlayer(videoUrl));
                          },
                        );
                      }),
                )
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return PreferredSize(
        preferredSize: Size(ScreenUtil.mediaQueryData.size.width, 50),
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Color.fromRGBO(237, 237, 237, 1), width: 1))),
          child: TabBar(
            controller: _tabController,
            labelPadding: EdgeInsets.only(left: 8, right: 8),
            isScrollable: true,
            labelColor: ColorConstants.textColor51,
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            unselectedLabelColor: Color.fromRGBO(0, 0, 0, 0.6),
            unselectedLabelStyle:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            indicatorColor: ColorConstants.themeColorBlue,
            tabs: _tabBarTitles.map((title) {
              return Tab(text: title);
            }).toList(),
          ),
        ));
  }

  void _loadStatistic() {
    DioUtil.request("/user/getHomePageUserData").then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: false);
      if (success) {
        var json = responseData["data"];

        setState(() {
          _statisticModel = MyStatisticModel.fromJson(json);
        });
      }
    });
  }

  // 加载招聘视频
  void _loadCompanyVideos() {
    var params = {"queryType": "1"};
    DioUtil.request("/company/getCompanyPromo", parameters: params)
        .then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: false);
      if (success) {
        _companyVideoList.clear();

        List<dynamic> dataList = responseData['data'];
        if (dataList != null && dataList.length > 0) {
          List<CompanyVideoModel> modelList = dataList.map((json) {
            return CompanyVideoModel.fromJson(json);
          }).toList();

          _companyVideoList.addAll(modelList);
        }
      }

      _checkVideoState();
    });
  }

  // 加载简历视频
  void _loadMyResumeVideos() {
    var params = {"queryType": 1};
    DioUtil.request('/resume/getMediaResume', parameters: params)
        .then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: false);
      if (success) {
        _resumeVideoList.clear();

        List<dynamic> dataList = responseData['data'];
        if (dataList != null && dataList.length > 0) {
          List<HomeResumeModel> modelList = dataList.map((json) {
            return HomeResumeModel.fromJson(json);
          }).toList();

          _resumeVideoList.addAll(modelList);
        }
      }

      _checkVideoState();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
