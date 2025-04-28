import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl = "http://10.154.12.13:4000/api/ask";
  final String urlApi = "http://10.153.90.103:4000/chat";

  //'http://192.168.253.111:5000/chat'; // esa ip me sirve en el emulador

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(urlApi),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['response']; // Devuelve la respuesta del chatbot
      } else {
        throw Exception('Error al enviar el mensaje: ${response.body}');
      }
    } catch (e) {
      print('Error en el chat: $e');
      return 'Error al procesar tu mensaje';
    }
  }

  Future<String> sendMessagePro(String message) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'query': message}),
      );

      print("Código de estado: ${response.statusCode}");
      print("Respuesta del servidor: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['response'] ?? 'Respuesta no válida';
      } else if (response.statusCode == 404) {
        return 'Error 404: La API no encontró la ruta. Verifica la URL con el backend.';
      } else {
        throw Exception('Error al enviar el mensaje: ${response.body}');
      }
    } catch (e) {
      print('Error en el chat: $e');
      return 'Error al procesar tu mensaje';
    }
  }

  Future<String> getChatMode() async {
    // Simulación
    await Future.delayed(const Duration(milliseconds: 500));
    return 'basic'; // Cambia esto a 'premium' si lo deseas
  }

  Future<void> setChatMode(String mode) async {
    // Simulación de guardado
    await Future.delayed(const Duration(milliseconds: 500));
    print('Modo de chat guardado: $mode');
  }
}
