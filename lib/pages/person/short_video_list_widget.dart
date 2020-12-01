import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/mine/short_video_manage.dart';
import 'package:youpinapp/pages/person/user_detail_route.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/widgets/custom_notification.dart';
import 'package:youpinapp/widgets/single_video_player.dart';

class ShortVideoListWidget extends StatefulWidget {
  final String userId;
  final UserDetailShowMode showMode; // 显示模式

  ShortVideoListWidget({this.userId, this.showMode = UserDetailShowMode.light});

  @override
  _ShortVideoListWidgetState createState() => _ShortVideoListWidgetState();
}

class _ShortVideoListWidgetState extends State<ShortVideoListWidget> {
  int _categoryIndex = 0;
  List<String> _categoryTitles = ["全部", "收费"];
  List<ShowreelModel> _myShotVideoList = [];

  @override
  void initState() {
    super.initState();

    // 加载我的短视频
    _loadShortVideos();
  }

  @override
  Widget build(BuildContext context) {
    CustomNotification(_myShotVideoList).dispatch(context);

    return Container(
      color: widget.showMode == UserDetailShowMode.dark ? ColorConstants.backgroundColor33 : Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: _buildCategoryList(),
              ),
              widget.userId == null ? FlatButton.icon(
                icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_modify_black.png')),
                label: Text('编辑'),
                onPressed: () {
                  Get.to(ShortVideoManage());
                },
              ) : SizedBox.shrink()
            ],
          ),
          Expanded(
            child: _buildGridView(),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    var selectedBackgroundColor;
    var normalTextColor;
    var selectedTextColor;
    if (widget.showMode == UserDetailShowMode.dark) { // 深色模式
      selectedBackgroundColor = Color.fromRGBO(75, 152, 244, 0.5);
      normalTextColor = Colors.white;
      selectedTextColor = Colors.white;
    } else { // 浅色模式
      selectedBackgroundColor = Color.fromRGBO(238, 238, 238, 0.5);
      normalTextColor = ColorConstants.textColor51.withOpacity(0.5);
      selectedTextColor = ColorConstants.textColor51;
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _categoryTitles.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: UnconstrainedBox(
              child: Container(
//                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                width: 60,
                height: 20,
                margin: EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  color: _categoryIndex == index ? selectedBackgroundColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text(_categoryTitles[index], style: TextStyle(fontSize: 13, color: _categoryIndex == index ? selectedTextColor : normalTextColor)),
                ),
              ),
            ),
            onTap: () {
              _categoryIndex = index;
              _loadShortVideos();

              setState(() { });
            },
          );
        },
      ),
    );
  }

  Widget _buildGridView() {
    if (_myShotVideoList.length > 0) {
      // 调试时模拟器的宽度是178
      double gridWidth = (ScreenUtil.mediaQueryData.size.width - 55) / 2;
      double gridHeight = 225;
      double widthScale = gridWidth / gridHeight;

      return GridView.builder(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: widthScale
          ),
          itemCount: _myShotVideoList != null ? _myShotVideoList.length : 0,
          itemBuilder: (BuildContext context, int index) {
            var shortVideoModel = _myShotVideoList[index];

            return InkWell(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                        child: CachedNetworkImage(
                          imageUrl: shortVideoModel.coverUrl ?? "",
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 58,
                      padding: EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.05), width: 1),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(shortVideoModel.title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Color.fromRGBO(1, 1, 1, 1), fontWeight: FontWeight.bold)),
                          Text("发布于${shortVideoModel.createdTime.substring(5, 10)}", style: TextStyle(fontSize: 13, color: Color.fromRGBO(136, 136, 136, 1)))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              onTap: () {
                Get.to(SingleVideoPlayer(shortVideoModel.worksUrl));
              },
            );
          }
      );
    } else {
      return SizedBox.shrink();
    }
  }

  void _loadShortVideos() {
    var params = {"queryType": "1"};

    if (widget.userId != null) {
      params["userid"] = widget.userId;
    }

    if (_categoryIndex == 1) {
      params["needUcoin"] = "2";
    }

    DioUtil.request("/user/getMediaWorks", parameters: params).then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: false);

      if (success) {
        if (_myShotVideoList == null) {
          _myShotVideoList = [];
        } else {
          _myShotVideoList.clear();
        }

        List<dynamic> dataList = responseData['data'];
        List<ShowreelModel> videoList = dataList.map((json) {
          return ShowreelModel.fromJson(json);
        }).toList();

        _myShotVideoList.addAll(videoList);
      }

      setState(() { });
    });
  }
}