import 'package:flutter/material.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/models/emotion_storage.dart';
import 'package:mAIz/widgets/custom_card.dart';
import 'package:provider/provider.dart';

class FeelingCard extends StatefulWidget {
  final VoidCallback onEmotionSelected; // Añadir esta línea
  const FeelingCard({super.key, required this.onEmotionSelected});

  @override
  State<FeelingCard> createState() => _FeelingCardState();
}

class _FeelingCardState extends State<FeelingCard> {
  String? selectedFeeling;

  final Map<String, String> feelings = {
    'Deprimente': 'assets/icons/Depressed_icon.png',
    'Triste': 'assets/icons/sad_icon.png',
    'Regular': 'assets/icons/so_so_icon.png',
    'Feliz': 'assets/icons/Happy_icon.png',
    'Euforico': 'assets/icons/Euphoric_icon.png',
  };

  void _handleFeelingSelection(String feeling) async {
    setState(() => selectedFeeling = feeling);
    await EmotionStorage.saveEmotion(feeling);
    widget.onEmotionSelected(); // Notificar al padre
  }

  @override
  Widget build(BuildContext context) {
  final fontSizeProvider = Provider.of<FontSizeProvider>(context).fontSize;

    return CustomCard(
      height: 130,
      child: Column(
        children: [
           Text(
            '¿Cómo te sientes hoy?',
            style: TextStyle(
              fontSize: fontSizeProvider,
              fontWeight: FontWeight.bold,
              color: Color(0xff673ab7)
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final itemWidth = (maxWidth - 50) / feelings.length;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: feelings.entries.map((entry) {
                  final isSelected = selectedFeeling == entry.key;

                  return GestureDetector(
                    onTap: () => _handleFeelingSelection(entry.key),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF673AB7).withOpacity(0.1)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF673AB7)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Image.asset(
                        entry.value,
                        width: itemWidth - 12,
                        height: itemWidth - 12,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
