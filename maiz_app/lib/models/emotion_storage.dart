import 'package:mAIz/data/services/moodService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EmotionStorage {
  static const _key = 'user_emotions';
  static MoodService mood = MoodService();

  // Guardar una emoción con la fecha actual
  static Future<void> saveEmotion(String emotion) async {
    final prefs = await SharedPreferences.getInstance();

    print('Intentando guardar emoción: $emotion');
    final bool success = await mood.saveMood(emotion);

    if (!success) {
      print(' Error: No se pudo guardar la emoción en el servidor');
      return;
    }
    
    print('Emoción guardada en el servidor con éxito');

    // Obtener las emociones guardadas localmente
    final emotions = await getEmotions();

    // Agregar la nueva emoción
    emotions.add({
      'date': DateTime.now().toIso8601String(),
      'emotion': emotion,
    });

    // Guardar en SharedPreferences usando JSON
    final encodedEmotions = emotions.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList(_key, encodedEmotions);

    print('✅ Emoción guardada localmente en SharedPreferences');
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
