import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:mAIz/models/shared_preferences.dart';
import 'dart:convert';

class CalendarService {
  static final Map<DateTime, String> _emotionalRecords = {}; 

  static final Map<String, String> feelings = {
    'Deprimente': 'assets/icons/Depressed_icon.png',
    'Triste': 'assets/icons/sad_icon.png',
    'Regular': 'assets/icons/so_so_icon.png',
    'Feliz': 'assets/icons/Happy_icon.png',
    'Euforico': 'assets/icons/Euphoric_icon.png',
  };

  static Future<void> generateFakeData() async {
    final random = Random();
    final List<String> emotions = feelings.keys.toList(); 

    for (int i = 1; i <= 15; i++) {
      DateTime randomDate = DateTime(2025, 2, random.nextInt(28) + 1);
      _emotionalRecords[randomDate] = emotions[random.nextInt(emotions.length)];
    }
  }

  static Future<void> saveEmotion(DateTime date, String emotion) async {
    _emotionalRecords[DateTime(date.year, date.month, date.day)] = emotion;
  }

  static Future<Map<DateTime, String>> getEmotionalRecords(int year, int month) async {
    
    final prefsService = SharedPreferencesService();
    final userId = await prefsService.getUserId() as int;

    final String url = "http://209.38.6.235/api3/emotions/monthly?id_usuario=$userId&año=$year&mes=$month";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        Map<DateTime, String> emotionalRecords = {};

        data.forEach((dateString, emotionsList) {
          if (emotionsList.isNotEmpty) {
            List<Map<String, dynamic>> emotions = List<Map<String, dynamic>>.from(emotionsList);

            // Obtener la emoción con el mayor contador
            emotions.sort((a, b) => b["contador"].compareTo(a["contador"]));
            String dominantEmotion = emotions.first["nombre_emocion"];

            DateTime date = DateTime.parse(dateString);
            emotionalRecords[date] = dominantEmotion;
          }
        });

        return emotionalRecords;
      } else {
        print("Error en la API: ${response.statusCode} - ${response.body}");
        return {};
      }
    } catch (e) {
      print("Error en la solicitud: $e");
      return {};
    }
  }
}
