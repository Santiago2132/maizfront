import 'package:flutter/material.dart';

class EmotionSelector extends StatelessWidget {
  final Function(String) onEmotionSelected;

  const EmotionSelector({super.key, required this.onEmotionSelected});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Map<String, String> feelings = {
      'Deprimente': 'assets/icons/Depressed_icon.png',
      'Triste': 'assets/icons/sad_icon.png',
      'Regular': 'assets/icons/so_so_icon.png',
      'Feliz': 'assets/icons/Happy_icon.png',
      'Euforico': 'assets/icons/Euphoric_icon.png',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration:  BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white, // Texto 
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Selecciona tu emoción',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: feelings.entries.map((entry) {
              return GestureDetector(
                onTap: () {
                  onEmotionSelected(entry.key);
                  Navigator.pop(context); // Cerrar el BottomSheet
                },
                child: Column(
                  children: [
                    Image.asset(entry.value, width: 50, height: 50),
                    const SizedBox(height: 5),
                    Text(entry.key, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
