import 'package:flutter/material.dart';

class YourDayMessage extends StatelessWidget {
  const YourDayMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // Alineación a la derecha
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'CONSTRUYE TU DÍA\n',
              style: TextStyle(
                fontSize: 32,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'Con dedicación y esfuerzo',
              style: TextStyle(
                fontSize: 24, // Tamaño reducido
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}