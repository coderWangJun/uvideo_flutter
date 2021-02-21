import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/app.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/player/pay_dialog.dart';
import 'package:youpinapp/pages/player/player_state_provider.dart';
import 'package:youpinapp/pages/player/video_player_bottom_widget.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/event_bus.dart';

class VideoPlayerWidget extends StatefulWidget {
  // 可能为ShowreelModel(作品)或HomeResumeModel(简历)
  final dynamic dataModel;

  VideoPlayerWidget(this.dataModel);

  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with TickerProviderStateMixin {
  BuildContext _buildContext;

  VideoPlayerController _playerController;
  TabController _topTabController;
  TabController _bottomTabController;

  List<String> _tabbarTitles = ['关注', '推荐', '附近'];
  List<String> _bottomTabBarTitles = ['首页', '集市', '', '消息', '我的'];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _topTabController = new TabController(
        length: _tabbarTitles.length, vsync: this, initialIndex: 1);
    _bottomTabController =
        new TabController(length: _bottomTabBarTitles.length, vsync: this);

    _initVideo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    bool stopPlay = context.read<PlayerStateProvider>().stopPlay;
    if (stopPlay != null && stopPlay && _playerController.value.isPlaying) {
      _playerController.pause();
    }

    g_eventBus.on(GlobalEvent.stopPlayEvent, (args) {
      if (_playerController != null) {
        Wakelock.disable();
        _playerController.pause();
        _playerController.removeListener(() {});

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildVideoWidget(), // 播放组件
//            (widget.dataModel is ShortVideoModel) ? _buildTopLeftButton() : _buildBackButton(context),  // 左上角按钮
//            _buildTopCenterTabBar(),  // 顶部中间的tabbar
//            _buildTopRightButton(),  // 右上角按钮
            _buildBottomPanel(), // 底部区域
            _buildCenterPlayIcon(), // 屏幕中间的播放图标
            _buildIndicator(), // 构建屏幕中间加载视频的圈圈
//            (widget.dataModel is ShowreelModel) ? _buildBottomTabBar() : SizedBox.shrink(),
          ],
        ),
      ),
      //floatingActionButton: FloatingButton.buildJobRingButton('HomeVideo')
    );
  }

  // 初始化视频文件
  void _initVideo() async {
    var videoUrl = "";
    bool coinDialogShowed = false;
    int hadBought = 1; // 是否已购(1表示已购)
    int needUcoin = 1; // 是否需要付费(U币) 1.否 2.是
    int freeSeconds = 0; // 免费观看的秒数

    if (widget.dataModel is ShortVideoModel) {
      ShortVideoModel shortVideoModel = widget.dataModel as ShortVideoModel;
      videoUrl = shortVideoModel.worksUrl;

      hadBought = shortVideoModel.hadBought;
      needUcoin = shortVideoModel.needUcoin;
      freeSeconds = shortVideoModel.freeSeconds;
    } else {
      HomeResumeModel resumeModel = widget.dataModel as HomeResumeModel;
      videoUrl = resumeModel.worksUrl;
    }

    _playerController = VideoPlayerController.network(videoUrl);
    await _playerController.initialize();
//    await _playerController.play();

    if (widget.dataModel is ShortVideoModel) {
      _startPlay();
    }

    _playerController.addListener(() {
      AccountManager.instance.isLogin.then((isLogin) {
        bool needPay = false;
        if (isLogin) {
          needPay = (hadBought != 1 && needUcoin == 2) ? true : false;
        } else {
          needPay = (needUcoin == 2 ? true : false);
        }

        if (_playerController != null && needPay) {
          if (!coinDialogShowed &&
              _playerController.value.position.inSeconds > freeSeconds) {
            Wakelock.disable();
            coinDialogShowed = true;
            _playerController.pause();
            _playerController.removeListener(() {});

            _showPayDialog();
          }
        }

        if (mounted) {
          setState(() {});
        }
      });
    });

    if (mounted) {
      setState(() {});
    }
  }

  void _startPlay() {
    if (App.instance.showMode == AppShowMode.player) {
      int hadBought = 1; // 是否已购(1表示已购)
      int needUcoin = 1; // 是否需要付费(U币) 1.否 2.是
      int freeSeconds = 0; // 免费观看的秒数

      if (widget.dataModel is ShortVideoModel) {
        ShortVideoModel shortVideoModel = widget.dataModel as ShortVideoModel;

        hadBought = shortVideoModel.hadBought;
        needUcoin = shortVideoModel.needUcoin;
        freeSeconds = shortVideoModel.freeSeconds;
      }

      if (needUcoin == 2 &&
          hadBought != 1 &&
          _playerController.value.position.inSeconds > freeSeconds) {
        _showPayDialog();
      } else if (_playerController.value.isPlaying == false) {
        if (_playerController.value.position.inSeconds >=
            _playerController.value.duration.inSeconds) {
          _playerController.seekTo(Duration(seconds: 0));
        }

        Wakelock.enable();
        _playerController.play();
      }

      setState(() {});
    }
  }

  void _showPayDialog() {
    AccountManager.instance.isLogin.then((isLogin) async {
      if (isLogin) {
        ShortVideoModel shortVideoModel = widget.dataModel as ShortVideoModel;
        bool success = await PayDialog.show(_buildContext,
            freeSeconds: shortVideoModel.freeSeconds,
            tradeFrom: 3,
            tradeType: 2,
            tradeAmount: shortVideoModel.ucoinAmount,
            goodsId: shortVideoModel.id);
        if (success) {
          shortVideoModel.hadBought = 1;
          _startPlay();
        }
      }
    });
  }

  // 构建视频播放器
  Widget _buildVideoWidget() {
    return (_playerController != null && _playerController.value.initialized)
        ? GestureDetector(
            child: Container(
              width: double.infinity,
              color: Color.fromRGBO(0, 0, 0, 0.9),
              child: AspectRatio(
                aspectRatio: _playerController.value.aspectRatio,
                child: VideoPlayer(_playerController),
              ),
            ),
            onTap: () async {
              if (_playerController != null &&
                  _playerController.value.initialized) {
                if (_playerController.value.isPlaying) {
                  await _playerController.pause();
                } else {
//              await _playerController.play();
                  _startPlay();
                }

                setState(() {});
              }
            },
          )
        : SizedBox.shrink();
  }

  // 底部区域，包含头像、点赞、评论、分享、位置、@、文字描述、标签
  Widget _buildBottomPanel() {
    return Positioned(
      left: 0,
      bottom: (widget.dataModel is ShortVideoModel) ? 140.h : 40.h,
      child: VideoPlayerBottomWidget(widget.dataModel),
    );
  }

  // 屏幕中间的播放图标
  Widget _buildCenterPlayIcon() {
    if (_playerController != null &&
        _playerController.value.initialized &&
        !_playerController.value.isPlaying) {
      return SizedBox(
          width: 140,
          height: 140,
          child: IconButton(
            icon: Image.asset(imagePath("home", "home_play.png"),
                width: 70, height: 70, fit: BoxFit.contain),
            onPressed: () async {
              if (_playerController != null &&
                  _playerController.value.initialized) {
//              await _playerController.play();
//              setState(() { });
                _startPlay();
              }
            },
          ));
    } else {
      return SizedBox.shrink();
    }
  }

  // 构建屏幕中间加载视频的圈圈
  Widget _buildIndicator() {
    if (_playerController != null && _playerController.value.initialized) {
      return SizedBox.shrink();
    } else {
      return CircularProgressIndicator(
        backgroundColor: Colors.grey[200],
        valueColor: AlwaysStoppedAnimation(Colors.blue),
      );
    }
  }

  // 强制停止播放
  void _stopPlay() {
    if (_playerController != null && _playerController.value.isPlaying) {
      _playerController.pause();
    }

    _playerController.dispose();
  }

  @override
  void dispose() {
//    g_eventBus.off(GlobalEvent.stopPlayEvent);
    Wakelock.disable();

    _playerController.removeListener(() {});
    _topTabController.dispose();
    _bottomTabController.dispose();
    _stopPlay();
    _playerController = null;

    super.dispose();
  }
}
