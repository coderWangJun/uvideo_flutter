import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';

class VideoCommentDialog extends StatefulWidget {
  final ShortVideoModel videoModel;

  VideoCommentDialog({this.videoModel});

  @override
  _VideoCommentDialogState createState() => _VideoCommentDialogState();

  static void show(context, videoModel) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.7,
        child: VideoCommentDialog(videoModel: videoModel),
      );
    });
  }
}

class _VideoCommentDialogState extends State<VideoCommentDialog> {
  int _currentPage = 1;
  String _placeholderString = "说点什么吧~";
  ShortVideoCommentModel _currentCommentModel;
  TextEditingController _textEditingController = new TextEditingController();
  List<ShortVideoCommentModel> _commentList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadCommentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      //resizeToAvoidBottomPadding: true, 设置为false不会跟随键盘移动
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 36),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
            ),
            child: Column(
              children: <Widget>[
                _buildTitleWidget(),
                Expanded(
                  child: _buildListWidget(),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            width: ScreenUtil.mediaQueryData.size.width,
            child: _buildInputWidget(),
          )
        ],
      ),
    );
  }

  Widget _buildTitleWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color.fromRGBO(229, 229, 229, 0.5)))
      ),
      child: Row(
        children: <Widget>[
          SizedBox(width: 52),
          Expanded(
            child: Text("${_commentList.length}条评论", textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            width: 52,
            child: FlatButton(
              child: Image.asset(AssetsUtil.pathForAsset(AssetsUtil.assetsDirectoryHome, "comment_close.png")),
              onPressed: () {
                Get.back();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListWidget() {
    return ListView.separated(
      //padding: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      itemCount: _commentList.length,
      itemBuilder: (BuildContext context, int index) {
        ShortVideoCommentModel commentModel = _commentList[index];

        return Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: <Widget>[
              _buildContentWidget(1, index, commentModel),
              _buildReplyList(commentModel),
              _buildReplyMoreButton(commentModel)
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(color: ColorConstants.dividerColor, height: 1);
      },
    );
  }

  // 显示评论内容，包括头像、昵称、内容
  // buildType 1 评论内容；2 回复内容
  Widget _buildContentWidget(int buildType, int index, ShortVideoCommentModel commentModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                InkWell(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                            imageUrl: commentModel.headPortrait ?? "",
                            width: buildType == 1 ? 30 : 15,
                            height: buildType == 1 ? 30 : 15,
                            placeholder: (BuildContext context, String url) {
                              return Image.asset(AssetsUtil.pathForAsset(AssetsUtil.assetsDirectoryCommon, "def_avatar.png"), width: buildType == 1 ? 30 : 15, height: buildType == 1 ? 30 : 15);
                            }
                        ),
                      ),
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Row(children: <Widget>[
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(commentModel.name, style: TextStyle(fontSize: 12, color: ColorConstants.textColor153)),
                                      SizedBox(height: 5),
                                      Text.rich(TextSpan(
                                          children: [
                                            TextSpan(text: commentModel.content, style: TextStyle(fontSize: 14, color: Color.fromRGBO(59, 63, 61, 1))),
                                            TextSpan(text: " ${commentModel.createdTime.substring(5, 10)}", style: TextStyle(fontSize: 12, color: ColorConstants.textColor153))
                                          ]
                                      ))
                                    ],
                                  ),
                                ),
                                InkWell(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(AssetsUtil.pathForAsset(AssetsUtil.assetsDirectoryHome, commentModel.isLiked == 1 ? "comment_like.png" : "comment_not_like.png")),
                                      SizedBox(height: 3),
                                      Text("${commentModel.likes}", style: TextStyle(fontSize: 11, color: Color.fromRGBO(102, 102, 102, 1)))
                                    ],
                                  ),
                                  onTap: () {
                                    _addCommentLike(index);
                                  },
                                )
                              ]
                              )
                          )
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _placeholderString = "回复@${commentModel.replyName}:";
                      _currentCommentModel = commentModel;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyList(ShortVideoCommentModel commentModel) {
    List<ShortVideoCommentModel> replyList = commentModel.replyList;
    if (replyList != null && replyList.length > 0) {
      List<Widget> listWidgets = [];
      for (int i = 0; i < replyList.length; i++) {
        ShortVideoCommentModel commentReplyModel = commentModel.replyList[i];
        listWidgets.add(_buildContentWidget(2, i, commentReplyModel));
      }

      return Container(
        padding: EdgeInsets.only(left: 35),
        child: Column(
          children: listWidgets,
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildReplyMoreButton(ShortVideoCommentModel commentModel) {
    if (commentModel.numberOfComments > 0) {
      return InkWell(
        child: Container(
          margin: EdgeInsets.only(left: 43, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 26,
                height: 1,
                color: ColorConstants.textColor153,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Text(commentModel.isExpand ? "展开更多回复" : "展开${commentModel.numberOfComments}回复", style: TextStyle(fontSize: 12, color: ColorConstants.textColor153)),
              ),
              Image.asset(AssetsUtil.pathForAsset(AssetsUtil.assetsDirectoryHome, "comment_more_arrow.png"))
            ],
          ),
        ),
        onTap: () {
          if (commentModel.isExpand) {
//            commentModel.isExpand = false;
          } else {
            commentModel.isExpand = true;
          }

          _loadCommentList(parentModel: commentModel);
        },
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildInputWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 15,
            offset: Offset(0, 3)
          )
        ]
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 86
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 238, 238, 1),
                borderRadius: BorderRadius.circular(20)
              ),
              child: TextField(
                controller: _textEditingController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                  border: InputBorder.none,
                  hintText: _placeholderString,
                  hintStyle: TextStyle(fontSize: 14, color: ColorConstants.textColor153)
                ),
              ),
            ),
          ),
          ButtonTheme(
            minWidth: 44,
            child: FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text("发送", style: TextStyle(fontSize: 14, color: ColorConstants.themeColorBlue, fontWeight: FontWeight.bold)),
              onPressed: () {
                FocusManager.instance.primaryFocus.unfocus();
                _sendComment();
              },
            ),
          )
        ],
      ),
    );
  }

  void _sendComment() {
      String content = _textEditingController.text;
      if (content == "") {
        BotToast.showText(text: "请输入评论内容");
        return;
      }

      var params = {"worksId": widget.videoModel.id, "content": content};
      if (_currentCommentModel != null) {
        params["replyTo"] = _currentCommentModel.id;
        params["belongTo"] = _currentCommentModel.belongTo;
      }
      print(params);

    BotToast.showLoading();
    DioUtil.request("/user/updateUserMediaWorksComment", parameters: params).then((response) {
      bool success = DioUtil.checkRequestResult(response);
      if (success) {
        if (_currentCommentModel != null) {
          _currentCommentModel.parentComment.replyCurrentPage = 1;
          _currentCommentModel.parentComment.replyList.clear();
          _loadCommentList(parentModel: _currentCommentModel.parentComment);
        } else {
          _currentPage = 1;
          _commentList.clear();

          _loadCommentList();
        }

        setState(() {
          _placeholderString = "说点什么吧~";
          _currentCommentModel = null;
          _textEditingController.text = "";
        });
      }
    }).whenComplete(() => BotToast.closeAllLoading());
  }

  void _loadCommentList({ShortVideoCommentModel parentModel}) {
    var params = {"worksId": widget.videoModel.id};

    if (parentModel != null) { // 加载回复列表
      params["belongTo"] = parentModel.id;
      params["current"] = parentModel.replyCurrentPage;
      params["size"] = 3;
    } else { // 加载评论列表
      params["current"] = _currentPage;
      params["size"] = 10;
    }
    print(params);

    DioUtil.request("/user/getUserMediaWorksComment", parameters: params).then((response) {
      bool success = DioUtil.checkRequestResult(response, showToast: false);

      if (success) {
        List<dynamic> dataList = response["data"];
        if (dataList != null && dataList.length > 0) {
          List<ShortVideoCommentModel> commentModelList = dataList.map((e) {
            ShortVideoCommentModel replyCommentModel = ShortVideoCommentModel.fromJson(e);
            // 初始化评论列表
            replyCommentModel.isExpand = false;
            replyCommentModel.replyCurrentPage = 1;
            replyCommentModel.parentComment = parentModel;
            replyCommentModel.replyList = [];
            return replyCommentModel;
          }).toList();

          if (parentModel != null) { // 处理回复列表
            parentModel.replyCurrentPage++;
            parentModel.replyList.addAll(commentModelList);
            print(commentModelList);
          } else { // 处理评论列表
            _currentPage++;
            _commentList.addAll(commentModelList);
          }
        }
      }

      setState(() { });
    });
  }

  void _addCommentLike(int index) {
    ShortVideoCommentModel commentModel = _commentList[index];

    var params = {"id": commentModel.id};
    if (commentModel.isLiked == 1) { // 已赞
      params["flag"] = 2; // 取消点赞
    } else { // 未赞
      params["flag"] = 1; // 点赞
    }

    DioUtil.request("/user/updateCommentLikes", parameters: params).then((response) {
      bool success = DioUtil.checkRequestResult(response);
      if (success) {
        if (commentModel.isLiked == 1) {
          commentModel.isLiked = 0;
          commentModel.likes--;
        } else {
          commentModel.isLiked = 1;
          commentModel.likes++;
        }

        _commentList[index] = commentModel;
      }

      setState(() { });
    });
  }
}