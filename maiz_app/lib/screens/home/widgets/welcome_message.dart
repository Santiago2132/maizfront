import 'package:flutter/material.dart';
import 'package:mAIz/data/services/user_service.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
   Widget build(BuildContext context) {
    final UserService userService = UserService(); // Instancia del servicio
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder<String>(
      future: userService.getUserName(), // Obtiene el nombre del usuario
      builder: (context, snapshot) {
        String userName = snapshot.data ?? "Usuario"; // Usa un valor por defecto si es null

        return Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'HOLA ',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
               TextSpan(
                  text: '$userName,\n', // Muestra el nombre del usuario
                  style: TextStyle(
                    fontSize: 32,
                    color: isDarkMode ? Colors.white : Colors.black, // Texto
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: 'Bienvenido a mAIz',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}