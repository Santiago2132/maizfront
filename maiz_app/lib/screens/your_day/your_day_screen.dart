import 'package:flutter/material.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/screens/your_day/messages/phrases_text.dart';
import 'package:mAIz/screens/your_day/messages/text_breathing.dart';
import 'package:mAIz/screens/your_day/messages/text_music.dart';
import 'package:mAIz/screens/your_day/messages/your_day_message.dart';
import 'package:mAIz/screens/your_day/widgets/breathing_exercise.dart';
import 'package:mAIz/screens/your_day/widgets/music_player.dart';
import 'package:mAIz/screens/your_day/widgets/phrases_card.dart';
import 'package:mAIz/screens/your_day/widgets/videos/media_card.dart';
import 'package:mAIz/screens/your_day/widgets/videos/podast_player.dart';
import 'package:mAIz/screens/your_day/widgets/videos/video_player.dart';
import 'package:provider/provider.dart';


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
                  const SizedBox(height: 15),
                  const BreathingExercise(), // Ejercicio de respiración
                  const SizedBox(height: 15),
                  const TextMusic(), // Texto de la sección de música
                  const SizedBox(height: 15),
                  const SizedBox(
                    height: 265,
                    child: MusicPlayer(),),
                  const SizedBox(height: 15),
                  //const PhrasesText(),
                  const PhrasesCard(), // Tarjetas de frases e imagenes
                  const SizedBox(height: 15),
                  MediaCard()


                   
                 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
