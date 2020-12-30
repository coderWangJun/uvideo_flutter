import 'package:flutter/cupertino.dart';
import 'package:youpinapp/pages/player/player_state_provider.dart';
import 'package:youpinapp/pages/player/video_player_hori_container.dart';

class HomeVideoWidget extends StatelessWidget {
  int _type;


  @override
  Widget build(BuildContext context) {
    return VideoPlayerHoriContainer(VideoPlayType.shortVideo);
  }
}
