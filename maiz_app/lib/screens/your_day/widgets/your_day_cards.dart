import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maiz_app/widgets/custom_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class YourDayCards extends StatefulWidget {
  const YourDayCards({super.key});

  @override
  State<YourDayCards> createState() => _YourDayCardsState();
}

class _YourDayCardsState extends State<YourDayCards> {
  List<Map<String, dynamic>> _phrases = [];
  List<String> _images = [];
  final Random _random = Random();
  final int _maxCards = 5; //CANTIDAD DE FRASES QUE SE VAN A MOSTRAR

  Future<void> _loadPhrases() async {
    final String response = await rootBundle.loadString('assets/motivation_phrases.json');
    final List<dynamic> data = json.decode(response);
    data.shuffle(_random);
    setState(() => _phrases = data.take(_maxCards).cast<Map<String, dynamic>>().toList());
  }

  Future<void> _loadImages() async {
    final manifest = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifest);
    final imagePaths = manifestMap.keys.where((String key) => key.startsWith('assets/images/')).toList();
    imagePaths.shuffle(_random);
    setState(() => _images = imagePaths.take(3).toList()); //CANTIDAD DE IMAGENES QUE SE VAN A MOSTRAR
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
        ElevatedButton(
          onPressed: _refreshCards,
          child: const Text('Mostrar nuevas frases'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffffe699), //Colores de las tarjetas
            foregroundColor: const Color(0xff673ab7), //Colores del texto de las tarjetas
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            return MasonryGridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: combinedList.length,
              itemBuilder: (context, index) {
                final item = combinedList[index];
                final isImage = item['type'] == 'image';
                final data = item[isImage ? 'path' : 'data'];


                //DISEÑO DE LAS TARJETAS E IMAGENES
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: CustomCard(
                    width: isImage 
                        ? constraints.maxWidth * 0.45 // Longitud de la imagen
                        : ((data != null ? (data as Map<String, dynamic>)['width']?.toDouble() : null) ?? constraints.maxWidth * 0.45),
                    height: isImage 
                        ? constraints.maxWidth * 0.55 // Altura de la imagen
                        : ((data != null ? (data as Map<String, dynamic>)['height']?.toDouble() : null) ?? 200),
                    backgroundColor: isImage ? Colors.transparent : const Color(0xfffff5cc),
                    padding: isImage ? EdgeInsets.zero : const EdgeInsets.all(16), // Padding solo en texto
                    child: isImage 
                        ? _buildImageCard(data as String) 
                        : _buildTextCard(data as Map<String, dynamic>),
                  ),
                  );

              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildTextCard(Map<String, dynamic> phrase) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          phrase['text'],
          style: TextStyle(
            fontSize: phrase['fontSize']?.toDouble() ?? 20,
            color: const Color(0xff673ab7),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildImageCard(String imagePath) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(25), // Mismo radio que el CustomCard
    child: Image.asset(
      imagePath,
      width: double.infinity, // Ocupar todo el ancho disponible
      height: double.infinity, // Ocupar todo el alto disponible
      fit: BoxFit.cover,
    ),
  );
}
}