import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/models/market_post_media_model.dart';
import 'package:youpinapp/models/market_post_model.dart';
import 'package:youpinapp/pages/market/market_list_player.dart';
import 'package:youpinapp/pages/market/market_post_list.dart';
import 'package:youpinapp/pages/person/user_detail_route.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dataTime_string.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/uiUtil.dart';
import 'package:youpinapp/widgets/empty_widget.dart';
import 'package:youpinapp/widgets/image_big.dart';

class MarketListDetailProvide with ChangeNotifier {
  bool isHaveUnico = false;

  //一级评论一页的评论数
  static final int PAGE_SIZE = 10;

  bool loadingFreeOne = true;
  bool loadingFreeOther = true;

  //当前显示页数
  int currentPage = 1;
  bool oneFlag = true;
  bool isHasNextPage = true;

  bool isHasQx = true;

  MarketPostModel marketModel;
  Map marketState;

  List commentList = [];

  Map<num, Map> otherCommentMap = {};

  //打赏
  giveUnicoToSomeone(num inWhere, num id, num commentId, String userId) {
    if (isHaveUnico) {
      Map param = {
        "tradeAmount": marketModel.ucoinAmount,
        "goodsId": marketModel.id,
        "commentId": commentId,
        "receiveUserid": userId
      };
      DioUtil.request("/market/acceptMarketComment", parameters: param)
          .then((value) {
        if (DioUtil.checkRequestResult(value)) {
          isHaveUnico = false;
          //todo----==>刷新UI
          if (inWhere != 0) {
            otherCommentMap[inWhere]['data'][id]['accepted'] = 1;
          } else {
            commentList[id]['accepted'] = 1;
          }
          notifyListeners();
        }
      });
    }
  }

  init(num marketId) {
    if (marketId != -1) {
      DioUtil.request("/market/getMarketList", parameters: {"id": marketId})
          .then((value) {
        if (DioUtil.checkRequestResult(value)) {
          if (value['data'] != null) {
            marketModel = MarketPostModel.fromJson(value['data'][0]);
            marketState = {};
            marketState['praiseColor'] = marketModel.isLiked == 1
                ? MarketPostListProvider.praiseColor_on
                : MarketPostListProvider.praiseColor_un;
            marketState['praiseNum'] = marketModel.likes;
            getOneLevelComment();
          } else {
            oneFlag = true;
            isHasQx = false;
            notifyListeners();
          }
        }
      });
    } else {
      getOneLevelComment();
    }
  }

  getOneLevelComment({bool refresh = false}) {
    oneFlag = true;
    if (refresh) {
      isHasNextPage = true;
      currentPage = 1;
      commentList.clear();
    }
    if (isHasNextPage && loadingFreeOne) {
      loadingFreeOne = false;
      DioUtil.request("/market/getMarketComment", parameters: {
        "marketId": marketModel.id,
        "current": currentPage,
        "size": PAGE_SIZE
      }).then((value) {
        if (DioUtil.checkRequestResult(value) && value['data'] != null) {
          List commentListState = new List();
          int position = 0;
          (value['data'] as List).forEach((element) {
            if (element['isLiked'] != 1) {
              element['praiseColor'] = MarketPostListProvider.praiseColor_un;
            } else {
              element['praiseColor'] = MarketPostListProvider.praiseColor_on;
            }
            element['praiseNum'] = element['likes'];
            element['posNum'] = position;
            commentListState.add(element);
            position++;
          });
          commentList.addAll(commentListState);
          if ((value['data'] as List).length < PAGE_SIZE) {
            isHasNextPage = false;
          } else {
            currentPage++;
          }
          notifyListeners();
        } else {
          isHasNextPage = false;
          notifyListeners();
        }
        loadingFreeOne = true;
      });
    }
  }

