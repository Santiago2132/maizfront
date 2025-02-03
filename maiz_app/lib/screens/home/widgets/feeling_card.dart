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
    height: 130, // Altura reducida
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
        const SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    width: 2
                  ),
                ),
                child: Image.asset(
                  entry.value,
                  width: 44, // Tamaño reducido
                  height: 45,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}
}