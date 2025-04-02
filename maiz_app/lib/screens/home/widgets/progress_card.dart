import 'package:flutter/material.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/widgets/custom_card.dart';
import 'package:mAIz/models/emotion_storage.dart';
import 'package:provider/provider.dart';

class ProgressCard extends StatelessWidget {
  final Map<String, String> emotionIcons = {
    'Deprimente': 'assets/icons/Depressed_icon.png',
    'Triste': 'assets/icons/sad_icon.png',
    'Regular': 'assets/icons/so_so_icon.png',
    'Feliz': 'assets/icons/Happy_icon.png',
    'Euforico': 'assets/icons/Euphoric_icon.png',
  };

  Future<Map<String, int>> getWeeklyEmotionCounts() async {
    final emotions = await EmotionStorage.getEmotions();
    final today = DateTime.now();
    final firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));

    final counts = {
      'Deprimente': 0,
      'Triste': 0,
      'Regular': 0,
      'Feliz': 0,
      'Euforico': 0,
    };

    for (var emotion in emotions) {
      final date = DateTime.parse(emotion['date']!);
      if (date.isAfter(firstDayOfWeek.subtract(const Duration(days: 1)))) {
        counts[emotion['emotion']!] = (counts[emotion['emotion']!] ?? 0) + 1;
      }
    }

    return counts;
  }

  @override
  Widget build(BuildContext context) {
  final fontSizeProvider = Provider.of<FontSizeProvider>(context).fontSize;

    return CustomCard(
      // Deja el título vacío
      title: '',
      height: 400,
      child: Column(
        children: [
           Text(
            'Contador semanal',
            style: TextStyle(
              fontSize: fontSizeProvider,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return FutureBuilder<Map<String, int>>(
                future: getWeeklyEmotionCounts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF673AB7),
                      ),
                    );
                  }

                  final counts = snapshot.data ?? {};

                  return Column(
                    children: [
                      const SizedBox(height: 15),
                      ...counts.entries.map(
                        (entry) => _buildEmotionRow(
                          emotion: entry.key,
                          count: entry.value,
                          icon: emotionIcons[entry.key]!,
                          maxWidth: constraints.maxWidth,
                          context: context
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).padding.bottom),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionRow({
    required String emotion,
    required int count,
    required String icon,
    required double maxWidth,
    required BuildContext context, // Agrega el contexto aquí
  }) {
    final isSmallScreen = maxWidth < 350;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: isSmallScreen ? 8.0 : 16.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFF673AB7).withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                width: isSmallScreen ? 36 : 40,
                height: isSmallScreen ? 36 : 40,
              ),
              SizedBox(width: isSmallScreen ? 12 : 20),
              Expanded(
                child: Text(
                  emotion,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 15 : 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF673AB7),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 10 : 14,
                    vertical: isSmallScreen ? 5 : 7),
                decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color.fromARGB(255, 54, 53, 53)
                    : Color(0xFFFFD740).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      count.toString(),
                      style: TextStyle(
                          fontSize: isSmallScreen ? 15 : 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF673AB7)),
                    ),
                    SizedBox(width: isSmallScreen ? 4 : 6),
                    Icon(
                      Icons.emoji_emotions_outlined,
                      size: isSmallScreen ? 18 : 20,
                      color: isDarkMode
                        ? const Color.fromARGB(255, 244, 240, 240)
                        : Color(0xFFFFD740).withOpacity(0.15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
