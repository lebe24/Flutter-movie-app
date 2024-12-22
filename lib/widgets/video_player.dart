import 'package:flutter/material.dart';
import 'package:movie_app/utils/player.dart';

class YouTubeVideoPlayerImpl extends VideoPlayer {
  // You can add additional methods or override the existing method if needed
  void playVideo({
    required BuildContext context, 
    required String videoId
  }) {
    // You can add any additional logic before showing the video
    showVideoPlayerDialog(
      context: context, 
      videoId: videoId
    );
  }
}