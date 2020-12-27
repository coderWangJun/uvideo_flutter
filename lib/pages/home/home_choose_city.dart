import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/search.dart';
import 'package:youpinapp/provider/tap_icon_search_provider.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/provider/city_choose.dart';
import 'package:youpinapp/app/storage.dart';
import 'package:flutter_bmflocation/bdmap_location_flutter_plugin.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_android_option.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_ios_option.dart';
class HomeChooseCity extends StatefulWidget{

  SearchManager searchModel;

  TapIconSearchProvider tapIconSearchProvider;

  bool mFlag = true;

  ///可传入当前定位
  HomeChooseCity(SearchManager searchModel,{TapIconSearchProvider provider,bool mFlags = true}){
    this.searchModel = searchModel;
    mFlag = mFlags;
    if(provider!=null){
      this.tapIconSearchProvider = provider;
    }
  }

  @override
  State createState() {
    return HomeChooseCityImpl();
  }
}
class HomeChooseCityImpl extends State<HomeChooseCity>{

  ///全局保存context
  BuildContext _context;

  ///保存一级城市，防止多次点击同样的一级城市发送冗余的请求，默认选中常用项
  String _checkCity="常用";
  var city = '定位中...';
  Widget _secondfrag;
  Widget _leftList = SizedBox.shrink();
  Widget _publicCity;
  Widget _hotCity = SizedBox.shrink();

  cityFontWeight _fontWeight = cityFontWeight();
  LocationFlutterPlugin _locationPlugin = new LocationFlutterPlugin();
  StreamSubscription<Map<String, Object>> _locationListener;
  @override
  void initState() {
    super.initState();
    _getListCityHotDoor();
    _getListCityFirstCity();
    getCity();
  }

