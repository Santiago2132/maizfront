import 'package:flutter/material.dart';
import 'package:maiz_app/screens/home/widgets/feeling_card.dart';
import 'package:maiz_app/screens/home/widgets/progress_card.dart';
import 'package:maiz_app/screens/home/widgets/stats_card.dart';
import 'package:maiz_app/screens/home/widgets/welcome_message.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de pantalla
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondoAmarillo.png'), // Ruta de tu imagen
                fit: BoxFit.cover, // Ajusta la imagen a toda la pantalla
              ),
            ),
          ),
          // Contenido principal
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  const WelcomeMessage(),
                  const SizedBox(height: 30),
                  const FeelingCard(),
                  const SizedBox(height: 30),
                  const StatsCard(),
                  const SizedBox(height: 30),
                  const ProgressCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}