import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/app.dart';
import 'package:youpinapp/app/search.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/common/floating_button.dart';
import 'package:youpinapp/pages/home/home_choose_city.dart';
import 'package:youpinapp/pages/home/home_choose_parm.dart';
import 'package:youpinapp/pages/home/home_grid_company_0.dart';
import 'package:youpinapp/pages/home/home_grid_resume.dart';
import 'package:youpinapp/pages/home/search/tap_icon_search.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/event_bus.dart';

import '../../app/storage.dart';

class HomeGrid extends StatefulWidget {
  @override
  _HomeGridState createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> with TickerProviderStateMixin {
  TabController _tabController;
  TabController _navTabController;
  int _curListType = 0; // 0 作品 1 简历 2岗位 3 企宣

  List<dynamic> _categoryList = [
    {'index': -1, 'name': '全部'}
  ];
  List<String> _tabbarTitles = ['作品', '附近'];

  void _initData() async {
    AccountManager.instance.isLogin.then((isLogin) {
      print("isLogin = $isLogin");
      if (isLogin && g_accountManager.currentUser != null) {
        int typeId = g_accountManager.currentUser.typeId;
        //区分是否开启求职铃
        if (typeId == 1) {
          _tabbarTitles = ['企宣', '岗位', '附近'];
          _curListType = 2;
          _loadIndustryCategory();
        } else {
          _tabbarTitles = ['作品', '简历', '附近'];
          _curListType = 1;
          _loadIndustryCategory();
        }
      } else {
        _tabbarTitles = ['作品', '企宣', '附近'];
        _curListType = 3;
        // // 企业
        _loadJobCategory();
      }
      _navTabController = TabController(
          initialIndex: 1, length: _tabbarTitles.length, vsync: this);
      g_eventBus.on(GlobalEvent.accountInitialized, (arg) {
        _initData();
      });
      isLoading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();

    // if (g_accountManager.currentUser != null) {
    //
    // }
    _initData();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    SearchManager model = Provider.of<SearchManager>(context);

    if (isLoading) {
      return SizedBox.shrink();
    }
    return Scaffold(
      appBar: _buildAppBar(model),
      body: Column(
        children: <Widget>[
          _buildCategoryView(context, model),
          _buildGridView(model)
        ],
      ),
      floatingActionButton: FloatingButton.buildJobRingButton('HomeGrid'),
    );
  }

  // 导航栏
  Widget _buildAppBar(SearchManager model) {
    return PreferredSize(
        preferredSize: Size(double.infinity, 44),
        child: AppBar(
          elevation: 0,
          brightness: Brightness.dark,
          backgroundColor: ColorConstants.themeColorBlue,
          // leading: _buildAppBarLeading(),
          title: _buildAppBarTitle(model),
          centerTitle: true,
          actions: _buildAppBarActions(model),
        ));
  }

  // 导航栏左边的按钮
  Widget _buildAppBarLeading() {
    return IconButton(
      icon: Image.asset(
          join(AssetsUtil.assetsDirectoryHome, 'switch_youshi.png')),
      onPressed: () {
        App.instance.showMode = AppShowMode.player;
        g_eventBus.emit(GlobalEvent.mainFlipSwitch, false);
      },
    );
  }

  // 导航栏中间的tabbar
  Widget _buildAppBarTitle(SearchManager model) {
    return Container(
        width: 180,
        child: TabBar(
          controller: _navTabController,
          labelPadding: EdgeInsets.zero,
          labelStyle: TextStyle(
              fontSize: 34.sp, color: Color.fromRGBO(255, 255, 255, 1)),
          unselectedLabelStyle: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(255, 255, 255, 0.5)),
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.white,
          indicatorPadding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 8,
          ),
          tabs: _tabbarTitles.map((title) {
            return Tab(
              text: title,
              iconMargin: EdgeInsets.zero,
            );
          }).toList(),
          onTap: (index) {
            if (index == 0) {
              //企宣
              _curListType = 3;
              // 企业分类
              _loadIndustryCategory();
              // model.getCompanyShow(SearchParameters());
            } else if (index == 2) {
              //作品
              _curListType = 0;
              // model.getProjects();
              //职位分类
              _loadJobCategory();
            } else {
              //index=1 岗位 简历 企宣

              if (g_accountManager.currentUser == null) {
                //未登陆是企宣
                // model.getRefreshListCompany(params);
                _curListType = 3;
                // model.getCompanyShow(SearchParameters());

                // 企业分类
                _loadJobCategory();
              } else {
                if (g_accountManager.currentUser.typeId == 1) {
                  //个人请求岗位
                  _curListType = 2;

                  // 企业分类
                  _loadJobCategory();
                } else {
                  //企业请求简历
                  _curListType = 1;
                  // model.getRefreshListResume(SearchParameters());
                  // 个人
                  _loadIndustryCategory();
                }
              }
            }
            model.getRefresh(_curListType);
            //顶部状态栏点击 区分是否开启求职铃
            setState(() {});
            // 查询类型 0/不传 推荐查询 1.指定用户2.关注用户3.已赞作品(喜欢)5.附近作品(需要传经纬度)
//             int queryType = 0;
//             if (index == 0) {
//               queryType = 2;
//             } else if (index == 2) {
//               queryType = 5;
//             }
//
//             SearchParameters params = SearchParameters();
// //为登陆的修改
//             if (g_accountManager.currentUser == null) {
//               model.getRefreshListCompany(params);
//               return;
//             }
//             int accType = g_accountManager.currentUser.typeId;
//             params.queryType = queryType;
//             if (accType == 1) {
//               //个人
//               model.getRefreshListCompany(params);
//             } else if (accType == 2) {
//               //公司
//               model.getRefreshListResume(params);
//             }
          },
        ));
  }

  // 导航栏右边的按钮
  List _buildAppBarActions(SearchManager model) {
    return <Widget>[
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: IconButton(
          icon: Image.asset(
              join(AssetsUtil.assetsDirectoryCommon, 'icon_search.png')),
          onPressed: () {
            Get.to(TapIconSearch(model));
          },
        ),
      ),
    ];
  }

