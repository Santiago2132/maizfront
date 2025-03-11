import 'package:flutter/material.dart';

class TextBreathing extends StatelessWidget {
  const TextBreathing({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // Alineación a la derecha
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Respira y renuevate',
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
