import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';
import 'package:youpinapp/utils/assets_util.dart';

class MarketListPlayer extends StatefulWidget {
  MarketListPlayer(this.coverUrl, this.videoUrl ,{this.widthFlag = true});

  bool widthFlag = true;
  final String coverUrl;  // 封面图片
  final String videoUrl;  // 视频地址

  @override
  _MarketListPlayerState createState() => _MarketListPlayerState();
}

class _MarketListPlayerState extends State<MarketListPlayer> {
  VideoPlayerController _playerController;

  double minWidthDouble;
  double heightDouble;

  @override
  Widget build(BuildContext context) {

    if(widget.widthFlag){
      minWidthDouble = (ScreenUtil.mediaQueryData.size.width - 60) / 3;
      heightDouble = 220.0;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6)
      ),
      constraints: BoxConstraints(
        minWidth: minWidthDouble
      ),
//      height: heightDouble,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: _buildVideoWidget(),
            ),
            onTap: () async {
              if (_playerController == null) {
                _playerController = VideoPlayerController.network(widget.videoUrl);
                await _playerController.initialize();
                await _playerController.play();
              } else {
                if (_playerController.value.isPlaying) {
                  _playerController.pause();
                } else {
                  _playerController.play();
                }
              }

              setState(() { });
            },
          ),
          _buildPlayIcon()
        ],
      ),
    );
  }

  Widget _buildVideoWidget() {
    if (_playerController == null) {
      return CachedNetworkImage(
        imageUrl: widget.coverUrl ?? "",
        height: 220,
        fit: BoxFit.cover,
      );
    } else {
      if (_playerController.value.initialized) {
        return AspectRatio(
          aspectRatio: _playerController.value.aspectRatio,
          child: VideoPlayer(_playerController),
        );
      }
    }

    return SizedBox.shrink();
  }

  Widget _buildPlayIcon() {
    if (_playerController == null) {
      return Image.asset(join(AssetsUtil.assetsDirectoryMarket, 'market_play.png'));
    } else {
      if (_playerController.value.isBuffering) {
        return CircularProgressIndicator();
      } else if (!_playerController.value.isPlaying) {
        return Image.asset(join(AssetsUtil.assetsDirectoryMarket, 'market_play.png'));
      }
    }

    return SizedBox.shrink();
  }

  @override
  void dispose() {
    if (_playerController != null) {
      _playerController.dispose();
      _playerController = null;
    }

    super.dispose();
  }
}