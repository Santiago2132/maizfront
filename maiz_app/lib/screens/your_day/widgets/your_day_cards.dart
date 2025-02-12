import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:mAIz/widgets/custom_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:auto_size_text/auto_size_text.dart';

class YourDayCards extends StatefulWidget {
  const YourDayCards({super.key});

  @override
  State<YourDayCards> createState() => _YourDayCardsState();
}

class _YourDayCardsState extends State<YourDayCards> {
  List<Map<String, dynamic>> _phrases = [];
  List<String> _images = [];
  final Random _random = Random();
  final int _maxCards = 12;

  Future<void> _loadPhrases() async {
    final String response =
        await rootBundle.loadString('assets/motivation_phrases.json');
    final List<dynamic> data = json.decode(response);

    final uniquePhrases = data
        .cast<Map<String, dynamic>>()
        .fold<Map<String, Map<String, dynamic>>>({}, (map, phrase) {
          String text = phrase['text'];
          if (!map.containsKey(text)) {
            map[text] = phrase;
          }
          return map;
        })
        .values
        .toList();

    uniquePhrases.shuffle(_random);
    setState(() => _phrases = uniquePhrases.take(_maxCards).toList());
  }

  Future<void> _loadImages() async {
    final manifest =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifest);
    final imagePaths = manifestMap.keys
        .where((String key) => key.startsWith('assets/images/'))
        .toList();
    imagePaths.shuffle(_random);
    setState(() => _images = imagePaths.take(7).toList());
  }

  void _refreshCards() {
    _loadPhrases();
    _loadImages();
  }

  @override
  void initState() {
    super.initState();
    _loadPhrases();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadImages());
  }

  @override
  Widget build(BuildContext context) {
    final combinedList = [
      ..._phrases.map((phrase) => {'type': 'text', 'data': phrase}),
      ..._images.map((image) => {'type': 'image', 'path': image})
    ];
    combinedList.shuffle(_random);

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return MasonryGridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: combinedList.length,
              itemBuilder: (context, index) {
                final item = combinedList[index];
                final isImage = item['type'] == 'image';
                final data = item[isImage ? 'path' : 'data'];

                // Configuración de dimensiones
                final cardWidth = constraints.maxWidth * 0.45;
                double cardHeight;

                if (isImage) {
                  cardHeight = cardWidth * 1.2; // Proporción 4:5
                } else {
                  final phrase = data as Map<String, dynamic>;
                  final text = phrase['text'];
                  final fontSize = phrase['fontSize']?.toDouble() ?? 20;

                  // Calcular altura requerida para el texto
                  final textPainter = TextPainter(
                    text: TextSpan(
                      text: text,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textDirection: TextDirection.ltr,
                    maxLines: null,
                  );

                  textPainter.layout(
                      maxWidth: cardWidth - 32); // Considerar padding
                  cardHeight =
                      textPainter.size.height + 64; // Padding vertical ampliado
                }

                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: CustomCard(
                    width: cardWidth,
                    height: cardHeight,
                    backgroundColor:
                        isImage ? Colors.transparent : const Color(0xfffff5cc),
                    padding:
                        isImage ? EdgeInsets.zero : const EdgeInsets.all(16),
                    child: isImage
                        ? _buildImageCard(data as String)
                        : _buildTextCard(data as Map<String, dynamic>),
                  ),
                );
              },
            );
          },
        ),
        ElevatedButton(
          onPressed: _refreshCards,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffffe699),
            foregroundColor: const Color(0xff673ab7),
          ),
          child: const Text('Mostrar nuevas frases'),
        ),
      ],
    );
  }

  Widget _buildTextCard(Map<String, dynamic> phrase) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AutoSizeText(
          phrase['text'],
          style: TextStyle(
            fontSize: phrase['fontSize']?.toDouble() ?? 20,
            color: const Color(0xff673ab7),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: null,
        ),
      ),
    );
  }

  Widget _buildImageCard(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
