import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/app/app.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/chat/chat_index.dart';
import 'package:youpinapp/pages/home/home_grid.dart';
import 'package:youpinapp/pages/market/market_index.dart';
import 'package:youpinapp/pages/mine/mine_index.dart';
import 'package:youpinapp/pages/publish/publish_menu.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/event_bus.dart';

import '../../app/account.dart';
import '../login/login_route.dart';

class HomeListWidget extends StatefulWidget {
  @override
  _HomeListWidgetState createState() => _HomeListWidgetState();
}

class _HomeListWidgetState extends State<HomeListWidget> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  TabController _tabController;
  List<String> _bottomTitles = ['首页', '集市', '', '消息', '我的'];
  List<Widget> _pages = [
    HomeGrid(),
    MarketIndex(),
    SizedBox.shrink(),
    ChatIndex(),
    MineIndex()
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: _bottomTitles.length);

    g_eventBus.on(EventBus.mainTabBarChange, (index) {
      print('index========== $index');
      _currentIndex = index;
      _tabController.animateTo(index);
      setState(() { });
    });

  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController.index = context.read<AppProvider>().bottomTabBarIndex;
  }

  @override
  Widget build(BuildContext context) {
    ImProvider imProvider = Provider.of<ImProvider>(context);
    int indexFlag = -1;
    return Scaffold(
      body: _pages[context.watch<AppProvider>().bottomTabBarIndex],
      bottomNavigationBar: Container(
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Color.fromRGBO(239, 239, 239, 1))),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(),
            unselectedLabelColor: ColorConstants.textColor51,
            unselectedLabelStyle: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.normal),
            labelColor: ColorConstants.themeColorBlue,
            labelStyle: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
            tabs: _bottomTitles.map((title) {
              if (title == '') {
                return Tab(icon: Image.asset(imagePath("home", "tb_publish.png")));
              } else {
              indexFlag++;
              int num = imProvider.countRedIcon[indexFlag]?? 0;
                return Tab(child: Stack(
                  children: <Widget>[
                    Center(child:Text(title)),
                    Visibility(visible:num>0?true:false,child: Align(alignment: Alignment.topRight,child:Container(
                        margin: EdgeInsets.only(top: 8.0),
                        width: 15,height: 15,decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.red,
                    ),child: Center(child:Text("$num",style: TextStyle(color:Colors.white,fontSize: 10.0),),)
                    )),)
                  ],
                ),);
              }
            }).toList(),
            onTap: (index) {
              if(g_accountManager.currentUser==null){
                Get.offAll(LoginRoute());
                return;
              }
              if (index == 2) {
//                Get.to(PublishMenu());
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
              } else {
                context.read<AppProvider>().bottomTabBarIndex = index;
              }
            },
          ),
        )
      )
    );
  }

  void _tapItem(index) {
    if (index != 2) {
      setState(() {
        _currentIndex = index;
      });
    } else {
      print('点击发布按钮');
    }
  }
}