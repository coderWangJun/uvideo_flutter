import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/player/player_state_provider.dart';
import 'package:youpinapp/pages/player/video_comment_dialog.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/event_bus.dart';

class VideoPlayerBottomWidget extends StatefulWidget {
  final dynamic dataModel;

  VideoPlayerBottomWidget(this.dataModel);

  @override
  _VideoPlayerBottomWidgetState createState() => _VideoPlayerBottomWidgetState();
}

class _VideoPlayerBottomWidgetState extends State<VideoPlayerBottomWidget> {
  ShortVideoModel _videoModel;

  @override
  void didUpdateWidget(VideoPlayerBottomWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    _videoModel = context.read<PlayerStateProvider>().currentVideoModel;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _videoModel = context.read<PlayerStateProvider>().currentVideoModel;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10),
          width: 84.w,
          child: Column(
            children: <Widget>[
              _buildAvatar(),
              _buildPraiseButton(),
              _buildCommentButton(context),
//              _buildShareButton(),
//              _buildLocationButton(),
            ],
          ),
        ),
        _buildDescription()
      ],
    );
  }

  // 头像
  Widget _buildAvatar() {
    String avatarUrl = "";
    if (widget.dataModel is ShortVideoModel) {
      ShortVideoModel videoModel = widget.dataModel as ShortVideoModel;
      avatarUrl = videoModel.headPortraitUrl ?? "";
    } else {
      HomeResumeModel videoModel = widget.dataModel as HomeResumeModel;
      avatarUrl = videoModel.headPortraitUrl ?? "";
    }

    return InkWell(
      child: Container(
        width: 42,
        height: 42,
        margin: EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21)
        ),
        //child: Image.asset(AssetsUtil.pathForAsset(AssetsUtil.assetsDirectoryCommon, 'def_avatar.png')),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: (avatarUrl != null && avatarUrl != "") ? CachedNetworkImage(
            width: 42,
            height: 42,
            imageUrl: avatarUrl ?? "",
            fit: BoxFit.cover,
            placeholder: (BuildContext context, String url) {
              return Image.asset(AssetsUtil.pathForAsset(AssetsUtil.assetsDirectoryCommon, 'def_avatar.png'), width: 42, height: 42);
            },
          ) : SizedBox.shrink(),
        )
      ),
      onTap: () {
        g_eventBus.emit(GlobalEvent.videoPageEvent, 1);
      },
    );
  }

  // 点赞按钮
  Widget _buildPraiseButton() {
    int praiseCount = 0;
    int isPraise = 0; // 0 未赞；1 已赞

    if (widget.dataModel is ShortVideoModel) { // 个人作品视频
      ShortVideoModel videoModel = widget.dataModel as ShortVideoModel;
      isPraise = videoModel.isLiked ?? 0;
      praiseCount = videoModel.likes ?? 0;
    } else {
      HomeResumeModel videoModel = widget.dataModel as HomeResumeModel;
      isPraise = videoModel.isLiked ?? 0;
      praiseCount = videoModel.likes ?? 0;
    }

    return ButtonTheme(
      padding: EdgeInsets.zero,
      minWidth: 0,
      child: FlatButton(
        child: Column(
          children: <Widget>[
            Image.asset(AssetsUtil.pathForAsset(AssetsUtil.assetsDirectoryHome, isPraise == 1 ? "home_praise_red.png" : "home_praise_gray.png")),
            Text("$praiseCount", style: TextStyle(color: Colors.white, fontSize: 22.sp))
          ],
        ),
        onPressed: () {
          if (widget.dataModel is ShortVideoModel) { // 短视频
            var shortVideoModel = widget.dataModel as ShortVideoModel;
            if (shortVideoModel.isLiked == 1) { // 已赞
              _addOrRemovePraiseRequest(2);
            } else { // 未赞
              _addOrRemovePraiseRequest(1);
            }
          }
        },
      ),
    );
  }

  // 评论按钮
  Widget _buildCommentButton(parentContext) {
    int commentCount = 0;
    if (widget.dataModel is ShortVideoModel) {
      var videoModel = widget.dataModel as ShortVideoModel;
      commentCount = videoModel.numberOfComments ?? 0;
    } else {
      var videoModel = widget.dataModel as HomeResumeModel;
      commentCount = videoModel.numberOfComments ?? 0;
    }

    return Container(
      margin: EdgeInsets.only(top: 10.h, right: 2),
      child: ButtonTheme(
        padding: EdgeInsets.zero,
        minWidth: 0,
        height: 0,
        child: FlatButton(
          child: Column(
            children: <Widget>[
              Image.asset(AssetsUtil.pathForAsset(AssetsUtil.assetsDirectoryHome, 'home_comment.png')),
              Text("$commentCount", style: TextStyle(color: Colors.white, fontSize: 11))
            ],
          ),
          onPressed: () {
            if (_videoModel != null) {
              VideoCommentDialog.show(parentContext, _videoModel);
            }
          },
        ),
      ),
    );
  }

  // 分享按钮
  Widget _buildShareButton() {
    int shareCount = 0;
    if (widget.dataModel is ShortVideoModel) {
      var videoModel = widget.dataModel as ShortVideoModel;
      shareCount = videoModel.numberOfForwarding ?? 0;
    } else {
      var videoModel = widget.dataModel as HomeResumeModel;
      shareCount = videoModel.numberOfForwarding ?? 0;
    }

    return Container(
      margin: EdgeInsets.only(top: 10.h, right: 4),
      child: ButtonTheme(
        padding: EdgeInsets.zero,
        minWidth: 0,
        height: 0,
        child: FlatButton(
          child: Column(
            children: <Widget>[
              Image.asset(AssetsUtil.pathForAsset(AssetsUtil.assetsDirectoryHome, 'home_share.png')),
              Text("$shareCount", style: TextStyle(color: Colors.white, fontSize: 22.sp))
            ],
          ),
          onPressed: () {
            print('开始分享');
          },
        ),
      ),
    );
  }

  // 位置按钮
  Widget _buildLocationButton() {
    double distance = 0.0;
    if (widget.dataModel is ShortVideoModel) {
      var videoModel = widget.dataModel as ShortVideoModel;
      distance = videoModel.distance ?? 0;
    } else {
      var videoModel = widget.dataModel as HomeResumeModel;
      distance = videoModel.distanceDouble ?? 0;
    }

    return Container(
      margin: EdgeInsets.only(top: 10.h, right: 6),
      child: ButtonTheme(
        padding: EdgeInsets.zero,
        minWidth: 0,
        height: 0,
        child: FlatButton(
          child: Column(
            children: <Widget>[
              Image.asset(AssetsUtil.pathForAsset(AssetsUtil.assetsDirectoryHome, 'home_locator.png')),
              Text("$distance", style: TextStyle(color: Colors.white, fontSize: 22.sp))
            ],
          ),
          onPressed: () {
            print('显示位置');
          },
        ),
      ),
    );
  }

  // 名字
  Widget _buildDescription() {
    String nickName = '';
    String content = '';
    int needCoin = 1; // 是否需要付费(U币) 1.否 2.是

    if (widget.dataModel is ShortVideoModel) {
      var videoModel = widget.dataModel as ShortVideoModel;
      nickName = videoModel.name ?? "";
      content = videoModel.content;
      needCoin = videoModel.needUcoin;
    } else {
      var videoModel = widget.dataModel as HomeResumeModel;
      nickName = videoModel.nickname ?? videoModel.realname;
      content = videoModel.introduction;
    }

    return Container(
      margin: EdgeInsets.only(top: 30.h, left: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('@$nickName', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.8), fontSize: 30.sp, fontWeight: FontWeight.w600)),
              needCoin == 2 ? Container(
                width: 40,
                height: 18,
                margin: EdgeInsets.only(left: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorConstants.themeColorBlue,
                  borderRadius: BorderRadius.circular(9)
                ),
                child: Text("付费", style: TextStyle(fontSize: 11, color: Colors.white)),
              ) : SizedBox.shrink(),
            ],
          ),
          _buildTagList(),
          (content != null && content != "") ? Container(
            margin: EdgeInsets.only(top: 15.h, bottom: 15.h),
            child: Text(content, style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.8), fontSize: 28.sp, fontWeight: FontWeight.w500)),
          ) : SizedBox.shrink(),
        ],
      )
    );
  }
  Widget _buildTagList() {
    String skillTags; // 技能标签

    if (widget.dataModel is ShortVideoModel) {
      var videoModel = widget.dataModel as ShortVideoModel;
      skillTags = videoModel.skillTags;
    } else {
      var videoModel = widget.dataModel as HomeResumeModel;
      skillTags = videoModel.skillTags;
    }

    if (skillTags != null && skillTags != "") {
      List<String> tagList = skillTags.split(",");
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tagList.map((tag) {
            return Container(
              height: 22,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 9),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(35, 35, 35, 0.5),
                  borderRadius: BorderRadius.circular(11)
              ),
              child: Text(tag, style: TextStyle(fontSize: 11, color: Colors.white)),
            );
          }).toList(),
        ),
      );
    }

    return SizedBox.shrink();
  }

  // operFlag 1 点赞；2 取消点赞
  void _addOrRemovePraiseRequest(int operFlag) {
    if (widget.dataModel is ShortVideoModel) {
      var shortVideoModel = widget.dataModel as ShortVideoModel;
      var params = {"id": shortVideoModel.id, "flag": operFlag};
      DioUtil.request("/user/updateLikes", parameters: params).then((response) {
        bool success = DioUtil.checkRequestResult(response);
        if (success) {
          if (shortVideoModel.isLiked == 1) { // 已赞
            shortVideoModel.isLiked = 0;
            shortVideoModel.likes--;
          } else { // 未赞
            shortVideoModel.isLiked = 1;
            shortVideoModel.likes++;
          }
        }

        setState(() { });
      });
    }
  }
}