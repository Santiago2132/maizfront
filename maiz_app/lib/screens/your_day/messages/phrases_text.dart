import 'package:flutter/material.dart';

class PhrasesText extends StatelessWidget {
  const PhrasesText({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // Alineación al centro
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'FRASES DEL DÍA',
              style: TextStyle(
                fontSize: 24, // Tamaño reducido
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
