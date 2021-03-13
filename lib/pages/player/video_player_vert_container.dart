import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/global/global.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/player/player_state_provider.dart';
import 'package:youpinapp/pages/player/video_player_widget.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/event_bus.dart';

import '../../widgets/empty_widget.dart';
import 'player_state_provider.dart';

class VideoPlayerVertContainer extends StatefulWidget {
  final int queryType; // 0 查询关注的视频；1 查询推荐的视频

  VideoPlayerVertContainer({this.queryType});

  @override
  _VideoPlayerVertContainerState createState() =>
      _VideoPlayerVertContainerState();
}

class _VideoPlayerVertContainerState extends State<VideoPlayerVertContainer>
    with AutomaticKeepAliveClientMixin<VideoPlayerVertContainer> {
  int _currentPage = 1;
  int _pageSize = 10;
  int _prevVideoType = 1; // 默认为推荐视频
  bool _isLoadData = false;
  PageController _pageController = new PageController();
  List<dynamic> _videoList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    g_eventBus.on(GlobalEvent.accountInitialized, (arg) {
      _currentPage = 1;
      _loadData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // if (AccountManager.instance.currentUser != null) {
    // }

    if (!_isLoadData) {
      _currentPage = 1;
      _loadData();
    }

    _isLoadData = false;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<PlayerStateProvider>().currentVideoType;

    return _videoList.length == 0
        ? EmptyWidget(showTitle: "")
        : PageView.builder(
            itemCount: _videoList.length,
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return VideoPlayerWidget(_videoList[index]);
            },
            onPageChanged: (pageIndex) {
              ShortVideoModel videoModel = _videoList[pageIndex];
              context.read<PlayerStateProvider>().currentVideoModel =
                  videoModel;

              if (pageIndex == (_videoList.length - 1)) {
                _loadData();
              }
            },
          );
  }

  void _loadData() {
    if (context != null) {
      int currentVideoType =
          context.read<PlayerStateProvider>().currentVideoType;
      if (currentVideoType != _prevVideoType) {
        _videoList.clear();
      }

      VideoPlayType playType = context.read<PlayerStateProvider>().playType;
      if (playType == VideoPlayType.resumeVideo) {
        _videoList.add(context.read<PlayerStateProvider>().currentResumeModel);
        _loadResumeVideoList();
      } else {
        _loadShortVideoList();
      }
    }
  }

  void _loadShortVideoList() {
    int videoType = context.read<PlayerStateProvider>().currentVideoType;
    var params = {"current": _currentPage, "size": _pageSize};
    if (videoType == 0) {
      params["queryType"] = 2;
    }

    BotToast.showLoading();
    DioUtil.request('/user/getMediaWorks', parameters: params).then((response) {
      bool success = DioUtil.checkRequestResult(response, showToast: false);
      if (success) {
        List<dynamic> dataList = response['data'];

        if (dataList != null && dataList.length > 0) {
          _currentPage++;
          List<ShortVideoModel> modelList = dataList.map((json) {
            ShortVideoModel videoModel = ShortVideoModel.fromJson(json);
            return videoModel;
          }).toList();
          _videoList.addAll(modelList);
        }
      }

      if (_currentPage <= 2 && _videoList.length > 0) {
        _isLoadData = true;
        context.read<PlayerStateProvider>().currentVideoModel = _videoList[0];
      }

      setState(() {});
    }).whenComplete(() => BotToast.closeAllLoading());
  }

  void _loadResumeVideoList() {
    // DioUtil.request(
    //   "/resume/getMediaResumeDetails",
    //   method: 'POST',
    //   parameters: {
    //     'id':
    //   },
    // ).then((response) {
    DioUtil.request("/resume/getMediaResume").then((response) {
      bool success = DioUtil.checkRequestResult(response);
      if (success) {
        List<dynamic> dataList = response['data'];

        if (dataList != null && dataList.length > 0) {
          List<HomeResumeModel> modelList = dataList.map((json) {
            return HomeResumeModel.fromJson(json);
          }).toList();

          _videoList.addAll(modelList);
        }
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
  }
}
