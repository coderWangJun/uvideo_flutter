import 'package:awsome_video_player/awsome_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';
import 'package:youpinapp/utils/assets_util.dart';

class SingleVideoPlayer extends StatefulWidget {
  final String videoUrl;

  SingleVideoPlayer(this.videoUrl);

  @override
  _SingleVideoPlayerState createState() => _SingleVideoPlayerState();
}

class _SingleVideoPlayerState extends State<SingleVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: double.infinity,
        child: AwsomeVideoPlayer(
          widget.videoUrl,
          videoStyle: VideoStyle(
            videoTopBarStyle: VideoTopBarStyle(
              height: 80,
              popIcon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, "nav_back.png"))
            )
          ),
          onpop: (VideoPlayerValue value) {
            Get.back();
          },
        ),
      ),
    );
  }
}