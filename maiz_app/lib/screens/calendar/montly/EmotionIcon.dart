import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/data/services/calendar_service.dart';
import 'package:mAIz/widgets/custom_card.dart';
import 'package:provider/provider.dart';

class EmotionIcon extends StatelessWidget {
  final String emotion;

  EmotionIcon({required this.emotion});

  final Map<String, String> emotionIcons = CalendarService.feelings;

  @override
  Widget build(BuildContext context) {
    if (!emotionIcons.containsKey(emotion)) return const SizedBox.shrink();

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDarkMode ? Colors.black : Colors.white,
      ),
      padding: const EdgeInsets.all(2),
      child: Image.asset(
        emotionIcons[emotion]!,
        width: 20,
        height: 20,
        fit: BoxFit.contain,
      ),
    );
  }
}
