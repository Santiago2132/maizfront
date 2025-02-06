import 'package:flutter/material.dart';
import 'package:maiz_app/widgets/custom_card.dart';

class FeelingCard extends StatefulWidget {
  const FeelingCard({super.key});

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

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      height: 130, // Modifica esta línea para ajustar la altura
      child: Column(
        children: [
          const Text(
            '¿Cómo te sientes hoy?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF673AB7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final itemWidth = (maxWidth - 50) /
                  feelings.length; // Ajuste del ancho de cada imagen

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: feelings.entries.map((entry) {
                  final isSelected = selectedFeeling == entry.key;

                  return GestureDetector(
                    onTap: () => setState(() => selectedFeeling = entry.key),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF673AB7).withOpacity(0.1)
                            : Colors.transparent,
                        shape: BoxShape.circle, // Forma circular
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF673AB7)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Image.asset(
                        entry.value,
                        width: itemWidth - 12, // Ajuste del tamaño de la imagen
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
