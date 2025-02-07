
class CalendarService {
  static Future<Map<DateTime, int>> getEmotionalRecords() async {
    await Future.delayed(Duration(milliseconds: 500)); // Simula carga de datos

    // Simula registros emocionales para fechas específicas
    Map<DateTime, int> emotionalRecords = {
      DateTime.utc(2024, 2, 1): 5, // Muy bien
      DateTime.utc(2024, 2, 3): 4, // Bien
      DateTime.utc(2024, 2, 5): 3, // Neutral
      DateTime.utc(2024, 2, 7): 2, // Mal
      DateTime.utc(2024, 2, 10): 1, // Muy mal
    };

    return emotionalRecords;
  }
}

