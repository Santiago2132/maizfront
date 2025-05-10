import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController? _controller;
  late YoutubePlayerController? _ytController;
  bool isYouTube = false;

  @override
  void initState() {
    super.initState();
    isYouTube = widget.videoUrl.contains("youtube.com") || widget.videoUrl.contains("youtu.be");

    if (isYouTube) {
      final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
      _ytController = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
    } else {
      _controller = VideoPlayerController.network(widget.videoUrl)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _ytController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isYouTube
        ? YoutubePlayer(
            controller: _ytController!,
            showVideoProgressIndicator: true,
          )
        : _controller!.value.isInitialized
            ? Column(
                children: [
                  AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
                      });
                    },
                    child: Text(_controller!.value.isPlaying ? "Pausar" : "Reproducir"),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator());
  }
}
