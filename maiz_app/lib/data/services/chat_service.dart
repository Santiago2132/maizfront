import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String baseUrl =
      'http://192.168.20.71:4000/chat'; // esa ip me sirve en el emulador

  Future<String> sendAndReceiveMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      );
      
      print('Respuesta completa del servidor: ${response.body}'); // <-- Agregué esto

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['response']; // Devuelve la respuesta del chatbot
      } else {
        print('Error al enviar el mensaje: ${response.statusCode}');
        return 'No se pudo procesar tu mensaje';
      }
    } catch (e) {
      print('Error en el chat: $e');
      return 'Error al procesar tu mensaje';
    }
  }
}
