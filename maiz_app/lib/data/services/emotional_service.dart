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

  static Future<Map<int, String>> fetchMonthlyEmotions(
      int year, int month) async {
    final records = await CalendarService.getDominantEmotionPerDay(year, month);

    final Map<int, String> monthlyEmotions = {};

    records.forEach((date, emotion) {
      if (date.year == year && date.month == month) {
        monthlyEmotions[date.day] = emotion;
      }
    });

    return monthlyEmotions;
  }

  static Future<List<FlSpot>> fetchAllEmotionSpots(int year, int month) async {
    final data = await CalendarService.getAllEmotionOccurrencesByDay(year, month);
    final List<FlSpot> allSpots = [];

    data.forEach((date, emotions) {
      for (var emotion in emotions) {
        final double? y = emotionYValues[emotion];
        if (y != null) {
          allSpots.add(FlSpot(date.day.toDouble(), y));
        }
      }
    });

    return allSpots;
  }


  static Future<List<FlSpot>> fetchMonthlyStatistics(
      int year, int month) async {
    final records = await fetchMonthlyEmotions(year, month);

    final List<FlSpot> spots = [];

    records.forEach((day, emotion) {
      final double yValue = emotionYValues[emotion] ?? 0;
      spots.add(FlSpot(day.toDouble(), yValue));
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