  getOtherLevelComment(num index, {bool refresh = false}) {
    if (index == 0) {
      return;
    }

    if (otherCommentMap[index] == null || refresh) {
      otherCommentMap[index] = {};
      otherCommentMap[index]['isHasNextPage'] = true;
      otherCommentMap[index]['currentPage'] = 1;
    }
    if (otherCommentMap[index]['isHasNextPage'] && loadingFreeOther) {
      loadingFreeOther = false;
      DioUtil.request("/market/getMarketComment", parameters: {
        "marketId": marketModel.id,
        "current": otherCommentMap[index]['currentPage'],
        "size": PAGE_SIZE,
        "belongTo": index
      }).then((value) {
        if (DioUtil.checkRequestResult(value) && value['data'] != null) {
          List commentListState = new List();
          otherCommentMap[index]['data'] = [];
          int position = 0;
          (value['data'] as List).forEach((element) {
            if (element['isLiked'] != 1) {
              element['praiseColor'] = MarketPostListProvider.praiseColor_un;
            } else {
              element['praiseColor'] = MarketPostListProvider.praiseColor_on;
            }
            element['praiseNum'] = element['likes'];
            element['posNum'] = position;
            commentListState.add(element);
            position++;
          });
          otherCommentMap[index]['data'].addAll(commentListState);
          if ((value['data'] as List).length < PAGE_SIZE) {
            otherCommentMap[index]['isHasNextPage'] = false;
          } else {
            otherCommentMap[index]['currentPage']++;
          }
          notifyListeners();
        } else {
          otherCommentMap[index]['isHasNextPage'] = false;
          notifyListeners();
        }
        loadingFreeOther = true;
      });
    }
  }

  //点赞
  changePraise(num inWhere, num id, {bool checkWhere = true, num position}) {
    if (checkWhere) {
      if (marketState["praiseColor"] == MarketPostListProvider.praiseColor_un) {
        DioUtil.request("/market/addLikes", parameters: {"id": id, "flag": 1})
            .then((value) {
          if (DioUtil.checkRequestResult(value)) {
            marketState["praiseColor"] = MarketPostListProvider.praiseColor_on;
            marketState["praiseNum"] = marketState["praiseNum"] + 1;
            notifyListeners();
          }
        });
      } else {
        DioUtil.request("/market/addLikes", parameters: {"id": id, "flag": 2})
            .then((value) {
          if (DioUtil.checkRequestResult(value)) {
            marketState["praiseColor"] = MarketPostListProvider.praiseColor_un;
            marketState["praiseNum"] = marketState["praiseNum"] - 1;
            notifyListeners();
          }
        });
      }
    } else {
      if (inWhere != 0) {
        if (otherCommentMap[inWhere]['data'][position]['praiseColor'] ==
            MarketPostListProvider.praiseColor_un) {
          DioUtil.request("/market/addMarketCommentLikes",
              parameters: {"id": id, "flag": 1}).then((value) {
            if (DioUtil.checkRequestResult(value)) {
              otherCommentMap[inWhere]['data'][position]['praiseColor'] =
                  MarketPostListProvider.praiseColor_on;
              otherCommentMap[inWhere]['data'][position]["praiseNum"] =
                  otherCommentMap[inWhere]['data'][position]['praiseNum'] + 1;
              notifyListeners();
            }
          });
        } else {
          DioUtil.request("/market/addMarketCommentLikes",
              parameters: {"id": id, "flag": 2}).then((value) {
            if (DioUtil.checkRequestResult(value)) {
              otherCommentMap[inWhere]['data'][position]['praiseColor'] =
                  MarketPostListProvider.praiseColor_un;
              otherCommentMap[inWhere]['data'][position]["praiseNum"] =
                  otherCommentMap[inWhere]['data'][position]['praiseNum'] - 1;
              notifyListeners();
            }
          });
        }
      } else {
        if (commentList[position]['praiseColor'] ==
            MarketPostListProvider.praiseColor_un) {
          DioUtil.request("/market/addMarketCommentLikes",
              parameters: {"id": id, "flag": 1}).then((value) {
            if (DioUtil.checkRequestResult(value)) {
              commentList[position]['praiseColor'] =
                  MarketPostListProvider.praiseColor_on;
              commentList[position]["praiseNum"] =
                  commentList[position]['praiseNum'] + 1;
              notifyListeners();
            }
          });
        } else {
          DioUtil.request("/market/addMarketCommentLikes",
              parameters: {"id": id, "flag": 2}).then((value) {
            if (DioUtil.checkRequestResult(value)) {
              commentList[position]['praiseColor'] =
                  MarketPostListProvider.praiseColor_un;
              commentList[position]["praiseNum"] =
                  commentList[position]['praiseNum'] - 1;
              notifyListeners();
            }
          });
        }
      }
    }
  }

