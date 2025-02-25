import 'package:flutter/material.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/screens/your_day/widgets/phrases_screen.dart';
import 'package:provider/provider.dart';

class PhrasesCard extends StatelessWidget {
  const PhrasesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double fontSizeProvider = Provider.of<FontSizeProvider>(context).fontSize;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PhrasesScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFF1C1C1E) // Color oscuro
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1) // Sombra más suave en oscuro
                  : Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Ver Frases del Día",
              style: TextStyle(
                fontSize: fontSizeProvider,
                fontWeight: FontWeight.bold,
                color:
                    isDarkMode ? Colors.white : Colors.black, // Texto adaptable
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDarkMode
                  ? Colors.deepPurple[200] // Púrpura más claro en oscuro
                  : Colors.deepPurple,
            ),
          ],
        ),
      ),
    );
  }
}
