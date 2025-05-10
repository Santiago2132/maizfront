import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/widgets/custom_card.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerCarouselState();
}

class _MusicPlayerCarouselState extends State<MusicPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final PageController _pageController = PageController(viewportFraction: 0.8);
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  int _currentIndex = 0;

  final List<Map<String, String>> _songs = [
    {'title': 'Faithful Mission', 'artist': 'Artificial.Music', 'path': 'music/faithful.mp3'},
    {'title': 'Good for you', 'artist': 'THBD', 'path': 'music/goodforyou.mp3'},
    {'title': 'Affection', 'artist': 'Sappheiros', 'path': 'music/Sappheiros.mp3'},
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => _isPlaying = state == PlayerState.playing);
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });
  }

  Future<void> _play(String path) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    setState(() => _position = Duration.zero);
  }

  void _nextSong() {
    if (_currentIndex < _songs.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void _previousSong() {
    if (_currentIndex > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double fontSizeProvider = Provider.of<FontSizeProvider>(context).fontSize;

    return SizedBox(
      height: 300, // Aumentar la altura para mejor visibilidad del carrusel
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _songs.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
                _play(_songs[index]['path']!);
              },
              itemBuilder: (context, index) {
                final song = _songs[index];
                return Transform.scale(
                  scale: index == _currentIndex ? 1.0 : 0.9, // Efecto de zoom
                  child: CustomCard(
                    backgroundColor: const Color(0xFF673AB7),
                    textColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            song['title']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSizeProvider,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            song['artist']!,
                            style: TextStyle(color: Colors.white70, fontSize: fontSizeProvider),
                            maxLines: 1,
                          ),
                          Slider(
                            activeColor: Colors.amberAccent,
                            inactiveColor: Colors.white54,
                            min: 0,
                            max: _duration.inSeconds.toDouble(),
                            value: _position.inSeconds.toDouble(),
                            onChanged: (value) async {
                              await _audioPlayer.seek(Duration(seconds: value.toInt()));
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.skip_previous, size: 30, color: Colors.white),
                                onPressed: _previousSong,
                              ),
                              IconButton(
                                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 30, color: Colors.white),
                                onPressed: () => _isPlaying ? _pause() : _play(song['path']!),
                              ),
                              IconButton(
                                icon: const Icon(Icons.stop, size: 30, color: Colors.white),
                                onPressed: _stop,
                              ),
                              IconButton(
                                icon: Icon(Icons.skip_next, size: 30, color: Colors.white),
                                onPressed: _nextSong,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
