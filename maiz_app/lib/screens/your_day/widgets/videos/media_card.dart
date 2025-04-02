import 'package:flutter/material.dart';
import 'package:mAIz/screens/your_day/widgets/videos/mediaLibraryScreen.dart';

class MediaCard extends StatelessWidget {
  const MediaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MediaLibraryScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFF1C1C1E) // Fondo oscuro en dark mode
              : Colors.white, // Fondo claro en light mode
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.08) // Sombra muy sutil en oscuro
                  : Colors.black12, // Sombra más suave en claro
              blurRadius: 8, 
              spreadRadius: 1, 
              offset: const Offset(0, 4), // Sombra sutil hacia abajo
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Videos & Podcasts",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Icon(
              Icons.video_library,
              color: isDarkMode
                  ? Colors.deepPurple[200] // Púrpura más claro en oscuro
                  : Colors.deepPurple,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
