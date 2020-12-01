import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';

import '../../widgets/empty_widget.dart';

class NearbyVideoList extends StatefulWidget {
  @override
  _NearbyVideoListState createState() => _NearbyVideoListState();
}

class _NearbyVideoListState extends State<NearbyVideoList> {
  List<ShortVideoModel> _nearbyVideoList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadNearbyVideos();
  }

  @override
  Widget build(BuildContext context) {
    double gridWidth = (ScreenUtil.mediaQueryData.size.width - 45) / 2;
    double gridHeight = 314;
    double aspectRatio = gridWidth / gridHeight;

    return _nearbyVideoList.length == 0 ? EmptyWidget(showTitle: "暂无视频数据") : Container(
      color: Color.fromRGBO(23, 23, 23, 1),
      padding: EdgeInsets.only(top: 80, bottom: 50),
      child: GridView.builder(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        itemCount: _nearbyVideoList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 20,
          childAspectRatio: aspectRatio
        ),
        itemBuilder: (BuildContext context, int index) {
          ShortVideoModel videoModel = _nearbyVideoList[index];

          return Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: videoModel.coverUrl ?? "",
                    width: double.infinity,
                    height: 265,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: double.infinity,
                    height: 265,
                    alignment: Alignment.center,
                    child: Image.asset(join(AssetsUtil.assetsDirectoryHome, 'home_play.png'), width: 40, height: 40),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    width: gridWidth,
                    height: 38,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: <Widget>[
                          Image.asset(join(AssetsUtil.assetsDirectoryCommon, "location.png")),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(videoModel.title, style: TextStyle(fontSize: 14, color: Colors.white)),
                      Text(videoModel.content, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.white))
                    ],
                  ),
                ),
              )
            ],
          );
        }
      ),
    );
  }

  void _loadNearbyVideos() {
    var params = {
      "queryType": 5,
      "longitude": 106.582128,
      "latitude": 29.667359
    };
    DioUtil.request("/user/getMediaWorks", parameters: params).then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData);
      if (success) {
        List<dynamic> dataList = responseData["data"];
        List<ShortVideoModel> modelList = dataList.map((json) {
          return ShortVideoModel.fromJson(json);
        }).toList();
        _nearbyVideoList.addAll(modelList);
      }

      setState(() { });
    });
  }
}