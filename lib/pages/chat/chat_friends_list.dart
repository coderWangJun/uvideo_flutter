import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/pages/person/user_detail_route.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';

class ChatFriendsListProvide extends ChangeNotifier {
  IconData icon_on = Icons.keyboard_arrow_down;
  IconData icon_un = Icons.keyboard_arrow_right;

  List<Map> mListTitle;

  List mAllFriendsList = [];
  List mMyCarePersons = [];
  List mMyFunPersons = [];
  List _personalInfoDatas = [];

  Map countMap = {"careCount": "", "fansCount": "", "friendsCount": ""};

  initProvide() {
    mListTitle = [
      {"title": "全部好友", "count": "0", "icon": icon_un, "open": false},
      {"title": "我的关注", "count": "0", "icon": icon_un, "open": false},
      {"title": "我的粉丝", "count": "0", "icon": icon_un, "open": false}
    ];
    _personalInfoDatas = [
      {'title': '公司', 'second_title': '重庆明艳文化传媒有限公司', 'count': 3},
      {'title': '学校', 'second_title': '重庆工商大学', 'count': 3},
      {'title': '家乡', 'second_title': '重庆', 'count': 3},
      {'title': '行业', 'second_title': '文化传媒', 'count': 3},
    ];
    DioUtil.request("/user/countRelationship").then((value) {
      if (DioUtil.checkRequestResult(value) && value['data'] != null) {
        countMap = value['data'];
        notifyListeners();
      }
    });
  }

  void checkAllFriends() {
    if (!mListTitle[0]["open"]) {
      //打开列表逻辑
      mListTitle[0]["open"] = true;
      mListTitle[0]["icon"] = icon_on;
      if (mAllFriendsList.length == 0 || mAllFriendsList == null) {
        DioUtil.request("/user/getUserFriendsList").then((value) {
          if (DioUtil.checkRequestResult(value)) {
            if (value['data'] != null) {
              mAllFriendsList = value['data'];
              mAllFriendsList.forEach((element) {
                element['showCareText'] = true;
              });
            }
            notifyListeners();
          }
        });
      } else {
        notifyListeners();
      }
    } else {
      //收起列表逻辑
      mListTitle[0]["open"] = false;
      mListTitle[0]["icon"] = icon_un;
      notifyListeners();
    }
  }

  void checkMyCare() {
    if (!mListTitle[1]["open"]) {
      //打开列表逻辑
      mListTitle[1]["open"] = true;
      mListTitle[1]["icon"] = icon_on;
      if (mMyCarePersons.length == 0 || mMyCarePersons == null) {
        DioUtil.request("/user/getUserCareList").then((value) {
          if (DioUtil.checkRequestResult(value)) {
            if (value['data'] != null) {
              mMyCarePersons = value['data'];
              mMyCarePersons.forEach((element) {
                element['showCareText'] = true;
              });
            }
            notifyListeners();
          }
        });
      } else {
        notifyListeners();
      }
    } else {
      //收起列表逻辑
      mListTitle[1]["open"] = false;
      mListTitle[1]["icon"] = icon_un;
      notifyListeners();
    }
  }

  void checkMyFun() {
    if (!mListTitle[2]["open"]) {
      //打开列表逻辑
      mListTitle[2]["open"] = true;
      mListTitle[2]["icon"] = icon_on;
      if (mMyFunPersons.length == 0 || mMyFunPersons == null) {
        DioUtil.request("/user/getUserFansList").then((value) {
          if (DioUtil.checkRequestResult(value)) {
            if (value['data'] != null) {
              mMyFunPersons = value['data'];
              mMyFunPersons.forEach((element) {
                element['showCareText'] = false;
              });
            }
            notifyListeners();
          }
        });
      } else {
        notifyListeners();
      }
    } else {
      //收起列表逻辑
      mListTitle[2]["open"] = false;
      mListTitle[2]["icon"] = icon_un;
      notifyListeners();
    }
  }

  changeShowCareStatus(int index, int position) {
    switch (index) {
      case 0:
        mAllFriendsList[position]['showCareText'] =
            !mAllFriendsList[position]['showCareText'];
        break;
      case 1:
        mMyCarePersons[position]['showCareText'] =
            !mMyCarePersons[position]['showCareText'];
        break;
      case 2:
        mMyFunPersons[position]['showCareText'] =
            !mMyFunPersons[position]['showCareText'];
        break;
    }
    notifyListeners();
  }
}

class ChatFriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: ChatFriendsListProvide(),
      onReady: (model) {
        model.initProvide();
      },
      onDispose: (model) {},
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 44.0),
            child: AppBar(
              backgroundColor: Colors.white, elevation: 0.0,
              leading: IconButton(
                icon: Image.asset(join(
                    AssetsUtil.assetsDirectoryCommon, "nav_back_black.png")),
                onPressed: () {
                  Navigator.of(context)..pop();
                },
              ),
              brightness: Brightness.light,
//              actions: <Widget>[
//                IconButton(icon: Icon(Icons.search,color: Colors.black,),onPressed: (){
//                  //搜索
//                  Navigator.of(context)..pop();
//                },),
//              ],
            ),
          ),
          body: _getBody(model),
        );
      },
    );
  }

  Widget _getBody(ChatFriendsListProvide model) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _getTitleWidget(model, 0, "friendsCount"),
          Visibility(
            child: Column(children: _getItemsWidget(model, 0)),
            visible: model.mListTitle[0]['open'],
          ),
          _getTitleWidget(model, 1, "careCount"),
          Visibility(
            child: Column(children: _getItemsWidget(model, 1)),
            visible: model.mListTitle[1]['open'],
          ),
          _getTitleWidget(model, 2, "fansCount"),
          Visibility(
            child: Column(children: _getItemsWidget(model, 2)),
            visible: model.mListTitle[2]['open'],
          ),
          Column(
            children: model._personalInfoDatas
                .map(
                  (item) => _personalInfo(
                    title: item['title'],
                    secondTitle: item['second_title'],
                    count: item['count'],
                  ),
                )
                .toList(),
          ),
          _customGroup(),
        ],
      ),
    );
  }

  Widget _getTitleWidget(
      ChatFriendsListProvide model, int index, String mapName) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 60.0,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 17.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              model.mListTitle[index]['title'],
              style: TextStyle(
                  color: Color.fromRGBO(51, 51, 51, 1), fontSize: 15.0),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "${model.countMap[mapName]}",
                  style: TextStyle(
                      color: Color.fromRGBO(102, 102, 102, 1), fontSize: 13.0),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Icon(
                  model.mListTitle[index]['icon'],
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                )
              ],
            )
          ],
        ),
      ),
      onTap: () {
        print("oook");
        switch (index) {
          case 0:
            model.checkAllFriends();
            break;
          case 1:
            model.checkMyCare();
            break;
          case 2:
            model.checkMyFun();
            break;
        }
      },
    );
  }

  List<Widget> _getItemsWidget(ChatFriendsListProvide model, int index) {
    List mDataList;
    switch (index) {
      case 0:
        {
          mDataList = model.mAllFriendsList;
          break;
        }
      case 1:
        {
          mDataList = model.mMyCarePersons;
          break;
        }
      case 2:
        {
          mDataList = model.mMyFunPersons;
          break;
        }
    }
    int position = -1;
    return mDataList.map((e) {
      position++;
      int posiNum = position;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
            width: double.infinity,
            height: 80.0,
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                              image: NetworkImage(index != 2
                                  ? e['targetUserHeadPortrait'] ??=
                                      ImProvider.DEF_HEAD_IMAGE_URL
                                  : e['userHeadPortrait'] ??=
                                      ImProvider.DEF_HEAD_IMAGE_URL),
                              fit: BoxFit.cover), //头像图片
                          shape: BoxShape.circle),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          e['name'] ??= "",
                          style: TextStyle(
                              color: Color.fromRGBO(51, 51, 51, 1),
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
//                Text("公司·职位",style: TextStyle(color: Color.fromRGBO(102, 102, 102, 1),fontSize: 13.0),),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  child: Container(
                    height: 24.0,
                    constraints: BoxConstraints(minWidth: 20.0),
                    padding: EdgeInsets.symmetric(horizontal: 7.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(235, 235, 235, 1),
                            width: 1.0),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Center(
                        child: Text(
                      e["showCareText"] ? "取消关注" : "关注",
                      style: TextStyle(
                          color: Color.fromRGBO(102, 102, 102, 1),
                          fontSize: 12.0),
                    )),
                  ),
                  onTap: () {
                    String requestUrl;
                    if (e["showCareText"]) {
                      requestUrl = "/user/cancelUserCare";
                    } else {
                      requestUrl = "/user/addUserCare";
                    }
                    DioUtil.request(requestUrl, parameters: {
                      'targetUserid':
                          index != 2 ? e['targetUserid'] : e['userid']
                    }).then((value) {
                      if (DioUtil.checkRequestResult(value)) {
                        model.changeShowCareStatus(index, posiNum);
                      }
                    });
                  },
                )
              ],
            )),
        onTap: () {
          ///点击去聊天
          Get.to(UserDetailRoute(
            userId: index != 2 ? e['targetUserid'] : e['userid'],
          ));
//        Get.to(UserDetailRoute(userId: "4a16708f-ed9a-4161-9120-8c3093813fe2"));
        },
      );
    }).toList();
  }

  Widget _personalInfo({
    @required String title,
    @required String secondTitle,
    @required int count,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(
                      30,
                      10,
                      10,
                      10,
                    ),
                    child: Text(
                      '更多',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    secondTitle,
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.7),
                      fontSize: 16,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(
                      30,
                      10,
                      5,
                      10,
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '${count ?? 0}',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 15,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Color.fromRGBO(0, 0, 0, 0.3),
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customGroup() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: 30,
      ),
      child: InkWell(
        onTap: () {},
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            vertical: 30,
          ),
          child: Text(
            '自定义分组',
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 0.7),
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
