import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<String> sendAndReceiveMessage(String message) async {
    try {
      // Enviar mensaje
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      );

      if (response.statusCode == 201) {
        print('Mensaje enviado: ${response.body}');
      } else {
        throw Exception('Error al enviar el mensaje');
      }

      // Simular respuesta del servidor
      await Future.delayed(
          const Duration(seconds: 2)); // Simula el tiempo de respuesta
      return 'Respuesta: "Estoy aquí para escucharte"'; // Respuesta simulada
    } catch (e) {
      print('Error en el chat: $e');
      return 'Error al procesar tu mensaje';
    }
  }
}