  @override
  Widget build(BuildContext context) {

    _context = context;

    ///默认常用城市碎片
    _publicCity = Container(
      height: MediaQuery.of(_context).size.height-44.0,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height:32.0,child:
              Text("当前定位",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500,color: Color.fromRGBO(51, 51, 51, 1)),),
                ),
              Container(
                constraints: BoxConstraints(minWidth: 73),
                height: 32.5,
                decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(210, 210, 210, 1),width: 0.5)
                ),
                child: InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                    Image.asset(join(AssetsUtil.assetsDirectoryHome,"coordinate.png")),
                    Text(city,style: TextStyle(color: Color.fromRGBO(79, 154, 247, 1),fontSize: 13.0),textAlign: TextAlign.center,),
                  ],),
                  onTap: (){
                    ///点击当前定位的城市
                    widget.searchModel.nowCity=city;
                    g_storageManager.setStorage(StorageManager.MY_CITY_NAME,city);
                    Navigator.of(_context)..pop();
                  },
                ),
              ),

              SizedBox(height: 20,),
              SizedBox(height: 32,child:
                Text("热门城市",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500,color: Color.fromRGBO(51, 51, 51, 1)),),
              ),
              _hotCity,
          ],
        ),
      ),
    );

    return
      ChangeNotifierProvider(create: (context)=>_fontWeight,
      child:
      Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 44.0),
              child: _MyAppBar(),
            ),
            body: _MyBody(),
        )
    );
  }

  ///显示二级选项的城市的模板框框，先禁用城市筛选，
  Widget _getItem(String city,num cityId){
//    Widget _getItem(String city){
      return
        Container(
            constraints: BoxConstraints(
              minWidth: 73.0,),
            height: 32.5,
            margin: EdgeInsets.only(right: 11.0,bottom: 14.0),
            decoration: BoxDecoration(
                border: Border.all(color: Color.fromRGBO(210, 210, 210, 1),width: 0.5)
            ),
            child:Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.spaceEvenly,mainAxisSize: MainAxisSize.min,children: <Widget>[
              InkWell(
                child: Text(city,style: TextStyle(color: Color.fromRGBO(102, 102, 102, 1)),textAlign: TextAlign.center ,),
                onTap: (){
                  widget.searchModel.nowCity = city;
                  widget.searchModel.nowCityId = cityId;
                  if(widget.mFlag){
                    if(widget.searchModel.couldFlash){
                      int typeId = g_accountManager.currentUser.typeId;
                      if(typeId == 1){
                        widget.searchModel.getRefreshListCompany(SearchParameters());
                      }else if(typeId == 2){
                        widget.searchModel.getRefreshListResume(SearchParameters());
                      }
                    }else{
                      widget.tapIconSearchProvider.changeCity(city);
                    }
                  }
                  ///点击了就回去，往回传值
                  g_storageManager.setStorage(StorageManager.MY_CITY_NAME, city);
                  Navigator.of(_context)..pop(true);
                },
              )
            ])
        );
    }

    Widget _MyAppBar(){
      return AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        leading: IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon,"nav_back_black.png")),onPressed: (){
          ///back返回上一步
          Navigator.of(_context)..pop();
        },),
        title: Text(widget.mFlag?"切换城市":"选择城市",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
              color: Color.fromRGBO(51, 51, 51, 1)),
        ),
        centerTitle: true,
        elevation: 0,

      );
    }

    ///Body部分
    Widget _MyBody(){
      return Container(
//      width: MediaQuery.of(_context).size.width,
//      height: MediaQuery.of(_context).size.height-44.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 85.0,
              color: Color.fromRGBO(247, 247, 247, 1),
              child:
              ///一级城市列表
              _leftList,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: _secondfrag==null ? _publicCity : _secondfrag,
              ),
            )
          ],
        ),
      );
    }

    ///获取热门城市
    _getListCityHotDoor() async{
//    List<String> citylist = ["北京","上海","深圳","广州","重庆","成都","石家庄","什么地方什么地方"];
      DioUtil.request("/resource/getHotCitiesList",method: 'GET').then((value){
        if(DioUtil.checkRequestResult(value,showToast: false)){
          List li = value["data"];
          List list = li.map((e){
            return _getItem(e["name"] as String,e["id"] as num);
          }).toList();

          setState(() {
            this._hotCity = Wrap(children:list);
          });
        }});
    }


    ///获取一级位置
    _getListCityFirstCity() async{

      DioUtil.request("/resource/getSubregion",parameters: {"id":"100000"}).then((value){
        if(DioUtil.checkRequestResult(value,showToast: false)){
          List li = value["data"];

//       List list = li.map((e){
//         return _getLeftItemCity(e["sname"] as String);
//       }).toList();

          ///这样子遍历在最前面加个常用
          List<Widget> list = new List();
          list.add(_getLeftItemCity("常用",0,0));
          for(int i = 0;i<li.length;i++){
            _fontWeight.add();
            list.add(_getLeftItemCity((li[i]["sname"] as String),(li[i]["id"] as num),i+1));
          }


          setState(() {
            _leftList = ListView(children:list);
          });
        }});
    }

    ///左边一级城市的框框模板--->city：城市名字，cityId：作为二级城市请求参数,index：表示第几个item位置
    ///  异步获取到城市列表后再model中动态添加变量个数，记录每一个的位置；点击事件为model传入index位置，非该index的组件全部不加粗，该index加粗-----ListView实现单选~
    Widget _getLeftItemCity(String city,num cityId,int index){
      return
        Consumer(builder: (BuildContext context,cityFontWeight fw,Widget child){
          return
            GestureDetector(
              child: SizedBox(height: 55.0,width:84.0,child:
              Container(alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20),
                child: Text(city,style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1),fontWeight:fw.list[index],fontSize: 15.0),)
                ,),
              ),
              onTap: (){
                if(this._checkCity!=city){
                  this._checkCity = city;
                  _fontWeight.change(index);
                  _chooseSecondCity(cityId);

                  print(this._checkCity);
                }
                //            this._city = value;
              }
              ,);

        },);
    }

    ///获取二级位置=====传入请求参数 cityId 获取二级城市数据
    _chooseSecondCity(num cityId){

      ///点了个常用
      if(cityId==0){
        setState(() {
          _secondfrag = _publicCity;
        });
        return;
      }

      DioUtil.request("/resource/getSubregion",parameters: {"id": cityId }).then((value){
        if(DioUtil.checkRequestResult(value,showToast: false)){
          List list = value["data"];

          List<Widget> mlist = list.map((e){
            //两个接口的后台数据类型对不上，先禁用城市筛选条件
            return _getItem(e["sname"] as String,e["id"] as num);
          }).toList();
          setState(() {
            _secondfrag = Container(width:MediaQuery.of(_context).size.width-85,height: MediaQuery.of(_context).size.height-50,padding: EdgeInsets.all(15.0),child:Wrap(children: mlist,));

          });
        }});
    }
  ///获取默认城市
  void getCity(){
    /// 动态申请定位权限
    _locationPlugin.requestPermission();
    _locationListener = _locationPlugin.onResultCallback().listen((Map<String, Object> result) {
      setState(() {
        try {
          BaiduLocation _baiduLocation = BaiduLocation.fromMap(result);
          city = _baiduLocation.city.split('市')[0];
        } catch (e) {}
      });
    });
    if (null != _locationPlugin) {
      BaiduLocationAndroidOption androidOption = new BaiduLocationAndroidOption();
      androidOption.setCoorType("bd09ll"); // 设置返回的位置坐标系类型
      androidOption.setIsNeedAltitude(true); // 设置是否需要返回海拔高度信息
      androidOption.setIsNeedAddres(true); // 设置是否需要返回地址信息
      androidOption.setIsNeedLocationPoiList(true); // 设置是否需要返回周边poi信息
      androidOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
      androidOption.setIsNeedLocationDescribe(true); // 设置是否需要返回位置描述
      androidOption.setOpenGps(true); // 设置是否需要使用gps
      androidOption.setLocationMode(LocationMode.Hight_Accuracy); // 设置定位模式
      androidOption.setLocationPurpose(BDLocationPurpose.SignIn);//定位1次
      androidOption.setScanspan(1000); // 设置发起定位请求时间间隔
      Map androidMap = androidOption.getMap();

      /// ios 端设置定位参数
      BaiduLocationIOSOption iosOption = new BaiduLocationIOSOption();
      iosOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
      iosOption.setBMKLocationCoordinateType("BMKLocationCoordinateTypeBMK09LL"); // 设置返回的位置坐标系类型
      iosOption.setActivityType("CLActivityTypeAutomotiveNavigation"); // 设置应用位置类型
      iosOption.setLocationTimeout(10); // 设置位置获取超时时间
      iosOption.setDesiredAccuracy("kCLLocationAccuracyBest"); // 设置预期精度参数
      iosOption.setReGeocodeTimeout(10); // 设置获取地址信息超时时间
      iosOption.setDistanceFilter(100); // 设置定位最小更新距离
      iosOption.setAllowsBackgroundLocationUpdates(true); // 是否允许后台定位
      iosOption.setPauseLocUpdateAutomatically(true); //  定位是否会被系统自动暂停
      Map iosMap = iosOption.getMap();
      _locationPlugin.prepareLoc(androidMap, iosMap);
      _locationPlugin.startLocation();
    }
  }
}

