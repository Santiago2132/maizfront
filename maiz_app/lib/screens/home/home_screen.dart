import 'package:flutter/material.dart';
import 'package:mAIz/screens/home/widgets/feeling_card.dart';
import 'package:mAIz/screens/home/widgets/progress_card.dart';
import 'package:mAIz/screens/home/widgets/graphic_card.dart';
import 'package:mAIz/screens/home/widgets/welcome_message.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /*
          // Fondo de pantalla
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/resources/fondoAmarillo.png'), // Ruta de tu imagen
                fit: BoxFit.cover, // Ajusta la imagen a toda la pantalla
              ),
            ),
          ),
          */
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
                  FeelingCard(
                    onEmotionSelected: () =>
                        setState(() {}), // Actualizar estado
                  ),
                  const SizedBox(height: 30),
                  GraphicCard(),
                  const SizedBox(height: 30),
                  ProgressCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
