import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/circle_model.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/widgets/empty_widget.dart';

class ChooseCircleRoute extends StatefulWidget {
  final int initialCircleId;

  ChooseCircleRoute({this.initialCircleId});

  @override
  _ChooseCircleRouteState createState() => _ChooseCircleRouteState();
}

class _ChooseCircleRouteState extends State<ChooseCircleRoute> {
  int _currentPage = 1;
  bool _isLoading = false;
  int _selectedCircleId = -1;
  CircleModel _selectedCircleModel;
  List<CircleModel> _circleList = [];
  ScrollController _scrollController;
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    _selectedCircleId = widget.initialCircleId;

    _textEditingController = TextEditingController();

    _scrollController = new ScrollController();
    _scrollController.addListener(() async {
      if (!_isLoading && _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _isLoading = true;
        setState(() { });

        await _loadCircleList();

        _isLoading = false;
        setState(() { });
      }
    });

    _loadCircleList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWhite(
        title: "添加圈集",
        actions: [
          FlatButton(
            child: Text("完成", style: TextStyle(fontSize: 17, color: ColorConstants.textColor51)),
            onPressed: () {
              if (_selectedCircleId == -1) {
                BotToast.showText(text: "请选择圈子");
              } else {
                Map<String, dynamic> resultMap = {};
                resultMap["circleId"] = _selectedCircleId;
                resultMap["circleName"] = _selectedCircleModel.circleName;
                Get.back(result: resultMap);
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          _buildSearchInput(),
          Expanded(
            child: _buildCircleList(),
          )
        ],
      ),
    );
  }

  Widget _buildSearchInput() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      height: 32,
      decoration: BoxDecoration(
        color: Color.fromRGBO(238, 238, 238, 1),
        borderRadius: BorderRadius.circular(16)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.search, color: Color.fromRGBO(140, 140, 140, 1)),
            SizedBox(width: 5),
            Expanded(
              child: TextField(
                controller: _textEditingController,
                style: TextStyle(fontSize: 15, color: ColorConstants.textColor51),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "搜索",
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  hintStyle: TextStyle(fontSize: 15, color: Color.fromRGBO(1, 1, 1, 0.5))
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  _currentPage = 1;
                  _circleList.clear();

                  _loadCircleList();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCircleList() {
    return _circleList.length == 0 ? EmptyWidget() : RefreshIndicator(
      child: ListView.builder(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10),
        itemCount: _circleList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index < _circleList.length) {
            CircleModel circleModel = _circleList[index];

            return InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Image.asset(imagePath("common", _selectedCircleId == circleModel.id ? "radio_checked.png" : "radio_unchecked.png"), width: 25, height: 25, fit: BoxFit.cover),
                    Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CachedNetworkImage(
                          imageUrl: circleModel.logoUrl ?? "",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          placeholder: (BuildContext context, String url) {
                            return Image.asset(imagePath("common", "def_avatar.png"));
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(circleModel.circleName, style: TextStyle(fontSize: 17, color: Color.fromRGBO(52, 52, 52, 1), fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedCircleId = circleModel.id;
                  _selectedCircleModel = circleModel;
                });
              },
            );
          } else {
            if (_isLoading) {
              return Container(
                height: 60,
                alignment: Alignment.center,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return SizedBox();
            }
          }
        }
      ),
      onRefresh: () async {
        // _loadCircleList();
        // return;
        if (!_isLoading) {
          _currentPage = 1;
          _circleList.clear();

          _isLoading = true;
          setState(() { });

          await _loadCircleList();

          _isLoading = false;
          setState(() { });
        }
      },
    );
  }

  Future<void> _loadCircleList() async {
    Map<String, dynamic> params = {"queryList": 1, "current": _currentPage, "size": 100};

    if (_textEditingController.text != "") {
      params["circleName"] = _textEditingController.text;
    }

    var response = await DioUtil.request("/market/getMarketCircleList", parameters: params);
    bool success = DioUtil.checkRequestResult(response);
    if (success) {
      List<dynamic> dataList = response["data"];
      if (dataList != null && dataList.length > 0) {
        _currentPage++;

        List<CircleModel> modelList = dataList.map((e) {
          return CircleModel.fromJson(e);
        }).toList();

        _circleList.addAll(modelList);
      }
    }

    setState(() { });
  }
}