  // 行业岗位分类
  Widget _buildCategoryView(BuildContext context, SearchManager model) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _tabController != null
              ? TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicator: BoxDecoration(),
                  labelPadding: EdgeInsets.only(left: 40.w),
                  labelColor: Color.fromRGBO(51, 51, 51, 1),
                  labelStyle: TextStyle(
                      fontSize: 28.sp,
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontWeight: FontWeight.bold),
                  unselectedLabelColor: Color.fromRGBO(153, 153, 153, 1),
                  unselectedLabelStyle: TextStyle(
                      fontSize: 28.sp,
                      color: Color.fromRGBO(153, 153, 153, 1),
                      fontWeight: FontWeight.w500),
//            onTap: _tapCategory,
                  //点击tabbar对应item逻辑更改
                  onTap: (index) {
                    // int typeId = g_accountManager.currentUser.typeId;
                    SearchParameters param = SearchParameters();
                    param.industryNo = index;

                    if (_curListType == 0) {
                      model.getProjects(param);
                    } else if (_curListType == 1) {
                      model.getRefreshListResume(param);
                    } else if (_curListType == 2) {
                      model.getRefreshListCompany(param);
                    } else {
                      model.getCompanyShow(param);
                    }

//                     if (typeId == 1) {
//                       //个人身份
// //                Provider.of<SearchManager>(context,listen: false).getRefreshListCompany(param);
//                       model.getRefreshListCompany(param);
//                     } else if (typeId == 2) {
//                       //公司身份
// //                Provider.of<SearchManager>(context,listen: false).getRefreshListResume(param);
//                       model.getRefreshListResume(param);
//                     }
                  },

