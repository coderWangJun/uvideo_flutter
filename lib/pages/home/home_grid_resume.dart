import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/search.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/player/player_state_provider.dart';
import 'package:youpinapp/pages/player/resume_video_vert_container.dart';
import 'package:youpinapp/pages/player/video_player_hori_resume.dart';
import 'package:youpinapp/pages/home/personal_position.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/widgets/empty_widget.dart';
import 'package:youpinapp/app/account.dart';

class HomeGridResume extends StatefulWidget {
  SearchManager model;
  int cur_index_type; // 0 作品 1 简历 附近

  HomeGridResume(this.model, this.cur_index_type);

  @override
  _HomeGridResumeState createState() => _HomeGridResumeState();
}

class _HomeGridResumeState extends State<HomeGridResume> {
  ScrollController _scrollController;

  /// 判断是否是个人还是企业账户，1=个人，2=企业
  bool _isUserPerson = false;

  @override
  void initState() {
    super.initState();
    _isUserPerson = g_accountManager.currentUser.typeId == 1;
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        widget.model.getMorePage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 调试时模拟器的宽度是178
    double gridWidth = (ScreenUtil.mediaQueryData.size.width - 55) / 2;
    double gridHeight = _isUserPerson ? 170 : 260;
    double widthScale = gridWidth / gridHeight;

    if (widget.model.modelListRes.length > 0) {
      return RefreshIndicator(
        child: GridView(
          controller: _scrollController,
          padding:
              EdgeInsets.only(left: 40.w, right: 40.w, top: 0, bottom: 40.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 30.w,
              mainAxisSpacing: 30.h,
              childAspectRatio: widthScale),
          children: widget.model.modelListRes.asMap().keys.map((index) {
            HomeResumeModel resumeModel = widget.model.modelListRes[index];

            return GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: Color.fromRGBO(239, 239, 239, 1), width: 1)),
                child: _isUserPerson
                    ? _userPerson(
                        index: index,
                        gridWidth: gridWidth,
                        gridHeight: gridHeight,
                        widthScale: widthScale,
                      )
                    : _userCompany(
                        index: index,
                        gridWidth: gridWidth,
                        gridHeight: gridHeight,
                        widthScale: widthScale,
                      ),
              ),
              onTap: () {
                if (_isUserPerson && widget.cur_index_type == 2) {
                  // 个人账户的岗位页面
                  Get.to(PersonalPositionPage(
                    playType: VideoPlayType.resumeVideo,
                    currentResumeModel: resumeModel,
                  ));
                } else {
                  print('cur_index_type========== ${widget.cur_index_type}');
                  Get.to(VideoPlayerHoriResume(VideoPlayType.resumeVideo,
                      currentResumeModel: resumeModel));
                }

//              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
//                return PagedResumePlayer(index);
//              }));
              },
            );
          }).toList(),
        ),
        onRefresh: () async {
          widget.model.getRefresh(widget.cur_index_type);
        },
      );
    } else {
      return Container(
        constraints: BoxConstraints.expand(),
        child: EmptyWidget(
          showTitle: "空空如也",
        ),
      );
    }
  }

  /// 个人账户
  Widget _userPerson({
    @required int index,
    @required double gridWidth,
    @required double gridHeight,
    @required double widthScale,
  }) {
    HomeResumeModel resumeModel = widget.model.modelListRes[index];
    return Column(children: <Widget>[
      Expanded(
        child: Stack(alignment: Alignment.center, children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              child: resumeModel.coverUrl == null
                  ? SizedBox()
                  : CachedNetworkImage(
                      width: gridWidth,
                      height: gridHeight - 70,
                      fit: BoxFit.cover,
                      imageUrl: resumeModel.coverUrl ?? "",
                    )),
          Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'video_play.png'),
              width: 80.w, height: 80.h)
        ]),
      ),
      Container(
        height: 70,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Color.fromRGBO(239, 239, 239, 1), width: 1))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    resumeModel.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Text('${resumeModel.workingYears ?? 0}年',
                //     style: TextStyle(
                //         fontSize: 13, color: ColorConstants.textColor153))
                Container(
                  padding: EdgeInsets.only(
                    left: 10,
                  ),
                  child: Text(resumeModel.salaryTreatmentString ?? '3-8k',
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: ColorConstants.themeColorBlue, fontSize: 15)),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: resumeModel.headPortraitUrl == null ||
                          resumeModel.headPortraitUrl.isEmpty
                      ? Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            borderRadius: BorderRadius.circular(24),
                          ),
                        )
                      : CachedNetworkImage(
                          width: 24,
                          height: 24,
                          imageUrl: resumeModel.headPortraitUrl,
                          placeholder: (BuildContext context, String url) {
                            return Image.asset(
                                join(AssetsUtil.assetsDirectoryCommon,
                                    "def_avatar.png"),
                                width: 24,
                                height: 24);
                          },
                        ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 5,
                  ),
                  child: Text(
                    resumeModel.realname ?? "云达科技",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromRGBO(0, 0, 0, 0.55),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      '10km',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 24.w,
                        color: Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )
    ]);
  }

  /// 企业账户
  Widget _userCompany({
    @required int index,
    @required double gridWidth,
    @required double gridHeight,
    @required double widthScale,
  }) {
    HomeResumeModel resumeModel = widget.model.modelListRes[index];
    return Column(children: <Widget>[
      Expanded(
        child: Stack(alignment: Alignment.center, children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6), topRight: Radius.circular(6)),
              child:
                  resumeModel.coverUrl == null || resumeModel.coverUrl.isEmpty
                      ? Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            borderRadius: BorderRadius.circular(24),
                          ),
                        )
                      : CachedNetworkImage(
                          width: gridWidth,
                          height: gridHeight - 70,
                          fit: BoxFit.cover,
                          imageUrl: resumeModel.coverUrl ?? "",
                        )),
          Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'video_play.png'),
              width: 80.w, height: 80.h)
        ]),
      ),
      Container(
        height: 70,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Color.fromRGBO(239, 239, 239, 1), width: 1))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: resumeModel.headPortraitUrl == null ||
                              resumeModel.headPortraitUrl.isEmpty
                          ? Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0.2),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            )
                          : CachedNetworkImage(
                              width: 24,
                              height: 24,
                              imageUrl: resumeModel.headPortraitUrl ?? "",
                              placeholder: (BuildContext context, String url) {
                                return Image.asset(
                                    join(AssetsUtil.assetsDirectoryCommon,
                                        "def_avatar.png"),
                                    width: 24,
                                    height: 24);
                              },
                            ),
                    ),
                    SizedBox(width: 5),
                    Text(resumeModel.realname ?? "李春玲",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 17,
                            color: ColorConstants.textColor51,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Text('${resumeModel.workingYears ?? 0}年',
                    style: TextStyle(
                        fontSize: 13, color: ColorConstants.textColor153))
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    resumeModel.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color.fromRGBO(102, 102, 102, 1), fontSize: 13),
                  ),
                ),
                Expanded(
                  child: Text(resumeModel.salaryTreatmentString ?? "4-8k",
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: ColorConstants.themeColorBlue, fontSize: 15)),
                )
              ],
            )
          ],
        ),
      )
    ]);
  }
}
