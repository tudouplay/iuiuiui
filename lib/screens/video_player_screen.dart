import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/movie_model.dart';
import '../utils/video_utils.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Movie movie;
  final List<VideoSource> sources;
  
  const VideoPlayerScreen({
    Key? key,
    required this.movie,
    required this.sources,
  }) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  int _currentSourceIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    if (widget.sources.isNotEmpty) {
      _videoPlayerController = VideoPlayerHelper.createController(
        widget.sources[_currentSourceIndex].url,
      );
      
      if (_videoPlayerController != null) {
        _chewieController = VideoPlayerHelper.createChewieController(
          _videoPlayerController!,
        );
      }
    }
  }

  void _changeSource(int index) {
    if (index == _currentSourceIndex) return;
    
    setState(() {
      _currentSourceIndex = index;
    });
    
    _chewieController?.pause();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    
    _initializeVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (_chewieController != null)
              Expanded(
                child: Chewie(controller: _chewieController!),
              )
            else
              Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
            _buildSourceSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceSelector() {
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.sources.length,
        itemBuilder: (context, index) {
          final source = widget.sources[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: ChoiceChip(
              label: Text(source.name),
              selected: _currentSourceIndex == index,
              onSelected: (selected) => _changeSource(index),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}