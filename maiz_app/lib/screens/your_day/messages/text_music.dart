import 'package:flutter/material.dart';

class TextMusic extends StatelessWidget {
  const TextMusic({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // Alineación a la derecha
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Vibras Zen',
              style: TextStyle(
                fontSize: 18, // Tamaño reducido
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
