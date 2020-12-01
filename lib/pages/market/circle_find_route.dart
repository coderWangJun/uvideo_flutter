import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/market/circle_more/circle_detail.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/toast_util.dart';

class CircleFindRoute extends StatefulWidget {
  @override
  _CircleFindRouteState createState() => _CircleFindRouteState();
}

class _CircleFindRouteState extends State<CircleFindRoute> {
  int _currentIndex1 = -1;
  int _currentIndex2 = -1;
  int _currentIndex3 = -1;
  List<dynamic> _categoryList1 = [];
  List<IndustryModel> _categoryList2 = [];
  List<CircleModel> _categoryList3 = [];
  TextEditingController _textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategoryLevel1();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        child: Column(
          children: <Widget>[
            _buildSearchWidget(),
            Expanded(
              child: Row(
                children: <Widget>[
                  _buildCategoryLeve1(),
                  (_currentIndex1 == 4) ? _buildCategoryLeve2() : SizedBox.shrink(),
                  Expanded(
                    child: _buildCategoryLeve3(context),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // AppBar
  Widget _buildAppBar(context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'nav_back.png')),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      centerTitle: true,
      title: Text('圈子'),
    );
  }

  // 搜索框 FractionallySizedBox
  Widget _buildSearchWidget() {
    return Container(
      //height: 50,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 238, 238, 0.5),
                borderRadius: BorderRadius.circular(25)
              ),
              child: TextField(
                controller: _textEditingController,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5),
                  border: InputBorder.none,
                  isDense: true,
                  hintText: '集圈搜索',
                  hintStyle: TextStyle(fontSize: 30.sp, textBaseline: TextBaseline.alphabetic, color: Color.fromRGBO(1, 1, 1, 0.5))
                ),
                onSubmitted: (value) {
                  if (value != "") {
                    _currentIndex1 = -1;
                    _currentIndex2 = -1;
                    _currentIndex3 = -1;

                    _categoryList2.clear();
                    _categoryList3.clear();

                    _loadCategoryLevel3(circleName: value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryLeve1() {
    return Container(
      width: 100,
      color: Color.fromRGBO(238, 238, 238, 0.4),
      child: ListView.builder(
        itemExtent: 44,
        itemCount: _categoryList1.length,
        itemBuilder: (BuildContext context, int index) {
          Map categoryMap = _categoryList1[index];
          //return ListTile(title: Text(categoryMap['name']));
          return GestureDetector(
            child: Container(
              color: (index == _currentIndex1) ? Color.fromRGBO(238, 238, 238, 0.2) : Color.fromRGBO(238, 238, 238, 0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 3,
                    height: 20,
                    decoration: BoxDecoration(
                        color: (index == _currentIndex1) ? ColorConstants.themeColorBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(1.5)
                    ),
                  ),
                  SizedBox(width: 17),
                  Text(categoryMap['circleName'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ColorConstants.textColor51))
                ],
              ),
            ),
            onTap: () {
              _currentIndex1 = index;
              _currentIndex2 = -1;
              _currentIndex3 = -1;

              _categoryList2.clear();
              _categoryList3.clear();

              if (_currentIndex1 != 4) {
                _loadCategoryLevel3();
              } else {
                _loadCategoryLevel2();
              }

              setState(() { });
            },
          );
        }
      ),
    );
  }

  Widget _buildCategoryLeve2() {
    return Container(
      width: 100,
      color: Color.fromRGBO(238, 238, 238, 0.2),
      child: ListView.builder(
        itemCount: _categoryList2.length,
        itemExtent: 44,
        itemBuilder: (BuildContext context, int index) {
          IndustryModel industryModel = _categoryList2[index];

          return GestureDetector(
            child: Container(
              color: (index == _currentIndex2) ? Colors.white : Color.fromRGBO(238, 238, 238, 0.2),
              padding: EdgeInsets.only(right: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 3,
                    height: 20,
                    decoration: BoxDecoration(
                      color: (index == _currentIndex2) ? ColorConstants.themeColorBlue : Colors.transparent,
                      borderRadius: BorderRadius.circular(1.5)
                    ),
                  ),
                  Expanded(
                    child: Text(industryModel.circleName, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: ColorConstants.textColor51))
                  )
                ],
              ),
            ),
            onTap: () {
              setState(() {
                _currentIndex2 = index;
                _currentIndex3 = -1;
                _categoryList3.clear();
              });

              _loadCategoryLevel3();
            },
          );
        }),
    );
  }

  Widget _buildCategoryLeve3(parentContext) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemExtent: 44,
        itemCount: _categoryList3.length,
        itemBuilder: (BuildContext context, int index) {
          CircleModel circleModel = _categoryList3[index];

          return GestureDetector(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(circleModel.circleName, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: ColorConstants.textColor51)),
                  ),
                  // IconButton(
                  //   icon: Image.asset(join(AssetsUtil.assetsDirectoryMarket, 'icon_circle_add.png')),
                  //   onPressed: () {
                  //     _currentIndex3 = index;
                  //     _addCircleRequest(parentContext);
                  //   },
                  // )
                ],
              ),
            ),
            onTap: () {
              setState(() {
                _currentIndex3 = index;
                Get.to(CircleDetail(circleModel.id));
              });
            },
          );
        }
      ),
    );
  }

  void _loadCategoryLevel1() async {
    await DioUtil.request('/resource/getMarketTypeList', method: 'GET').then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData);
      if (success) {
        setState(() {
          _categoryList1 = responseData['data'];

          // TODO: for test，it should be removed after complete
          _currentIndex1 = 4;
          _loadCategoryLevel2();
        });
      }
    });
  }

  void _loadCategoryLevel2() async {
    if (_currentIndex1 == 4) {
      DioUtil.request('/resource/getIndustryList', method: 'GET').then((responseData) {
        bool success = DioUtil.checkRequestResult(responseData);
        if (success) {
          setState(() {
            List<dynamic> dataList = responseData['data'];
            if (dataList != null && dataList.length > 0) {
              _categoryList2.addAll(dataList.map((industryJson) {
                return IndustryModel.fromJson(industryJson);
              }).toList());
            }
          });

          // TODO: for test，it should be removed after complete
          _currentIndex2 = 0;
          _loadCategoryLevel3();
        }
      });
    }
  }

  void _loadCategoryLevel3({String circleName}) async {
    _categoryList3.clear();
    setState(() { });

    Map<String, dynamic> params = {};

    if (circleName != null) {
      params["queryList"] = 1;
      params["circleName"] = circleName;
    } else {
      params = {"marketTypeId": _currentIndex1};

      if (_currentIndex2 == -1) {
        params["marketSubTypeId"] = 0;
      } else {
        IndustryModel categoryLevel2 = _categoryList2[_currentIndex2];
        params["marketSubTypeId"] = categoryLevel2.id;
      }
    }

    DioUtil.request('/market/getMarketCircleList', parameters: params).then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData);
      if (success) {
        setState(() {
          List<dynamic> dataList = responseData['data'];
          if (dataList != null && dataList.length > 0) {
            _categoryList3.addAll(dataList.map((circleJson) {
              return CircleModel.fromJson(circleJson);
            }).toList());
          }
        });
      }
    });
  }

  void _addCircleRequest(parentContext) {
    Map category1 = _categoryList1[_currentIndex1];
    CircleModel category3 = _categoryList3[_currentIndex3];

    Map params = {'marketTypeId': category1['id'], 'marketCircleId': category3.id};
    print(params);
    DioUtil.request('/market/addUserMarketUserCircle', parameters: params).then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData);
      if (success) {
        ToastUtil.show(responseData['msg'], parentContext);
      }
    });
  }
}