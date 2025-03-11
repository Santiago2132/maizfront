import 'package:shared_preferences/shared_preferences.dart';

class EmotionStorage {
  static const _key = 'user_emotions';

  // Guardar una emoción con la fecha actual
  static Future<void> saveEmotion(String emotion) async {
    final prefs = await SharedPreferences.getInstance();
    final emotions = await getEmotions();

    emotions.add({
      'date': DateTime.now().toIso8601String(),
      'emotion': emotion,
    });

    await prefs.setStringList(_key, emotions.map((e) => e.toString()).toList());
  }

  // Obtener todas las emociones guardadas
  static Future<List<Map<String, String>>> getEmotions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? emotionStrings = prefs.getStringList(_key);

    return emotionStrings?.map((e) {
          final parts = e.replaceAll("{", "").replaceAll("}", "").split(", ");
          return {
            'date': parts[0].split(": ")[1],
            'emotion': parts[1].split(": ")[1],
          };
        }).toList() ??
        [];
  }
}
