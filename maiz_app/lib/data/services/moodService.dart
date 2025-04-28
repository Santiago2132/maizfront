import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mAIz/data/services/user_service.dart';

class MoodService {

  final _userService = UserService();
  final String _apiUrl = "http://209.38.6.235/api3/emotions";

  Future<bool> saveMood(String mood, DateTime fecha) async {
   
    final int userIdString = await _userService.getUserId();
    final int userId = int.tryParse(userIdString.toString()) ?? 0;

    if (userId == 0) return false;
    print(userId);
    final String formattedDate =
        "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id_usuario": userId,
          "fecha": formattedDate,
          "nombre_emocion": mood
        }),
      );

      print(response.body);
      if (response.statusCode == 200 || response.statusCode==201) {
        print("Emoción guardada exitosamente");
        return true;
      } else {
        print("Error al guardar emoción: ${response.body}");
        return false;
      }
    } catch (e) {
      print(e.toString());
      print("Error en la solicitud: $e");
      return false;
    }
  }
}
