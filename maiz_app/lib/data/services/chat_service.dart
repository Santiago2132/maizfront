import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  // URL simulada del servicio 
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  // Función para enviar un mensaje (input)
  Future<void> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}), // cuando sirva la API
      );

      if (response.statusCode == 201) {
        print('Mensaje enviado: ${response.body}');
      } else {
        throw Exception('Error al enviar el mensaje');
      }
    } catch (e) {
      print('Error al enviar el mensaje: $e');
    }
  }

  // Función para recibir/responder un mensaje (simulación - aqui va lo de IA)
  Future<String> receiveMessage() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        //  mensaje de respuesta del servidor
        var responseData = json.decode(response.body);
        //return 'Respuesta: ${responseData[0]['title']}';  // cuando la respuesta sirva :)
        return 'Respuesta: ${'Te habla tu chat emocional'}';
      } else {
        throw Exception('Error al recibir el mensaje');
      }
    } catch (e) {
      print('Error al recibir el mensaje: $e');
      return 'Error al recibir el mensaje';
    }
  }
}
