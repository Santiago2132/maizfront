import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:mAIz/data/services/calendar_service.dart';

class EmotionService {
  static final Map<String, double> emotionYValues = {
    'Deprimente': 0,
    'Triste': 1,
    'Regular': 2,
    'Feliz': 3,
    'Euforico': 4,
  };

  static Future<List<FlSpot>> fetchMonthlyStatistics(int year, int month) async {
    final records = await CalendarService.getEmotionalRecords();
    final List<FlSpot> spots = [];

    records.forEach((date, emotion) {
      if (date.year == year && date.month == month) {
        spots.add(FlSpot(date.day.toDouble(), emotionYValues[emotion] ?? 0));
      }
    });

    return spots;
  }


  static double calculateMonthlyAverage(List<FlSpot> data) {
    if (data.isEmpty) return 2.0;

    final total = data.map((spot) => spot.y).reduce((a, b) => a + b);
    return total / data.length;
  }

  static int getDaysWithEmotion(String emotion, List<FlSpot> data) {
    final targetValue = emotionYValues[emotion];
    if (targetValue == null) return 0;

    return data.where((spot) => spot.y.round() == targetValue.round()).length;
  }

  static String getEmotionByValue(double value) {
    return emotionYValues.entries
        .firstWhere((entry) => entry.value == value,
            orElse: () => const MapEntry('', -1))
        .key;
  }
}