                  tabs: _categoryList.map((categoryJson) {
                    return Tab(text: categoryJson['name']);
                  }).toList(),
                )
              : SizedBox.shrink(),
        ),
        ButtonTheme(
          minWidth: 0,
          child: FlatButton(
            padding: EdgeInsets.only(left: 20.w, right: 10.w),
            child: Row(
              children: <Widget>[
                Text('筛选',
                    style: TextStyle(
                        fontSize: 26.sp,
                        color: Color.fromRGBO(153, 153, 153, 1))),
                SizedBox(width: 10.w),
                Image.asset(
                    join(AssetsUtil.assetsDirectoryHome, 'home_arrow.png'))
              ],
            ),
            onPressed: () {
              ///点击筛选HomeChooseParm
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return HomeChooseParm(model);
              }));
            },
          ),
        ),
        ButtonTheme(
          minWidth: 0,
          child: FlatButton(
            padding: EdgeInsets.only(left: 20.w),
            child: Row(
              children: <Widget>[
                Text(model.nowCity,
                    style: TextStyle(
                        fontSize: 26.sp,
                        color: Color.fromRGBO(153, 153, 153, 1))),
                SizedBox(width: 10.w),
                Image.asset(
                    join(AssetsUtil.assetsDirectoryHome, 'home_arrow.png'))
              ],
            ),
            onPressed: () {
              //设置为true，选完城市直接重绘
              model.couldFlash = true;
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return HomeChooseCity(model);
              }));
            },
          ),
        ),
        SizedBox(width: 20)
        // ButtonTheme(
        //   minWidth: 0,
        //   child: FlatButton(
        //     padding: EdgeInsets.only(right: 15.w),
        //     child: Image.asset(join(AssetsUtil.assetsDirectoryHome, 'home_add.png')),
        //   ),
        // )
      ],
    );
  }

  // 列表
  Widget _buildGridView(SearchManager model) {
    //绘制当前列表 根据tab和用户身份
    print('_curListType============= $_curListType');
    if (_curListType == 0) {
      return Expanded(
//          child: HomeGridCompany(_currentCategoryMap)
          child: HomeGridResume(model, _curListType));
    } else if (_curListType == 1) {
      return Expanded(
//          child: HomeGridCompany(_currentCategoryMap)
          child: HomeGridResume(model, _curListType));
    } else if (_curListType == 2) {
      // 公司账户
      return Expanded(child: HomeGridResume(model, _curListType));
    } else {
      return Expanded(
//          child: HomeGridCompany(_currentCategoryMap)
          child: HomeGridCompanyNew(model));
    }

//     if (AccountManager.instance.currentUser != null) {
//       if (g_accountManager.currentUser == null) {
//         return Expanded(child: HomeGridResume(model));
//       }
//       int typeId = g_accountManager.currentUser.typeId;
//       if (typeId == 1) {
//         // 个人账户
//         return Expanded(
// //          child: HomeGridCompany(_currentCategoryMap)
//             child: HomeGridCompanyNew(model));
//       } else if (typeId == 2) {
//         // 公司账户
//         return Expanded(child: HomeGridResume(model));
//       } else {
//         return SizedBox.shrink();
//       }
//     }
//
//     return SizedBox.shrink();
  }

  // 行业分类
  void _loadIndustryCategory() async {
    DioUtil.request('/resource/getHotIndustryList', method: 'GET')
        .then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData);
      if (success) {
        setState(() {
          _categoryList.clear();
          _categoryList.addAll(responseData['data']);
          _tabController =
              TabController(length: _categoryList.length, vsync: this);
        });
      }
    });
  }

  // 岗位分类
  void _loadJobCategory() async {
    DioUtil.request('/resource/getHotPositionList', method: 'GET')
        .then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData);
      if (success) {
        setState(() {
          _categoryList.clear();
          _categoryList.addAll(responseData['data']);
          _tabController =
              TabController(length: _categoryList.length, vsync: this);
        });
      }
    });
  }
}
