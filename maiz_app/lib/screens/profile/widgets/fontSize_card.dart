import 'package:flutter/material.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:provider/provider.dart';

class FontSizeCard extends StatelessWidget {
  const FontSizeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Tamaño de Letra",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.deepPurple),
                  onPressed: fontSizeProvider.decreaseFontSize,
                ),
                Text(
                  "${fontSizeProvider.fontSize.toInt()}",
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.deepPurple),
                  onPressed: fontSizeProvider.increaseFontSize,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
