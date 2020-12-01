import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/widgets/empty_widget.dart';

class ShortVideoManage extends StatefulWidget {
  @override
  _ShortVideoManageState createState() => _ShortVideoManageState();
}

class _ShortVideoManageState extends State<ShortVideoManage> {
  bool _editting = false;
  bool _selectAll = false;

  List<ShortVideoModel> _videoModelList = [];

  @override
  void initState() {
    super.initState();

    _loadShortVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWhite(title: "作品管理", actions: <Widget>[
        _videoModelList.length > 0 ? FlatButton(
          padding: EdgeInsets.all(0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Text(_editting ? "取消" : "编辑", style: TextStyle(fontSize: 15, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
          onPressed: () {
            setState(() {
              _editting = !_editting;
            });
          },
        ) : SizedBox.shrink()
      ]),
      body: _videoModelList.length == 0 ? EmptyWidget() : Column(
        children: <Widget>[
          Expanded(
              child: _buildVideoList()
          ),
          _editting ? _buildButtonWidgets(context) : SizedBox.shrink()
        ],
      ),
    );
  }

  Widget _buildVideoList() {
    double gridWidth = (ScreenUtil.mediaQueryData.size.width - 50) / 2;
    double gridHeight = 195;
    double aspectRatio = gridWidth / gridHeight;

    return GridView.builder(
        padding: EdgeInsets.all(20),
        itemCount: _videoModelList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: aspectRatio
        ),
        itemBuilder: (BuildContext context, int index) {
          ShortVideoModel videoModel = _videoModelList[index];

          return InkWell(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorConstants.dividerColor.withOpacity(0.5))
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                          child: CachedNetworkImage(
                            imageUrl: videoModel.coverUrl ?? "",
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        _editting ? Positioned(
                          top: 10,
                          right: 10,
                          child: Image.asset(join(AssetsUtil.assetsDirectoryCommon, videoModel.selected ? "radio_checked.png" : "radio_unchecked.png")),
                        ) : SizedBox.shrink()
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 56,
                    padding: EdgeInsets.symmetric(horizontal: 4.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(videoModel.title, style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
                        Text("发布于${videoModel.createdTime != null ? videoModel.createdTime.substring(5, 10) : ''}", style: TextStyle(fontSize: 13, color: Color.fromRGBO(136, 136, 136, 1)))
                      ],
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              if (_editting) {
                _videoModelList[index].selected = !_videoModelList[index].selected;
              } else {

              }

              setState(() { });
            },
          );
        }
    );
  }

  Widget _buildButtonWidgets(parentContext) {
    int selectedCount = 0;
    String deleteButtonTitle = "删除";
    for (ShortVideoModel videoModel in _videoModelList) {
      if (videoModel.selected) {
        selectedCount++;
      }
    }

    if (selectedCount > 0) {
      deleteButtonTitle += "($selectedCount)";
    }

    return Container(
      height: 65,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: ColorConstants.dividerColor.withOpacity(0.5), width: 1))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Row(
              children: <Widget>[
                Image.asset(join(AssetsUtil.assetsDirectoryCommon, _selectAll ? "radio_checked.png" : "radio_unchecked.png")),
                SizedBox(width: 9),
                Text("全选", style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold))
              ],
            ),
            onTap: () {
              setState(() {
                _selectAll = !_selectAll;

                for (ShortVideoModel videoModel in _videoModelList) {
                  videoModel.selected = _selectAll;
                }
              });
            },
          ),
          Row(
            children: <Widget>[
              _buildButton(deleteButtonTitle, _deleteSelectedVideosAction, parentContext)
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildButton(title, fun, parentContext) {
    return InkWell(
      child: Container(
        width: 66,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: ColorConstants.themeColorBlue,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Text(title, style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      onTap: () {
        fun(parentContext);
      },
    );
  }

  // 删除视频
  void _deleteSelectedVideosAction(parentContext) {
    List<int> selectedIds = [];

    for (ShortVideoModel videoModel in _videoModelList) {
      if (videoModel.selected) {
        selectedIds.add(videoModel.id);
      }
    }

    if (selectedIds.length == 0) {
      BotToast.showText(text: "请选择视频文件");
      return;
    }

    showDialog(context: parentContext, builder: (BuildContext context) {
      return AlertDialog(
        title: Text("温馨提示"),
        content: Text("确定要删除吗？"),
        actions: <Widget>[
          FlatButton(
            child: Text("确定"),
            onPressed: () {
              Get.back();
              _deleteSelectedVideosRequest(selectedIds);
            },
          ),
          FlatButton(
            child: Text("取消"),
            onPressed: () {
              Get.back();
            },
          )
        ],
      );
    });
  }

  // 加载视频列表
  void _loadShortVideos() {
    var params = {"queryType": 1};
    DioUtil.request('/user/getMediaWorks', parameters: params).then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: false);
      if (success) {
        _videoModelList.clear();

        List<dynamic> dataList = responseData["data"];
        List<ShortVideoModel> modelList = dataList.map((json) {
          ShortVideoModel videoModel = ShortVideoModel.fromJson(json);
          videoModel.selected = false;
          return videoModel;
        }).toList();

        _videoModelList.addAll(modelList);
      }

      setState(() { });
    });
  }

  // 删除视频
  void _deleteSelectedVideosRequest(selectedIds) {
    BotToast.showLoading();
    DioUtil.request("/user/deleteUserMediaWorksBatch", parameters: selectedIds).then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData);
      if (success) {
        BotToast.showText(text: responseData["msg"]);
        _loadShortVideos();
      }
    }).whenComplete(() => BotToast.closeAllLoading());
  }
}