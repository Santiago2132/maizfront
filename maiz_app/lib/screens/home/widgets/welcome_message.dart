import 'package:flutter/material.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // Alineación a la derecha
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'HOLA ',
              style: TextStyle(
                fontSize: 32,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'USUARIO,\n', // Salto de línea
              style: TextStyle(
                fontSize: 32,
                color: Colors.black, // Color negro
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'Bienvenido a mAIz',
              style: TextStyle(
                fontSize: 24, // Tamaño reducido
                color: Colors.deepPurple,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}