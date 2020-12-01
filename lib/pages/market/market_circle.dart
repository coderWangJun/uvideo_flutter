import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/market/add_market/add_market.dart';
import 'package:youpinapp/pages/market/circle_home.dart';
import 'package:youpinapp/pages/market/circle_more/circle_detail.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';

import '../common/search_bar.dart';

class MarketCircle extends StatefulWidget {
  final int typeId;
  final String typeName;

  MarketCircle(this.typeId, this.typeName);

  @override
  _MarketCircleState createState() => _MarketCircleState();
}

class _MarketCircleState extends State<MarketCircle> with AutomaticKeepAliveClientMixin {
  List<MarketCircleModel> _recommendCircleList = [];
  List<MarketCircleModel> _focusCircleList = [];
  List<MarketCircleModel> _createdCircleList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _loadRecommendCircles();
    _loadFocusCircles();
    _loadCreateCircles();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SearchBar('请输入关键词',onMySubmitted: (value){

          },),
          _buildRecommendCircles(context),
          _buildFocusCircles(),
          _buildCreatedCircles(),
        ],
      ),
    );
  }

  // 相关的校友集
  Widget _buildRecommendCircles(BuildContext topContext) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('推荐与你相关的${widget.typeName}圈子', style: TextStyle(fontSize: 17, color: Color.fromRGBO(1, 1, 1, 1), fontWeight: FontWeight.bold)),
              Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_forward_normal.png'))
            ],
          ),
        ),
        _recommendCircleList.length > 0 ? Container(
          height: 80,
          margin: EdgeInsets.only(top: 15),
          child: ListView.separated(
//            padding: EdgeInsets.only(left: 6, right: 6),
            scrollDirection: Axis.horizontal,
            itemCount: _recommendCircleList.length,
            itemBuilder: (BuildContext context, int index) {
              MarketCircleModel circleModel = _recommendCircleList[index];

              return Container(
                  width: 80,
                  child: ButtonTheme(
                    minWidth: 0,
                    height: 0,
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(238, 238, 238, 0.8)
                              ),
                              child: CachedNetworkImage(
                                imageUrl: circleModel.logoUrl ?? '',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(circleModel.circleName, textAlign: TextAlign.center, overflow:TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: Color.fromRGBO(1, 1, 1, 1), fontWeight: FontWeight.w600)),
                        ],
                      ),
                      onPressed: () {
                        onTapItems(circleModel.id);
                      },
                    ),
                  )
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox.shrink();
            },
          ),
        ) : _buildRecommendPlaceholder()
      ],
    );
  }
  Widget _buildRecommendPlaceholder() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.only(left: 15, right: 15, top: 6, bottom: 6),
        decoration: BoxDecoration(
            border: Border.all(color: Color.fromRGBO(153, 153, 153, 1), width: 1),
            borderRadius: BorderRadius.circular(15)
        ),
        child: Text('暂无推荐圈子，敬请期待~', style: TextStyle(fontSize: 13, color: Color.fromRGBO(153, 153, 153, 1))),
      ),
    );
  }

  // 关注的校友集
  Widget _buildFocusCircles() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('关注的${widget.typeName}圈子', style: TextStyle(fontSize: 17, color: Color.fromRGBO(1, 1, 1, 1), fontWeight: FontWeight.bold)),
          _focusCircleList.length > 0 ? Container(
            height: _focusCircleList.length * 65.0,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: _focusCircleList.map((circleModel) {
                return GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: CachedNetworkImage(
                            imageUrl: circleModel.logoUrl ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(circleModel.circleName, style: TextStyle(fontSize: 15, color: Color.fromRGBO(1, 1, 1, 1), fontWeight: FontWeight.w600)),
                            Text(circleModel.shortContent, style: TextStyle(fontSize: 13, color: ColorConstants.textColor153)),
                          ],
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    onTapItems(circleModel.id);
                  },
                );
              }).toList(),
            ),
          ) : _buildFocusButton()
        ],
      ),
    );
  }
  Widget _buildFocusButton() {
    return Center(
      child: Container(
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              border: Border.all(color: Color.fromRGBO(153, 153, 153, 1), width: 1),
              borderRadius: BorderRadius.circular(15)
          ),
          child: ButtonTheme(
            height: 0,
            child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.only(left: 15, right: 15, top: 6, bottom: 6),
                child: Text('快去关注一个圈子吧~', style: TextStyle(fontSize: 13, color: Color.fromRGBO(153, 153, 153, 1)))
            ),
          )
      ),
    );
  }

  // 创建的集圈
  Widget _buildCreatedCircles() {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height:50.0,child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('创建的${widget.typeName}圈子', style: TextStyle(fontSize: 17, color: Color.fromRGBO(1, 1, 1, 1), fontWeight: FontWeight.bold)),
              IconButton(icon: Icon(Icons.add,size: 30.0,), onPressed: (){
                Get.to(AddMarket(widget.typeId)).then((value){
                  if(value!=null){
                    _loadRecommendCircles();
                    _loadFocusCircles();
                    _loadCreateCircles();
                  }
                });
              }),
          ],),),
          _createdCircleList.length > 0 ? Container(
            height: _createdCircleList.length * 65.0,
            child: ListView(
              padding: EdgeInsets.only(top: 15),
              physics: NeverScrollableScrollPhysics(),
              children: _createdCircleList.map((circleModel) {
                return GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: CachedNetworkImage(
                            imageUrl: circleModel.logoUrl ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(circleModel.circleName??="", style: TextStyle(fontSize: 15, color: Color.fromRGBO(1, 1, 1, 1), fontWeight: FontWeight.w600)),
                            Text(circleModel.shortContent??="", style: TextStyle(fontSize: 13, color: ColorConstants.textColor153)),
                          ],
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    onTapItems(circleModel.id);
                  },
                );
              }).toList(),
            ),
          ) : _buildCreateButton()
        ],
      ),
    );
  }
  Widget _buildCreateButton() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.only(left: 15, right: 15, top: 6, bottom: 6),
        decoration: BoxDecoration(
            border: Border.all(color: Color.fromRGBO(153, 153, 153, 1), width: 1),
            borderRadius: BorderRadius.circular(15)
        ),
        child: ButtonTheme(
          minWidth: 0,
          height: 0,
          child: FlatButton.icon(
            onPressed: (){
              Get.to(AddMarket(widget.typeId));
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            icon: Image.asset(join(AssetsUtil.assetsDirectoryMarket, 'icon_add_circle.png')),
            label: Text('创建自己的圈子', style: TextStyle(fontSize: 13, color: Color.fromRGBO(153, 153, 153, 1))),
          ),
        ),
      ),
    );
  }

  // 加载推荐的圈子
  void _loadRecommendCircles() async {
    var params = {'marketTypeId': widget.typeId};
    DioUtil.request('/market/getRecommendCircle', parameters: params).then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: false);
      if (success) {
        List<dynamic> dataList = responseData['data'];
        _recommendCircleList = dataList.map((marketJson) {
          return MarketCircleModel.fromJson(marketJson);
        }).toList();

        setState(() { });
      }
    });
  }

  // 加载关注的圈子
  void _loadFocusCircles() async {
    var params = {'marketTypeId': widget.typeId};
    DioUtil.request('/market/getUserMarketCircleList', parameters: params).then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: false);
      if (success) {if(responseData['data']!=null){

        List<dynamic> dataList = responseData['data'];
        _focusCircleList = dataList.map((circleJson) {
          return MarketCircleModel.fromJson(circleJson);
        }).toList();

        setState(() { });
      }else{
        _focusCircleList = [];
      }
      }
    });
  }

  // 加载创建的圈子
  void _loadCreateCircles() async {
    var params = {'marketTypeId': widget.typeId};
    DioUtil.request('/market/getCircleCreatedByMe', parameters: params).then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: false);
      if (success) {
        List<dynamic> dataList = responseData['data'];
        if (dataList != null && dataList.length > 0) {
          _createdCircleList = dataList.map((circleJson) {
            return MarketCircleModel.fromJson(circleJson);
          }).toList();
        }

        setState(() { });
      }
    });
  }

  onTapItems(num id){
//    Get.to(CircleHome(id));
      Get.to(CircleDetail(id)).then((value){
        if(value!=null){
          _loadRecommendCircles();
          _loadFocusCircles();
          _loadCreateCircles();
        }
      });
  }

  @override
  void setState(VoidCallback fn) {
    if(mounted){
      super.setState(fn);
    }
  }


}