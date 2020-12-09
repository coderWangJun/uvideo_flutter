import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';

class ChooseWorkNameProvider with ChangeNotifier {
  bool isGangWei = true;

  int level = 0;

  List<List> mListOne = [[]];

  init() {
    if (isGangWei) {
      DioUtil.request("/resource/getSubPosition", parameters: {"id": 0})
          .then((value) {
        if (DioUtil.checkRequestResult(value)) {
          mListOne[0] = value["data"] as List;
          notifyListeners();
        }
      });
    } else {
      DioUtil.request("/resource/getSubIndustry", parameters: {"id": 0})
          .then((value) {
        if (DioUtil.checkRequestResult(value)) {
          mListOne[0] = value["data"] as List;
          notifyListeners();
        }
      });
    }
  }

  Future<bool> getNext(int id) async {
    if (isGangWei) {
      var value = await DioUtil.request("/resource/getSubPosition",
          parameters: {"id": id});
      if (DioUtil.checkRequestResult(value)) {
        if (value["data"] != null && value["data"] != "") {
          mListOne.add(value["data"] as List);
          level++;
          notifyListeners();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      var value = await DioUtil.request("/resource/getSubIndustry",
          parameters: {"id": id});
      if (DioUtil.checkRequestResult(value)) {
        if (value["data"] != null && value["data"] != "") {
          mListOne.add(value["data"] as List);
          level++;
          notifyListeners();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
  }

  search(String value) {
    if (isGangWei) {
      DioUtil.request("/resource/searchPosition", parameters: {"name": value})
          .then((value) {
        if (value["data"] != null && value["data"] != "") {
          mListOne.add(value["data"] as List);
          level++;
          notifyListeners();
        } else {
          BotToast.showText(text: "无匹配职业");
        }
      });
    } else {
      DioUtil.request("/resource/searchIndustry", parameters: {"name": value})
          .then((value) {
        if (value["data"] != null && value["data"] != "") {
          mListOne.add(value["data"] as List);
          level++;
          notifyListeners();
        } else {
          BotToast.showText(text: "无匹配行业");
        }
      });
    }
  }

  goBack() {
    level--;
    notifyListeners();
  }
}

class ChooseWorkName extends StatelessWidget {
  bool isGangWeis = true;

  ChooseWorkName({this.isGangWeis = true});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: ChooseWorkNameProvider(),
      onReady: (model) {
        model.isGangWei = isGangWeis;
        model.init();
      },
      builder: (context, model, child) {
        return WillPopScope(
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                  child: AppBar(
                    leading: IconButton(
                      icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon,
                          "nav_back_black.png")),
                      onPressed: () {
                        ///back返回上一步
                        Navigator.of(context)..pop();
                      },
                    ),
                    backgroundColor: Colors.white,
                    elevation: 0,
                    brightness: Brightness.light,
                    title: Text(
                      isGangWeis ? "选择岗位类型" : "选择行业",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          color: Color.fromRGBO(51, 51, 51, 1)),
                    ),
                    centerTitle: true,
                  ),
                  preferredSize: Size(double.infinity, 44.0)),
              body: Container(
                padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 44.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 40.0,
                      height: 27.0,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(238, 238, 238, 1),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.search,
                              size: 15.0, color: Color.fromRGBO(1, 1, 1, 0.5)),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: TextField(
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  hintText: "搜 索",
                                  hintStyle: TextStyle(
                                      color: Color.fromRGBO(1, 1, 1, 0.5),
                                      fontSize: 13.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                              onSubmitted: (value) {
                                //点击搜索
                                model.search(value);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: ListView(children: _getList(context, model))),
                  ],
                ),
              )),
          onWillPop: () async {
            if (model.level == 0) {
              return true;
            } else {
              model.goBack();
              return false;
            }
          },
        );
      },
    );
  }

  List<Widget> _getList(BuildContext context, ChooseWorkNameProvider model) {
    List data = model.mListOne[model.level];
    if (data == null) {
      return <Widget>[];
    }
    List<Widget> items = data.map((element) {
      return _getItem(context, model, element);
    }).toList();
    return items;
  }

  Widget _getItem(BuildContext context, ChooseWorkNameProvider model, Map map) {
    bool flagShow = true;
    if (model.level != 0) {
      flagShow = false;
    }
    return Center(
        child: GestureDetector(
      child: Container(
          height: 50.0,
          width: 360,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1)))),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                map["skillName"],
                style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1), fontSize: 13.0),
              )),
              flagShow
                  ? Image.asset(
                      join(AssetsUtil.assetsDirectoryCommon,
                          "icon_forward_normal.png"),
                      width: 5.0,
                    )
                  : SizedBox(
                      width: 5.0,
                    ),
            ],
          )),
      onTap: () {
        //点击item
        model.getNext(map["id"] as num).then((flag) {
          if (!flag) {
            Navigator.of(context)..pop(map);
          }
        });
      },
    ));
  }
}
