import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/widgets/custom_card.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });
  }

  Future<void> _play() async {
    await _audioPlayer.play(AssetSource('music/faithful.mp3'));
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    setState(() => _position = Duration.zero);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    double fontSizeProvider = Provider.of<FontSizeProvider>(context).fontSize;
    final bool _changeFont = (fontSizeProvider > 15) as bool;

    return SizedBox(
      height: _changeFont ? (screenHeight * 0.30): screenHeight * 0.30,
      child: CustomCard(
        backgroundColor: const Color(0xFF673AB7),
        textColor: Colors.white,
        
        child: Padding(
          padding: const EdgeInsets.all(2.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  children: [
                    AutoSizeText(
                      'Faithful Mission',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            fontSizeProvider, // Reducido el tamaño de fuente
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AutoSizeText(
                      'Artificial.Music',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize:
                            fontSizeProvider, // Reducido el tamaño de fuente
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize:
                          12, // Ajusta el tamaño mínimo para evitar el desbordamiento
                      maxFontSize: 20,
                      stepGranularity:
                          1, // Opcional: controla la precisión de reducción
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 0.5,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 5),
                  ),
                  child: Slider(
                    activeColor: const Color(0xfffff5cc),
                    inactiveColor: Colors.white54,
                    min: 0,
                    max: _duration.inSeconds.toDouble(),
                    value: _position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      await _audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatTime(_position),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10, // Reducido el tamaño de fuente
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: _changeFont ? 20: 25,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: () => _isPlaying ? _pause() : _play(),
                        ),
                        IconButton(
                          icon:  Icon(
                            Icons.stop,
                            size: _changeFont ? 20: 25,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: _stop,
                        ),
                      ],
                    ),
                    Text(
                      _formatTime(_duration),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10, // Reducido el tamaño de fuente
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
