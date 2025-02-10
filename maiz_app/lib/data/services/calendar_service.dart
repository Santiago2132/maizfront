class CalendarService {
  static Future<Map<DateTime, String>> getEmotionalRecords() async {
    await Future.delayed(Duration(milliseconds: 500)); // Simula carga de datos

    // Mapeo de emociones en formato String
    final Map<int, String> emotionMapping = {
      1: "Deprimente",
      2: "Triste",
      3: "Regular",
      4: "Feliz",
      5: "Euforico",
    };

    // Simula registros emocionales para fechas específicas
    Map<DateTime, int> rawRecords = {
      DateTime.utc(2025, 2, 2): 5, // Muy bien
      DateTime.utc(2025, 2, 3): 4, // Bien
      DateTime.utc(2025, 2, 5): 3, // Neutral
      DateTime.utc(2025, 2, 7): 2, // Mal
      DateTime.utc(2025, 2, 10): 1, // Muy mal
    };

    // Convertir valores de int a String
    Map<DateTime, String> emotionalRecords = rawRecords.map(
      (key, value) => MapEntry(key, emotionMapping[value] ?? "Regular"),
    );

    return emotionalRecords;
  }
}
