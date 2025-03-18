import 'package:flutter/material.dart';
import 'package:mAIz/screens/login/login_screen.dart';
import 'package:animate_do/animate_do.dart'; // Librería para animaciones

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo con efecto de fade-in
          Positioned.fill(
            child: FadeIn(
              duration: const Duration(seconds: 2),
              child: Image.asset(
                'assets/resources/fondoMorado.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido sobre la imagen de fondo con animaciones
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título principal con animación
                BounceInDown(
                  duration: const Duration(milliseconds: 1500),
                  child: const Text(
                    'mAIz  Chat',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black87,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),

                // Subtítulo con animación de fade-in
                FadeInUp(
                  duration: const Duration(milliseconds: 2000),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Tu compañero emocional, siempre aquí para ti',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.white,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20), // Espacio

                // Botón con animación de escala y fade-in
                ZoomIn(
                  duration: const Duration(milliseconds: 2000),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}