import 'package:flutter/material.dart';
import 'package:maiz_app/screens/your_day/messages/phrases_text.dart';
import 'package:maiz_app/screens/your_day/messages/text_breathing.dart';
import 'package:maiz_app/screens/your_day/messages/text_music.dart';
import 'package:maiz_app/screens/your_day/widgets/breathing_exercise.dart';
import 'package:maiz_app/screens/your_day/widgets/music_player.dart';
import 'package:maiz_app/screens/your_day/widgets/your_day_cards.dart';
import 'package:maiz_app/screens/your_day/messages/your_day_message.dart';

class YourDayScreen extends StatelessWidget {
  const YourDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Contenido principal
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  const YourDayMessage(), // Mensaje del día
                  const SizedBox(height: 28),
                  const TextBreathing(), // Texto de la sección de respiración
                  const SizedBox(height: 5),
                  const BreathingExercise(), // Ejercicio de respiración
                  const SizedBox(height: 15),
                  const TextMusic(), // Texto de la sección de música
                  const SizedBox(height: 5),
                  MusicPlayer(), //Reproductor de música
                  const SizedBox(height: 20),
                  const PhrasesText(),
                  const YourDayCards(), // Tarjetas de frases e imagenes
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
