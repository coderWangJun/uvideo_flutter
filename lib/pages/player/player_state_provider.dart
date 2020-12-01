import 'package:flutter/cupertino.dart';
import 'package:youpinapp/models/index.dart';

// 视频播放类型
enum VideoPlayType {
  shortVideo, // 作品视频
  resumeVideo // 简历视频
}

class PlayerStateProvider extends ChangeNotifier {
  VideoPlayType playType; // 视频播放类型
  HomeResumeModel currentResumeModel; // 当前将要播放的简历视频

  int _currentVideoType; // 0 关注；1 推荐
  bool _stopPlay; // 停止播放
  ShortVideoModel _currentVideoModel;

  ShortVideoModel get currentVideoModel => _currentVideoModel;

  set currentVideoModel(videoModel) {
    _currentVideoModel = videoModel;
    notifyListeners();
  }

  int get currentVideoType =>_currentVideoType;

  set currentVideoType(videoType) {
    _currentVideoType = videoType;
    notifyListeners();
  }

  bool get stopPlay => _stopPlay;

  set stopPlay(stopPlay) {
    _stopPlay = stopPlay;
    notifyListeners();
  }
}