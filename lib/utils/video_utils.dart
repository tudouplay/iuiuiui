import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerHelper {
  static VideoPlayerController? createController(String url) {
    try {
      return VideoPlayerController.network(url);
    } catch (e) {
      print('Error creating video controller: $e');
      return null;
    }
  }

  static ChewieController? createChewieController(
    VideoPlayerController videoController, {
    bool autoPlay = true,
    bool looping = false,
  }) {
    try {
      return ChewieController(
        videoPlayerController: videoController,
        autoPlay: autoPlay,
        looping: looping,
        aspectRatio: 16 / 9,
        placeholder: Container(color: Colors.black),
        autoInitialize: true,
      );
    } catch (e) {
      print('Error creating chewie controller: $e');
      return null;
    }
  }
}