  delete(num id) {
    DioUtil.request("/market/deleteMarket", parameters: {'id': id})
        .then((value) {
      if (DioUtil.checkRequestResult(value, showToast: true)) {
        Get.back(result: 1);
      }
    });
  }

  addComment(String contentString, num reply, num belong) {
    DioUtil.request("/market/updateMarketComment", parameters: {
      "marketId": marketModel.id,
      "content": contentString,
      "replyTo": reply,
      "belongTo": belong
    }).then((value) {
      if (DioUtil.checkRequestResult(value)) {
        getOneLevelComment(refresh: true);
        getOtherLevelComment(belong, refresh: true);
      }
    });
  }
}

class MarketListDetail extends StatefulWidget {
  MarketPostModel marketPostModel;
  Map modelState;
  num marketId = -1;
  MarketListDetail(this.marketPostModel, this.modelState, {this.marketId = -1});

  @override
  _MarketListDetailState createState() => _MarketListDetailState();
}

class _MarketListDetailState extends State<MarketListDetail>
    with TickerProviderStateMixin {
  bool _isMySender = false;

  AnimationController _animationController;
  Animation<double> _animation;

  ScrollController _scrollController = new ScrollController();
  ScrollController _scrollControllerTow = new ScrollController();

  //当前展开的二级评论列表id
  int inWhereIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.marketPostModel.userid == g_accountManager.currentUser.id) {
      _isMySender = true;
    }
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 900.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: MarketListDetailProvide(),
      onReady: (model) {
        model.marketModel = widget.marketPostModel;
        model.marketState = widget.modelState;
        if (widget.marketPostModel.rewarded == 0) {
          model.isHaveUnico = true;
        }
        if (widget.marketId != -1) {
          model.oneFlag = false;
        }
        model.init(widget.marketId);

        _scrollController.addListener(() {
          if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent) {
            model.getOneLevelComment();
          }
        });

        _scrollControllerTow.addListener(() {
          if (_scrollControllerTow.position.pixels >=
              _scrollControllerTow.position.maxScrollExtent) {
            model.getOtherLevelComment(inWhereIndex);
          }
        });
      },
      onDispose: (model) {},
      builder: (context, model, child) {
        return WillPopScope(
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: Size(double.infinity, 44.0),
                child: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  brightness: Brightness.light,
                  leading: IconButton(
                    icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon,
                        "nav_back_black.png")),
                    onPressed: () {
                      Navigator.of(context)..pop(model.marketState);
                    },
                  ),
                  actions: <Widget>[
                    Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.more_vert,
                        ),
                        color: Color.fromRGBO(0, 0, 0, 0.6),
                        onPressed: () {},
                      ),
                    ),
                    _isMySender
                        ? Container(
                            padding: EdgeInsets.only(
                              right: 20,
                            ),
                            child: GestureDetector(
                              child: Center(
                                child: Text(
                                  "删 除",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Color.fromRGBO(51, 51, 51, 1)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onTap: () {
                                //点击保存
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return UiUtil.getOkButtonCon(
                                          MediaQuery.of(context).size.width -
                                              100.0,
                                          120.0,
                                          "你确定要删除吗", () {
                                        Get.back(result: true);
                                      }, () {
                                        Get.back(result: false);
                                      });
                                    }).then((value) {
                                  if (value != null) {
                                    if (value) {
                                      model.delete(widget.marketPostModel.id);
                                    }
                                  }
                                });
                              },
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
              body:
                  model.oneFlag ? _getBody(context, model) : SizedBox.shrink()),
          onWillPop: () async {
            Navigator.of(context)..pop(model.marketState);
            return false;
          },
        );
      },
    );
  }

  Widget _getBody(BuildContext context, MarketListDetailProvide model) {
    return model.isHasQx
        ? SafeArea(
            child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            //这是详情部分
                            Container(
                                width: double.infinity,
                                constraints: BoxConstraints(
                                  minHeight: 100.0,
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                            child: Row(
                                          children: <Widget>[
                                            GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              child: Container(
                                                width: 55.0,
                                                height: 55.0,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(model
                                                                .marketModel
                                                                .headPortraitUrl ??=
                                                            ImProvider
                                                                .DEF_HEAD_IMAGE_URL)),
                                                    shape: BoxShape.circle),
                                              ),
                                              onTap: () {
                                                Get.to(UserDetailRoute(
                                                    userId: widget
                                                        .marketPostModel
                                                        .userid));
                                              },
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "${model.marketModel.name ??= ''}",
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              51, 51, 51, 1),
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    Text(
                                                      "${model.marketModel.companyName ??= ''}",
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              153, 153, 153, 1),
                                                          fontSize: 13.0),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    top: 5,
                                                  ),
                                                  child: Text(
                                                    "${DataTimeToString.toTextString(DateTime.parse(model.marketModel.createdTime))}  ${model.marketModel.marketCircleName ??= ""}",
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            153, 153, 153, 1),
                                                        fontSize: 13.0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Container(
                                            width: 65,
                                            padding: EdgeInsets.only(
                                              top: 1,
                                              bottom: 3,
                                            ),
                                            color: Color.fromRGBO(
                                                0, 127, 255, 0.9),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    top: 2,
                                                  ),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    left: 2,
                                                  ),
                                                  child: Text(
                                                    '关注',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      constraints:
                                          BoxConstraints(minHeight: 20.0),
                                      child: Text(
                                        "${model.marketModel.content}",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(51, 51, 51, 1),
                                            fontSize: 15.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    _getMsgNode(model),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Image.asset(
                                                  join(
                                                      AssetsUtil
                                                          .assetsDirectoryMarket,
                                                      'market_share.png'),
                                                  color: Color.fromRGBO(
                                                      141, 141, 141, 1),
                                                  // color: model.marketState[
                                                  //     "praiseColor"],
                                                ),
                                                SizedBox(
                                                  width: 8.0,
                                                ),
                                                Text(
                                                  "0",
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          141, 141, 141, 1),
                                                      fontSize: 15.0),
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              // model.changePraise(
                                              //     0, model.marketModel.id);
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                  join(
                                                      AssetsUtil
                                                          .assetsDirectoryMarket,
                                                      'market_comment.png'),
                                                  color: Color.fromRGBO(
                                                      141, 141, 141, 1),
                                                  // color: model.marketState[
                                                  //     "praiseColor"],
                                                ),
                                                SizedBox(
                                                  width: 8.0,
                                                ),
                                                Text(
                                                  "0",
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          141, 141, 141, 1),
                                                      fontSize: 15.0),
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              // model.changePraise(
                                              //     0, model.marketModel.id);
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                  join(
                                                      AssetsUtil
                                                          .assetsDirectoryMarket,
                                                      'market_praise.png'),
                                                  color: model.marketState[
                                                      "praiseColor"],
                                                ),
                                                SizedBox(
                                                  width: 8.0,
                                                ),
                                                Text(
                                                  "${model.marketState['praiseNum']}",
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          141, 141, 141, 1),
                                                      fontSize: 15.0),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              model.changePraise(
                                                  0, model.marketModel.id);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),

                            Container(
                              color: Color.fromRGBO(238, 238, 238, 1),
                              width: double.infinity,
                              height: 5.0,
                            ),

                            Container(
                              width: double.infinity,
                              constraints: BoxConstraints(minHeight: 20.0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "全部回复",
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(51, 51, 51, 1),
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 30,
                                          top: 4,
                                        ),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Text(
                                            "只看楼主",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    51, 51, 51, 0.5),
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  model.commentList.length > 0
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: model.commentList.map((e) {
                                            return _getItemTalk(
                                                context, e, model);
                                          }).toList(),
                                        )
                                      : EmptyWidget(
                                          showTitle: "它暂时还没有评论哦",
                                          mHeight: 500.0,
                                        )
                                ],
                              ),
                            ),
                          ],
                        ),
                        controller: _scrollController,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Colors.black54,
                          offset: Offset(2.0, 2.0),
                          blurRadius: 4.0)
                    ]),
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 50.0,
                    padding: EdgeInsets.fromLTRB(
                      20.0,
                      10.0,
                      0,
                      10.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 20.0),
                                margin: EdgeInsets.only(
                                  right: 15,
                                ),
                                height: 40.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                ),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "我有一个想法...",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                142, 142, 142, 1),
                                            fontSize: 11.0),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ])),
                            onTap: () {
                              ///点击编辑评论
                              print("评论");
                              _editTalk(context, model.marketModel.id,
                                  model.marketModel.name ?? "", model);
                            },
                          ),
                          flex: 6,
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                                height: 26.0,
                                child: Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Image.asset(join(
                                          AssetsUtil.assetsDirectoryMarket,
                                          'market_comment.png')),
                                      Text(
                                        "${(model.marketModel.numberOfComments ??= 0) == 0 ? '' : model.marketModel.numberOfComments}",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(141, 141, 141, 1),
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            onTap: () {
                              ///点击编辑评论
                              print("评论1");
                            },
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                                height: 26.0,
                                child: Center(
                                  child: Image.asset(join(
                                      AssetsUtil.assetsDirectoryMarket,
                                      'sc.png')),
                                )),
                            onTap: () {
                              ///点击编辑评论
                              print("评论2");
                            },
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                                height: 26.0,
                                child: Center(
                                  child: Image.asset(join(
                                      AssetsUtil.assetsDirectoryMarket,
                                      'market_share.png')),
                                )),
                            onTap: () {
                              ///点击编辑评论
                              print("评论3");
                            },
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              _showMore(
                  context, MediaQuery.of(context).size.height * 0.8, model)
            ],
          ))
        : EmptyWidget(
            showTitle: "你可能没有权限查看哦~",
          );
  }

  Widget _getItemTalk(
      BuildContext context, Map itemValue, MarketListDetailProvide model) {
    bool isLZFlag = false;
    bool isHasMore = true;
    bool isReply = false;
    if (widget.marketPostModel.userid == itemValue['userid']) {
      isLZFlag = true;
    }
    if (itemValue['numberOfComments'] == null ||
        itemValue['numberOfComments'] == 0 ||
        itemValue['belongTo'] != 0) {
      isHasMore = false;
    }
    if (itemValue['belongTo'] != null &&
        itemValue['belongTo'] != 0 &&
        itemValue['replyTo'] != inWhereIndex) {
      isReply = true;
    }
    return Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 50.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(itemValue['headPortrait'] ??=
                                  ImProvider.DEF_HEAD_IMAGE_URL)),
                          shape: BoxShape.circle,
                        ),
                      ),
                      onTap: () {
                        Get.to(UserDetailRoute(userId: itemValue['userid']));
                      },
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: "${itemValue['name'] ??= ''}",
                            style: TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: isReply ? "   回复   " : "",
                            style: TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontSize: 13.0),
                          ),
                          TextSpan(
                            text: isReply
                                ? "${itemValue['replyName'] ??= ''}"
                                : "",
                            style: TextStyle(
                                color: Color.fromRGBO(75, 152, 244, 1),
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ])),
                        Text(
                          "${DataTimeToString.toTextString(DateTime.parse(itemValue['createdTime']))}",
                          style: TextStyle(
                              color: Color.fromRGBO(153, 153, 153, 1),
                              fontSize: 13.0),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Visibility(
                        visible: isLZFlag,
                        child: Container(
                            constraints:
                                BoxConstraints(minWidth: 24.0, minHeight: 13.0),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(75, 152, 244, 1),
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: Center(
                              child: Text(
                                " 楼主 ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.0,
                                ),
                              ),
                            ))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    itemValue['belongTo'] == 0 &&
                            (_isMySender &&
                                (itemValue['userid'] !=
                                    g_accountManager.currentUser.id)) &&
                            ((itemValue['accepted'] as int) == 1 ||
                                model.isHaveUnico)
                        ? GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: UiUtil.getContainer(
                                20.0,
                                10.0,
                                (itemValue['accepted'] as int) != 1
                                    ? UiUtil.getColor(255)
                                    : UiUtil.getColor(76, num1: 152, num2: 244),
                                (itemValue['accepted'] as int) != 1
                                    ? Text(
                                        "打赏",
                                        style: UiUtil.getTextStyle(154, 12.0),
                                      )
                                    : Text(
                                        "已打赏",
                                        style: UiUtil.getTextStyle(255, 12.0),
                                      ),
                                borders: (itemValue['accepted'] as int) != 1
                                    ? Border.all(color: UiUtil.getColor(238))
                                    : null,
                                mWidth: 50.0),
                            onTap: () {
                              //todo--->打赏
                              model.giveUnicoToSomeone(
                                  inWhereIndex,
                                  itemValue['posNum'],
                                  itemValue['id'] as num,
                                  itemValue['userid'] as String);
                            },
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      width: 10.0,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            join(AssetsUtil.assetsDirectoryMarket,
                                'market_praise.png'),
                            color: itemValue["praiseColor"],
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            "${itemValue['praiseNum'] ??= 0}",
                            style: TextStyle(
                                color: Color.fromRGBO(141, 141, 141, 1),
                                fontSize: 15.0),
                          ),
                        ],
                      ),
                      onTap: () {
                        model.changePraise(inWhereIndex, itemValue['id'],
                            checkWhere: false, position: itemValue['posNum']);
                      },
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 18.0,
            ),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: 10.0),
              padding: EdgeInsets.only(left: 50.0),
              child: Text(
                "${itemValue['content'] ??= ''}",
                style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1), fontSize: 15.0),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 50.0, top: 10.0, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child: Text(
                        "回复",
                        style: TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 13.0),
                      ),
                      onTap: () {
                        _editTalk(context, itemValue['id'],
                            itemValue['name'] ??= '', model);
                      },
                    ),
                    Visibility(
                      visible: isHasMore,
                      child: GestureDetector(
                        child: Text(
                          "查看${itemValue['numberOfComments'] ??= 0}条回复 >",
                          style: TextStyle(
                              color: Color.fromRGBO(153, 153, 153, 1),
                              fontSize: 13.0),
                        ),
                        onTap: () {
                          inWhereIndex = itemValue['id'];
                          model.getOtherLevelComment(itemValue['id']);
                          _animationController.forward();
                        },
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }

  Widget _showMore(BuildContext context, double containerHeight,
      MarketListDetailProvide model) {
    double containerWidth = MediaQuery.of(context).size.width;
    bool mShowFlag = false;
    if (model.otherCommentMap[inWhereIndex] != null) {
      if (model.otherCommentMap[inWhereIndex]['data'] != null) {
        if (model.otherCommentMap[inWhereIndex]['data'].length > 0) {
          mShowFlag = true;
        }
      }
    }
    return Positioned(
        bottom: 0.0,
        child: Container(
            constraints: BoxConstraints(maxHeight: containerHeight),
            width: containerWidth,
            height: _animation.value,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      offset: Offset(2.0, 2.0),
                      blurRadius: 4.0)
                ]),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: containerWidth,
                    height: 44.0,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color.fromRGBO(238, 238, 238, 1)))),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            ///关闭
                            _animationController.reverse().whenComplete(() {
                              inWhereIndex = 0;
                            });
                          }),
                    ),
                  ),
                  Container(
                      width: containerWidth,
                      height: containerHeight - 45.0,
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 18.0),
                      child: SingleChildScrollView(
                        child: mShowFlag
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: (model.otherCommentMap[inWhereIndex]
                                        ['data'] as List)
                                    .map((e) {
                                  return _getItemTalk(context, e, model);
                                }).toList(),
                              )
                            : EmptyWidget(
                                showTitle: "它暂时还没有评论哦",
                                mHeight: 500.0,
                              ),
                      ))
                ],
              ),
            )));
  }

  _editTalk(BuildContext context, num replyTo, String nameText,
      MarketListDetailProvide model) {
    if (replyTo == model.marketModel.id) {
      replyTo = 0;
    }
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          String valueText;
          return GestureDetector(
            child: Scaffold(
                backgroundColor: Color.fromRGBO(255, 255, 255, 0),
                body: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black54,
                                offset: Offset(2.0, 2.0),
                                blurRadius: 4.0)
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 44.0,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color:
                                            Color.fromRGBO(238, 238, 238, 1)))),
                            child: Center(
                              child: Text(
                                "回复 $nameText",
                                style: TextStyle(
                                    color: Color.fromRGBO(51, 51, 51, 1),
                                    fontSize: 15.0),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            width: MediaQuery.of(context).size.width,
                            height:
                                MediaQuery.of(context).size.height * 0.35 - 92,
                            child: TextField(
                              onChanged: (v) {
                                if (v != null && v != "") {
                                  valueText = v;
                                }
                              },
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.send,
                              minLines: 1,
                              maxLines: 5,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  hintText: "说点什么吧~",
                                  hintStyle: TextStyle(fontSize: 15.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color:
                                            Color.fromRGBO(238, 238, 238, 1)))),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 3.0),
                            width: MediaQuery.of(context).size.width,
                            height: 48.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    constraints: BoxConstraints(minWidth: 20.0),
                                    height: 30.0,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 3.0),
                                    child: Text(
                                      " 评 论 ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(75, 152, 244, 1),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ))),
            onTap: () {
              Get.back(result: valueText);
            },
          );
        }).then((value) {
      if (value != null) {
        print("$value---->replyTo:$replyTo----->belongTo:$inWhereIndex");
        model.addComment(value, replyTo, inWhereIndex);
      }
    });
  }

  Widget _getMsgNode(MarketListDetailProvide model) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 10.0),
      child: Column(
        children: <Widget>[
          _buildVideo(model.marketModel),
          SizedBox(height: 20.0),
          _buildImageGrid(model.marketModel),
        ],
      ),
    );
  }

  // 视频
  Widget _buildVideo(MarketPostModel postModel) {
    if (postModel.publishTypeId == 2) {
      // 1 图片+文字；2 视频+文字
      List<MarketPostMediaModel> mediaList = postModel.marketWorksList;
      if (mediaList.length > 0) {
        MarketPostMediaModel mediaItem = mediaList[0];
        print(mediaItem.coverUrl);
        print(mediaItem.worksUrl);
        return Container(
          alignment: Alignment.centerLeft,
          child: MarketListPlayer(
            mediaItem.coverUrl,
            mediaItem.worksUrl,
            widthFlag: true,
          ),
        );
      }
    }

    return SizedBox.shrink();
  }

  // 图片列表
  Widget _buildImageGrid(MarketPostModel listItem) {
    List<MarketPostMediaModel> mediaList = listItem.marketWorksList;
    int numCount = 3;
    if (listItem.publishTypeId == 1 && mediaList.length > 0) {
      if (mediaList.length < 3) {
        numCount = mediaList.length;
      }

      List<String> mListUrl = mediaList.map((e) {
        return e.worksUrl;
      }).toList();
      int index = -1;
      return GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: numCount,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1),
        children: mediaList.map((MarketPostMediaModel mediaModel) {
          index++;
          int position = index;
          return GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                  imageUrl: mediaModel.worksUrl ?? "", fit: BoxFit.cover),
            ),
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Get.to(ImageBig(
                mListUrl,
                index: position,
              ));
            },
          );
        }).toList(),
      );
    }

    return SizedBox.shrink();
  }
}
