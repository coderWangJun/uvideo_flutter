import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as GetRequest;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/friend_model.dart';
import 'package:youpinapp/pages/publish/choose_circle_route.dart';
import 'package:youpinapp/pages/publish/choose_location_route.dart';
import 'package:youpinapp/pages/publish/choose_market_priv.dart';
import 'package:youpinapp/pages/publish/publish_at_friends.dart';
import 'package:youpinapp/pages/publish/publish_ucoin_dialog.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/ossUpload.dart';

class PublishMarketPost extends StatefulWidget {
  final int publishType; // 1 发布图文；2 发布视频
  final int typeId; // 	圈子类型id，12345对应推荐、校友、同乡、行业、创业
  final int circleId; // 圈子ID

  PublishMarketPost(this.publishType, this.typeId, {this.circleId});

  @override
  _PublishMarketPostState createState() => _PublishMarketPostState();
}

class _PublishMarketPostState extends State<PublishMarketPost> {
  List<File> _pickedImageFiles = [];
  File _pickedVideoFile;
  String _videoThumbPath;

  FriendModel _atFriendModel;
  Map<String, dynamic> _locationMap;
  Map<String, dynamic> _privMap;
  Map<String, dynamic> _selectedCircleMap;
  TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                    child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('输入想发布的内容标题如是提问请以问号结尾',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black)),
                        _buildTextField(),
                      ]),
                )),
                widget.publishType == 1
                    ? _buildImageGrid()
                    : _buildVideoWidget(),
                _buildMenus(),
                _buildPublishButtons(context)
              ],
            )));
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size(double.infinity, 44),
      child: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
              join(AssetsUtil.assetsDirectoryCommon, 'nav_back_black.png')),
          onPressed: () {
            GetRequest.Get.back();
          },
        ),
        actions: <Widget>[
//          FlatButton(
//            child: Text('存为草稿', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
//            onPressed: () {
//              print('存为草稿');
//            },
//          )
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color.fromRGBO(238, 238, 238, 0.5)),
      child: Column(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            Container(
                width: 24,
                height: 24,
                margin: EdgeInsets.only(top: 5, right: 3),
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Image.asset(join(AssetsUtil.assetsDirectoryCircle,
                      'publish_content_clear.png')),
                ))
          ]),
          Container(
              margin: EdgeInsets.only(left: 13, right: 13, bottom: 13),
              child: TextField(
                  controller: _textController,
                  maxLines: 3,
                  style: TextStyle(
                      fontSize: 13, color: ColorConstants.textColor51),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0),
                      hintText: '平台使用补充说明，仅新用户第一次发布提示',
                      hintStyle: TextStyle(
                          fontSize: 13, color: Colors.black.withOpacity(0.5)))))
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return SliverPadding(
      padding: EdgeInsets.all(20),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.92),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return InkWell(
            child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(238, 238, 238, 0.5),
                    borderRadius: BorderRadius.circular(8)),
                child: index == _pickedImageFiles.length
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(join(AssetsUtil.assetsDirectoryCircle,
                              'publish_take_photo.png')),
                          SizedBox(height: 10),
                          Text("照片",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black.withOpacity(0.5)))
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Image.file(_pickedImageFiles[index],
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover),
                            Positioned(
                                top: 3,
                                right: 5,
                                child: ButtonTheme(
                                  minWidth: 0,
                                  height: 0,
                                  child: FlatButton(
                                    padding: EdgeInsets.all(5),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    child: Image.asset(
                                        imagePath("common", "alert_close.png")),
                                    onPressed: () {
                                      setState(() {
                                        _pickedImageFiles.removeAt(index);
                                      });
                                    },
                                  ),
                                )),
                          ],
                        ))),
            onTap: () async {
              if (index == _pickedImageFiles.length) {
                var pickedFile =
                    await ImagePicker.pickImage(source: ImageSource.gallery);

                if (pickedFile != null) {
                  _pickedImageFiles.add(pickedFile);
                  setState(() {});
                }
              }
            },
          );
        }, childCount: _pickedImageFiles.length + 1),
      ),
    );
  }

  Widget _buildVideoWidget() {
    double videoWidth = (ScreenUtil.mediaQueryData.size.width - 60) / 3;
    double videoHeight = videoWidth * 1.1;

    return SliverToBoxAdapter(
        child: UnconstrainedBox(
      alignment: Alignment.centerLeft,
      child: InkWell(
        child: Container(
            width: videoWidth,
            height: videoHeight,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Color.fromRGBO(238, 238, 238, 0.5),
                borderRadius: BorderRadius.circular(8)),
            child: _videoThumbPath == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(join(AssetsUtil.assetsDirectoryCircle,
                          'publish_take_photo.png')),
                      SizedBox(height: 10),
                      Text("视频",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black.withOpacity(0.5)))
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(File(_videoThumbPath), fit: BoxFit.cover),
                  )),
        onTap: () async {
          var pickedFile =
              await ImagePicker.pickVideo(source: ImageSource.gallery);

          if (pickedFile != null) {
            _pickedVideoFile = pickedFile;
            _videoThumbPath = await VideoThumbnail.thumbnailFile(
                video: _pickedVideoFile.path);

            setState(() {});
          }
        },
      ),
    ));
  }

  Widget _buildMenus() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
