import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MediaService {
  /// Carga los videos desde el archivo JSON
  static Future<List<Map<String, String>>> loadVideos() async {
    final String response = await rootBundle.loadString('assets/media_library.json');
    final Map<String, dynamic> jsonData = jsonDecode(response);
    final List<dynamic> videosList = jsonData["videos"];

    return videosList.map<Map<String, String>>((item) {
      return {
        "emotion": item["emotion"].toString(),
        "title": item["title"].toString(),
        "videoUrl": item["videoUrl"].toString(),
      };
    }).toList();
  }

  /// Filtra los videos según la emoción dada
  static Future<List<Map<String, String>>> getVideosByEmotion(String emotion) async {
    final List<Map<String, String>> mediaLibrary = await loadVideos();

    return mediaLibrary.where((video) {
      return video["emotion"]?.toLowerCase() == emotion.toLowerCase();
    }).toList();
  }
}
