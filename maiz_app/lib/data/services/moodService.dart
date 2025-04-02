import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mAIz/data/services/user_firebase_service.dart';

class MoodService {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _userService = UserService();
  final String _apiUrl = "http://209.38.6.235/api3/emotions";

  Future<void> saveMood(String mood) async {
    final userId = _userService.getUserId();
    if (userId == null) return;

    final DateTime now = DateTime.now();
    final String formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final Map<String, dynamic> body = {
      "id_usuario": userId,
      "fecha": formattedDate,
      "nombre_emocion": mood
    };

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("Emoción guardada exitosamente");
      } else {
        print("Error al guardar emoción: \${response.body}");
      }
    } catch (e) {
      print("Error en la solicitud: \$e");
    }
  }
}


