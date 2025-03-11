import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String baseUrl = 'http://0.0.0.0:5000/chat'; // esa ip me sirve en el emulador

  Future<String> sendAndReceiveMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['response']; // Devuelve la respuesta del chatbot
      } else {
        throw Exception('Error al enviar el mensaje: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en el chat: $e');
      return 'Error al procesar tu mensaje';
    }
  }
}
