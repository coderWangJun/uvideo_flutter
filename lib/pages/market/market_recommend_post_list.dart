import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:get/route_manager.dart';
import 'package:youpinapp/app/search.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/common/location_button.dart';
import 'package:youpinapp/pages/common/sort_widget.dart';
import 'package:youpinapp/pages/home/home_choose_city.dart';
import 'package:youpinapp/pages/market/market_post_list.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/event_bus.dart';

class MarketRecommendPostList extends StatefulWidget {
  @override
  _MarketRecommendPostListState createState() => _MarketRecommendPostListState();
}

class _MarketRecommendPostListState extends State<MarketRecommendPostList> with TickerProviderStateMixin {
  List<String> _tabTitles = ['全部'];
  Map<String,num> _tabTitlesId = {};
  TabController _tabController;

  MarketPostListProvider marketModel = new MarketPostListProvider();

  Map params = {'marketTypeId': 1};
  String cityName = '区域';


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
    //tabBar的数据拉取------>
    DioUtil.request("/resource/getMarketCircle",method: 'GET').then((value){
      if(DioUtil.checkRequestResult(value)){if(value['data']!=null){
        setState(() {
          List<String> mList = (value['data'] as List).map((element) {
            _tabTitlesId[element['circleName'] as String] = element['id'] as num;
            return element['circleName'] as String;
          }).toList();
          _tabController = TabController(length: mList.length, vsync: this);
          _tabTitles = mList;
        });
      }}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildSearch(),
          _buildTabBar(),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 20),
              child: MarketPostList([],"/market/getMarketList",params,refreshByMine:true,marketPostListProvider: marketModel,scrollerFlag: true,)
            )
          )
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      height: 44,
      padding: EdgeInsets.only(left: 20, right: 20, top: 14),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(238, 238, 238, 0.5),
          borderRadius: BorderRadius.circular(15)
        ),
        child: TextField(
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Color.fromRGBO(1, 1, 1, 0.5)),
          decoration: InputDecoration(
            border: InputBorder.none
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 25,
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            behavior:HitTestBehavior.opaque,
            child:SortWidget(['U币'], textColor: ColorConstants.textColor51),
            onTap: (){
              setState(() {
                params['current'] = 1;
                params['size'] = MarketPostListProvider.sizeNum;
                  if(params['ucoinAmountOrder']==null){
                      params['ucoinAmountOrder']=1;
                  }else{
                    if(params['ucoinAmountOrder']==1){params['ucoinAmountOrder']=-1;}
                    else{params['ucoinAmountOrder']=1;}
                  }
                marketModel.getRefresh("/market/getMarketList", params);
              });
            },
          ),
          GestureDetector(behavior: HitTestBehavior.opaque,child:LocationButton(textColor: ColorConstants.textColor51,locationName: cityName,),
            onTap: (){
              SearchManager sea = SearchManager();
              Get.to(HomeChooseCity(sea,mFlags: false,)).then((value){
                setState(() {
                  params['current'] = 1;
                  params['size'] = MarketPostListProvider.sizeNum;
                  cityName = sea.nowCity;
                  params['cityName']=cityName;
                  marketModel.getRefresh("/market/getMarketList", params);
                });
              });
            },
          ),
          Expanded(
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelPadding: EdgeInsets.only(right: 20),
              labelColor: ColorConstants.textColor51,
              labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              unselectedLabelColor: ColorConstants.textColor153,
              unselectedLabelStyle: TextStyle(fontSize: 15),
              indicator: BoxDecoration(),
              tabs: _tabTitles.map((title) {
                return Tab(text: title);
              }).toList(),
              onTap: (a){
                setState(() {
                  params['current'] = 1;
                  params['size'] = MarketPostListProvider.sizeNum;
                  params['marketCircleId'] = _tabTitlesId[_tabTitles[a]];
                  marketModel.getRefresh("/market/getMarketList", params);
                });
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if(mounted){
      super.setState(fn);
    }
  }


}