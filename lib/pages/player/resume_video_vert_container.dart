import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youpinapp/models/home_resume_model.dart';
import 'package:youpinapp/pages/person/user_detail_route.dart';
import 'package:youpinapp/pages/player/video_player_widget.dart';
import 'package:youpinapp/utils/dio_util.dart';

class PagedResumePlayer extends StatefulWidget {
  final int currentIndex;

  PagedResumePlayer(this.currentIndex);

  @override
  _PagedResumePlayerState createState() => _PagedResumePlayerState(this.currentIndex);
}

class _PagedResumePlayerState extends State<PagedResumePlayer> {
  int currentIndex = 0;
  List<HomeResumeModel> _resumeList = [];

  PageController _horiPageController;
  PageController _vertPageController;

  _PagedResumePlayerState(this.currentIndex) {
    _horiPageController = PageController();
    _vertPageController = PageController();

    _loadResumeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: ScreenUtil.mediaQueryData.size.width,
        height: ScreenUtil.mediaQueryData.size.height,
        child: PageView(
          controller: _horiPageController,
          children: <Widget>[
            _buildVertPageView(),
            UserDetailRoute()
          ],
        ),
      ),
    );
  }

  Widget _buildVertPageView() {
    return PageView(
      scrollDirection: Axis.vertical,
      controller: _vertPageController,
      children: _resumeList.map((resumeModel) {
        return VideoPlayerWidget(resumeModel);
      }).toList()
    );
  }

  // 加载简历列表
  void _loadResumeList() async {
    DioUtil.request('/resume/getMediaResume').then((responseData) {
      bool success = DioUtil.checkRequestResult(responseData, showToast: false);
      if (success) {
        List<dynamic> dataList = responseData['data'];
        List<HomeResumeModel> modelList = dataList.map((json) {
          return HomeResumeModel.fromJson(json);
        }).toList();
        _resumeList.addAll(modelList);
        setState(() { });

        _vertPageController.jumpToPage(this.currentIndex);
      }
    });
  }
}