import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/app/search.dart';
import 'package:youpinapp/models/home_company_model.dart';
import 'package:youpinapp/pages/company/company_trailer.dart';
import 'package:youpinapp/pages/home/company_detail.dart';
import 'package:youpinapp/pages/home/home_video_widget.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/widgets/empty_widget.dart';
import 'package:youpinapp/app/account.dart';

import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/player/player_state_provider.dart';
import 'package:youpinapp/pages/player/video_player_hori_resume.dart';

class HomeGridCompanyNew extends StatefulWidget {
  SearchManager model;

  HomeGridCompanyNew(this.model);

  @override
  _HomeGridCompanyStateImpl createState() => _HomeGridCompanyStateImpl();
}

class _HomeGridCompanyStateImpl extends State<HomeGridCompanyNew> {
  //保存筛选条件参数
  SearchParameters searchParameters = SearchParameters();

//  SearchManager searchManager;
//  @override
//  void didUpdateWidget(HomeGridCompanyNew oldWidget) {
//    super.didUpdateWidget(oldWidget);
//
//    // 行业切换后重新加载数据
//    _loadCompanyList();
//  }

  ScrollController _scrollController;

  /// 判断是否是个人还是企业账户，1=个人，2=企业
  bool _isUserPerson = false;

  @override
  void initState() {
    super.initState();
    _isUserPerson = g_accountManager.currentUser != null &&
        g_accountManager.currentUser.typeId == 1;
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
//    searchManager = Provider.of<SearchManager>(context);
    // 调试时模拟器的宽度是178
    double gridWidth = (ScreenUtil.mediaQueryData.size.width - 55) / 2;
    double gridHeight = _isUserPerson ? 170 : 260;
    double widthScale = gridWidth / gridHeight;
//    double gridHeight = 220 * widthScale; // 图片110，下边的文字80，加起来是190
    if (widget.model.modelListCom.length > 0) {
      return RefreshIndicator(
        child: GridView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: gridWidth,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: widthScale),
          children: widget.model.modelListCom.asMap().keys.map((index) {
            HomeCompanyModel companyModel = widget.model.modelListCom[index];

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
                // 点击格格
                //判断类型
                if (_isUserPerson) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return CompanyTrailer(companyModel);
                  }));
                } else {
                  /// 企业 === 作品名称
                  HomeResumeModel resumeModel =
                      widget.model.modelListRes[index];
                  Get.to(VideoPlayerHoriResume(
                    VideoPlayType.resumeVideo,
                    currentResumeModel: resumeModel,
                    isProduction: true, // 是否是作品
                  ));
                }
              },
            );
          }).toList(),
        ),
        onRefresh: () async {
          widget.model.getRefresh(3);
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
    HomeCompanyModel companyModel = widget.model.modelListCom[index];

    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6)),
                  child: CachedNetworkImage(
                      imageUrl: companyModel.coverUrl ?? "",
                      width: (ScreenUtil.mediaQueryData.size.width - 55) / 2,
                      height: gridHeight - 50,
                      fit: BoxFit.cover)),
              Image.asset(
                  join(AssetsUtil.assetsDirectoryCommon, 'video_play.png'),
                  width: 80.w,
                  height: 80.h)
            ],
          ),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: companyModel.logoUrl != null &&
                                  companyModel.logoUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: companyModel.logoUrl,
                                  width: 24,
                                  height: 24,
                                  placeholder: (context, imageProvider) {
                                    return Image.asset(
                                        join(AssetsUtil.assetsDirectoryHome,
                                            'company_avatar_circle.png'),
                                        width: 24,
                                        height: 24);
                                  })
                              : Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(0, 0, 0, 0.2),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            child: Text(
                              companyModel.companyName ?? '',
                              style: TextStyle(
                                  fontSize: 24.w,
                                  color: Color.fromRGBO(102, 102, 102, 1)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      companyModel.distanceString ?? '暂无',
                      style: TextStyle(
                        fontSize: 24.w,
                        color: Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  /// 企业账户
  Widget _userCompany({
    @required int index,
    @required double gridWidth,
    @required double gridHeight,
    @required double widthScale,
  }) {
    HomeCompanyModel companyModel = widget.model.modelListCom[index];

    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6)),
                  child: CachedNetworkImage(
                      imageUrl: companyModel.coverUrl ?? "",
                      width: (ScreenUtil.mediaQueryData.size.width - 55) / 2,
                      height: gridHeight - 50,
                      fit: BoxFit.cover)),
              Image.asset(
                  join(AssetsUtil.assetsDirectoryCommon, 'video_play.png'),
                  width: 80.w,
                  height: 80.h)
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 70,
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Color.fromRGBO(239, 239, 239, 1), width: 1))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  left: 5,
                  right: 5,
                  bottom: 5,
                ),
                child: Text(
                  "@ ${companyModel.updatedBy ?? '--'} ${companyModel.updatedTime ?? '--'}",
                  style: TextStyle(
                      fontSize: 24.w, color: Color.fromRGBO(102, 102, 102, 1)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Text(
                  '${companyModel.title ?? "--"} ${companyModel.details ?? ''}',
                  style: TextStyle(
                      fontSize: 24.w, color: Color.fromRGBO(102, 102, 102, 1)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
