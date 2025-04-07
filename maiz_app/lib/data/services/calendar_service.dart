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
    print(result);
    return result;
  }
  static Future<List<Map<String, dynamic>>> getDailyDominantEmotionsList(
      int year, int month) async {
    final dominantMap = await getDominantEmotionPerDay(year, month);
    final List<Map<String, dynamic>> result = [];

    final firstDay = DateTime(year, month, 1);
    final lastDay = (month < 12)
        ? DateTime(year, month + 1, 0)
        : DateTime(year + 1, 1, 0); // último día del mes

    for (int i = 0; i < lastDay.day; i++) {
      final currentDate = DateTime(year, month, i + 1);
      final emotion = dominantMap[currentDate];

      result.add({
        'date': currentDate,
        'emotion': emotion, // puede ser null si no hay emoción ese día
      });
    }

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

  // Conteo semanal
  static Future<Map<int, List<String>>> getAllEmotionOccurrencesByWeek(
      int year, int month) async {
    final rawData = await fetchMonthlyRawData(year, month);
    final Map<int, List<String>> result = {};

    rawData.forEach((date, emotionsList) {
      final int weekNumber = ((date.day - 1) ~/ 7) + 1;
      result[weekNumber] ??= [];

      for (var emotion in emotionsList) {
        final String nombre = emotion['nombre_emocion'];
        final int count = (emotion['contador'] ?? 1).toInt();

        // Repite la emoción según el contador
        result[weekNumber]!.addAll(List.filled(count, nombre));
      }
    });
    print(result);

    return result;
  }
}