//          Map<String, dynamic> menuMap = _publishMenus[index];
//
//          return InkWell(
//            child: Container(
//              height: 50,
//              padding: EdgeInsets.only(left: 20, right: 20),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//                  Row(
//                    children: <Widget>[
//                      menuMap['icon'],
//                      SizedBox(width: 10),
//                      Text(menuMap['title'], style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600))
//                    ],
//                  ),
//                  Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_forward_small.png'))
//                ],
//              ),
//            ),
//            onTap: () {
//              if (index == 0) { // @提及
//                GetRequest.Get.to(PublishAtFriends()).then((friendModel) {
//                  setState(() {
//                    _atFriendModel = friendModel;
//                  });
//                });
//              } else if (index == 1) { // 所在位置
//                GetRequest.Get.to(PublishChooseLocation());
//              } else if (index == 2) { // 添加圈层
//                GetRequest.Get.to(PublishChooseCircle());
//              } else if (index == 3) { // 谁可以看
//                GetRequest.Get.to(PublishChossePriv());
//              }
//            },
//          );
        if (index == 0) {
          return _buildAtFriendMenu();
        } else if (index == 1) {
          return _buildLocationMenu();
        } else if (index == 2) {
          return widget.circleId != null
              ? SizedBox.shrink()
              : _buildCircleMenu();
        } else if (index == 3) {
          return _buildLookMenu();
        }

        return SizedBox.shrink();
      }, childCount: 4),
    );
  }

  Widget _buildAtFriendMenu() {
    return InkWell(
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(imagePath(
                    "publish",
                    _atFriendModel != null
                        ? "publish_menu_at1.png"
                        : "publish_menu_at.png")),
                SizedBox(width: 10),
                Text(
                    _atFriendModel != null
                        ? "@${_atFriendModel.targetNickname}"
                        : "@提及",
                    style: TextStyle(
                        fontSize: 15,
                        color: _atFriendModel != null
                            ? ColorConstants.themeColorBlue
                            : Colors.black,
                        fontWeight: FontWeight.w600))
              ],
            ),
            Image.asset(imagePath("common", "icon_forward_small.png"))
          ],
        ),
      ),
      onTap: () {
        FocusManager.instance.primaryFocus.unfocus();
        GetRequest.Get.to(PublishAtFriends(selectedFriendModel: _atFriendModel))
            .then((friendModel) {
          setState(() {
            _atFriendModel = friendModel;
          });
        });
      },
    );
  }

  Widget _buildLocationMenu() {
    return InkWell(
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(imagePath(
                    "publish",
                    _locationMap != null
                        ? "publish_menu_area1.png"
                        : "publish_menu_area.png")),
                SizedBox(width: 10),
                Text(_locationMap != null ? _locationMap["title"] : "所在位置",
                    style: TextStyle(
                        fontSize: 15,
                        color: _locationMap != null
                            ? ColorConstants.themeColorBlue
                            : Colors.black,
                        fontWeight: FontWeight.w600))
              ],
            ),
            Image.asset(imagePath("common", "icon_forward_small.png"))
          ],
        ),
      ),
      onTap: () {
        FocusManager.instance.primaryFocus.unfocus();
        GetRequest.Get.to(ChooseLocationRoute()).then((location) {
          setState(() {
            _locationMap = location;
          });
        });
      },
    );
  }

  Widget _buildCircleMenu() {
    Widget iconWidget =
        Image.asset(imagePath("publish", "publish_menu_tag.png"));
    if (_selectedCircleMap != null) {
      iconWidget = ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.asset(imagePath("publish", "publish_menu_tag.png"),
            color: ColorConstants.themeColorBlue,
            colorBlendMode: BlendMode.colorDodge),
      );
    }

    return InkWell(
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                iconWidget,
                SizedBox(width: 10),
                Text(
                    _selectedCircleMap != null
                        ? _selectedCircleMap["circleName"]
                        : "添加圈层",
                    style: TextStyle(
                        fontSize: 15,
                        color: _selectedCircleMap != null
                            ? ColorConstants.themeColorBlue
                            : Colors.black,
                        fontWeight: FontWeight.w600))
              ],
            ),
            Image.asset(imagePath("common", "icon_forward_small.png"))
          ],
        ),
      ),
      onTap: () {
        int selectedCircleId =
            _selectedCircleMap == null ? -1 : _selectedCircleMap["circleId"];

        FocusManager.instance.primaryFocus.unfocus();
        GetRequest.Get.to(ChooseCircleRoute(initialCircleId: selectedCircleId))
            .then((circleMap) {
          if (circleMap != null) {
            setState(() {
              _selectedCircleMap = circleMap;
            });
          }
        });
      },
    );
  }

  Widget _buildLookMenu() {
    Widget iconWidget =
        Image.asset(imagePath("publish", "publish_menu_pri.png"));
    if (_privMap != null) {
      iconWidget = ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.asset(imagePath("publish", "publish_menu_pri.png"),
            color: ColorConstants.themeColorBlue,
            colorBlendMode: BlendMode.colorDodge),
      );
    }

    return InkWell(
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                iconWidget,
                SizedBox(width: 10),
                Text(_privMap != null ? _privMap["title"] : "谁可以看",
                    style: TextStyle(
                        fontSize: 15,
                        color: _privMap != null
                            ? ColorConstants.themeColorBlue
                            : Colors.black,
                        fontWeight: FontWeight.w600))
              ],
            ),
            Image.asset(imagePath("common", "icon_forward_small.png"))
          ],
        ),
      ),
      onTap: () {
        int initialIndex = -1;
        if (_privMap != null) {
          initialIndex = _privMap["index"];
        }

        FocusManager.instance.primaryFocus.unfocus();
        GetRequest.Get.to(ChooseMarketPriv(initialIndex: initialIndex))
            .then((result) {
          if (result != null) {
            setState(() => _privMap = result);
          }
        });
      },
    );
  }

  Widget _buildPublishButtons(parentContext) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: InkWell(
                child: Container(
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(153, 153, 153, 0.2),
                      borderRadius: BorderRadius.circular(16)),
                  child: Text('普通发布',
                      style: TextStyle(
                          fontSize: 17,
                          color: Color.fromRGBO(153, 153, 153, 1))),
                ),
                onTap: () {
                  _uploadAndSavePost(0);
                },
              ),
            ),
            SizedBox(width: 55),
            Expanded(
              child: InkWell(
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                      color: ColorConstants.themeColorBlue,
                      borderRadius: BorderRadius.circular(16)),
                  alignment: Alignment.center,
                  child: Text('有奖发布',
                      style: TextStyle(fontSize: 17, color: Colors.white)),
                ),
                onTap: () async {
                  int ucoin =
                      await PublishUcoinDialog.showUcoinDialog(parentContext);
                  if (ucoin != null && ucoin > 0) {
                    _uploadAndSavePost(ucoin);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _uploadAndSavePost(int ucoin) {
    FocusManager.instance.primaryFocus.unfocus();

    String content = _textController.text;
    if (content == "") {
      BotToast.showText(text: "请输入内容");
      return;
    }

    if (widget.publishType == 2 && _pickedVideoFile == null) {
      BotToast.showText(text: "请选择或拍摄视频");
      return;
    }

    Map<String, dynamic> params = {};
    params["marketTypeId"] = 1;
    params["publishTypeId"] = widget.publishType;
    params["content"] = content;

    // @好友
    if (_atFriendModel != null) {
      params["atUseridsList"] = [_atFriendModel.userid];
    }

    // 坐标
    if (_locationMap != null) {
      params["longitude"] = _locationMap["lng"];
      params["latitude"] = _locationMap["lat"];
      params["cityName"] = _locationMap["city"];
    }

    // 所属圈子
    if (widget.circleId != null) {
      params["marketCircleId"] = widget.circleId;
    } else {
      if (_selectedCircleMap != null) {
        params["marketCircleId"] = _selectedCircleMap["circleId"];
      }
    }

    // 隐私权限
    if (_privMap != null) {
      params["privacy"] = _privMap["index"];
    }

    // U币
    if (ucoin > 0) {
      params["ucoinAmount"] = ucoin;
    }

    if (widget.publishType == 1) {
      if (_pickedImageFiles.length > 0) {
        // 批量上传图片
        FormData formData = FormData.fromMap({});
        for (File file in _pickedImageFiles) {
          formData.files
              .add(MapEntry("fileList", MultipartFile.fromFileSync(file.path)));
        }

        BotToast.showLoading();
        DioUtil.request("/market/uploadPicWorks", parameters: formData)
            .then((response) {
          bool success = DioUtil.checkRequestResult(response, showToast: true);
          if (success) {
            // 上传成功，开始保存
            params["marketWorksList"] = response["data"];
            _savePostAfterSave(params);
          } else {
            BotToast.closeAllLoading();
          }
        }).catchError(() => BotToast.closeAllLoading());
      } else {
        // 没有图片直接保存
        _savePostAfterSave(params);
      }
    } else {
      BotToast.showLoading();
      params["marketWorksList"] = [{}];
      // 上传视频
      OssUpLoad.upLoad(
              _videoThumbPath, UpFileType.image, UpFileUrlType.marketCoverImage)
          .then((value) {
        if (value != null) {
          params["marketWorksList"][0]['ossCoverName'] = value.fileOssName;
          params["marketWorksList"][0]['coverUrl'] = value.fileURL;
          OssUpLoad.upLoad(_pickedVideoFile.path, UpFileType.video,
                  UpFileUrlType.marketVideo)
              .then((value) {
            if (value != null) {
              params["marketWorksList"][0]['ossName'] = value.fileOssName;
              params["marketWorksList"][0]['worksUrl'] = value.fileURL;
              _savePostAfterSave(params);
            } else {
              errorHandler();
            }
          });
        } else {
          errorHandler();
        }
      });

//      FormData formData = FormData.fromMap({
//        "cover": MultipartFile.fromFileSync(_videoThumbPath),
//        "video": MultipartFile.fromFileSync(_pickedVideoFile.path)
//      });
//
//      BotToast.showLoading();
//      DioUtil.request("/market/uploadMediaWorks", parameters: formData).then((response) {
//        bool success = DioUtil.checkRequestResult(response, showToast: true);
//        if (success) {
//          // 上传成功，开始保存
//          _savePostAfterSave(params);
//        } else {
//          BotToast.closeAllLoading();
//        }
//      }).catchError((error) => BotToast.closeAllLoading());

    }
  }

  void errorHandler() {
    BotToast.closeAllLoading();
  }

  void _savePostAfterSave(Map<String, dynamic> params) {
    DioUtil.request("/market/updateMarket", parameters: params)
        .then((response) {
      bool success = DioUtil.checkRequestResult(response, showToast: true);
      if (success) {
        BotToast.showText(text: response["msg"]);
        GetRequest.Get.back();
      }
    }).whenComplete(() => BotToast.closeAllLoading());
  }
}
