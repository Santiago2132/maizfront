import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mAIz/models/shared_preferences.dart';

class CalendarService {
  static final Map<String, String> feelings = {
    'Deprimente': 'assets/icons/Depressed_icon.png',
    'Triste': 'assets/icons/sad_icon.png',
    'Regular': 'assets/icons/so_so_icon.png',
    'Feliz': 'assets/icons/Happy_icon.png',
    'Euforico': 'assets/icons/Euphoric_icon.png',
  };

  static Future<Map<DateTime, List<Map<String, dynamic>>>> fetchMonthlyRawData(
      int year, int month) async {
    final prefsService = SharedPreferencesService();
    final userId = await prefsService.getUserId() as int;

    final String url =
        "http://209.38.6.235/api3/emotions/monthly?id_usuario=$userId&año=$year&mes=$month";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Map<DateTime, List<Map<String, dynamic>>> parsedData = {};

        data.forEach((dateString, emotionsList) {
          final date = DateTime.parse(dateString);
          final List<Map<String, dynamic>> emotions =
              List<Map<String, dynamic>>.from(emotionsList);
          parsedData[date] = emotions;
        });
        return parsedData;
      } else {
        print(
            "Error en la API calendar: ${response.statusCode} - ${response.body}");
        return {};
      }
    } catch (e) {
      print("Error al hacer fetch: $e");
      return {};
    }
  }

  // Devuelve solo la emoción dominante por día
  static Future<Map<DateTime, String>> getDominantEmotionPerDay(
      int year, int month) async {
    final rawData = await fetchMonthlyRawData(year, month);
    final Map<DateTime, String> result = {};

    rawData.forEach((date, emotionsList) {
      if (emotionsList.isNotEmpty) {
        emotionsList.sort((a, b) => b['contador'].compareTo(a['contador']));
        result[date] = emotionsList.first['nombre_emocion'];
      }
    });
    return result;
  }

  //lista calendar
  static Future<List<Map<String, dynamic>>> getDailyDominantEmotionsList(
      int year, int month) async {
    final dominantMap = await getDominantEmotionPerDay(year, month);
    final List<Map<String, dynamic>> result = [];

    final daysInMonth =
        DateTime(year, month + 1, 0).day; // número de días del mes

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final emotion = dominantMap[date];

     result.add({
        'date': date.toIso8601String(),
        'emotion': emotion,
      });

    }
    print(result);
    return result;
  }

  //conteo mensual por dias
  static Future<Map<DateTime, List<String>>> getAllEmotionOccurrencesByDay(
      int year, int month) async {
    final rawData = await fetchMonthlyRawData(year, month);
    final Map<DateTime, List<String>> result = {};

    rawData.forEach((date, emotionsList) {
      result[date] = [];

      for (var emotion in emotionsList) {
        final String nombre = emotion['nombre_emocion'];
        final int count = (emotion['contador'] ?? 1).toInt();

        // Repite la emoción según el contador
        result[date]!.addAll(List.filled(count, nombre));
      }
    });

    return result;
  }

  //grafica semanal
  static Future<Map<String, List<String>>> getEmotionOccurrencesByWeekday(
      int year, int month) async {
    final rawData = await fetchMonthlyRawData(year, month);
    final Map<String, List<String>> result = {
      'Lunes': [],
      'Martes': [],
      'Miércoles': [],
      'Jueves': [],
      'Viernes': [],
      'Sábado': [],
      'Domingo': [],
    };

    // Calcular la semana actual del mes
    final now = DateTime.now();
    final bool isCurrentMonth = now.year == year && now.month == month;
    final int currentWeek = getWeekOfMonth(now);

    rawData.forEach((date, emotionsList) {
      final int weekOfDate = ((date.day - 1) ~/ 7) + 1;

      if (weekOfDate == currentWeek) {
        final String weekday = _getWeekdayName(date);

        for (var emotion in emotionsList) {
          final String nombre = _capitalize(emotion['nombre_emocion']);
          final int count = (emotion['contador'] ?? 1).toInt();
          result[weekday]?.addAll(List.filled(count, nombre));
        }
      }
    });

    return result;
  }


  //contador semanal
  static Future<Map<int, List<String>>> getAllEmotionOccurrencesByWeek(
        int year, int month) async {
      final rawData = await fetchMonthlyRawData(year, month);
      final Map<int, List<String>> result = {};

      rawData.forEach((date, emotionsList) {
        final int weekNumber = getWeekOfMonth(date);
        result[weekNumber] ??= [];

        for (var emotion in emotionsList) {
          final String nombre = emotion['nombre_emocion'];
          final int count = (emotion['contador'] ?? 1).toInt();

          // Repite la emoción según el contador
          result[weekNumber]!.addAll(List.filled(count, nombre));
        }
      });
      return result;
  }
  

  static String _getWeekdayName(DateTime date) {
    const weekdays = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo'
    ];
    // Dart usa 1 = lunes, 7 = domingo
    return weekdays[date.weekday - 1];
  }

  static String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static int getWeekOfMonth(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final firstWeekday = firstDayOfMonth.weekday; // 1 = lunes, 7 = domingo

    final adjustment = firstWeekday - 1; // Cuántos días se corrió la semana
    final dayNumber = date.day + adjustment;

    return ((dayNumber - 1) ~/ 7) + 1;
  }

}
