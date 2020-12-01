import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/market/market_post_list.dart';
import 'package:youpinapp/utils/dio_util.dart';

class CircleHomePostList extends StatefulWidget {
  final int circleId;

  CircleHomePostList(this.circleId);

  @override
  _CircleHomePostListState createState() => _CircleHomePostListState();
}

class _CircleHomePostListState extends State<CircleHomePostList> {
  List<MarketPostModel> _postList = [];

  @override
  void initState() {
    super.initState();

    _loadCirclePostList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: MarketPostList(_postList,"/market/getMarketList",{'marketCircleId': widget.circleId})
    );
  }

  void _loadCirclePostList() async {
    var params = {'marketCircleId': widget.circleId};
    DioUtil.request('/market/getMarketList', parameters: params).then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData);
      if (success) {
        if(responseData['data']!=null){
          List<dynamic> dataList = responseData['data'];
          setState(() {
            _postList = dataList.map((postJson) {
              return MarketPostModel.fromJson(postJson);
            }).toList();
          });
        }
      }
    });
  }
}