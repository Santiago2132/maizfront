import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PodcastPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const PodcastPlayerWidget({super.key, required this.audioUrl});

  @override
  _PodcastPlayerWidgetState createState() => _PodcastPlayerWidgetState();
}

class _PodcastPlayerWidgetState extends State<PodcastPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setUrl(widget.audioUrl);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.headset, size: 50, color: Colors.deepPurple),
        ElevatedButton(
          onPressed: _togglePlayPause,
          child: Text(isPlaying ? "Pausar Podcast" : "Reproducir Podcast"),
        ),
      ],
    );
  }
}
