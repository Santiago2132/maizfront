import 'package:flutter/material.dart';
import 'package:maiz_app/data/services/chat_service.dart';
import 'package:maiz_app/screens/home/home_screen.dart';
import 'package:maiz_app/widgets/message_input.dart';
import 'package:maiz_app/widgets/message_list.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> _messages = [];
  final List<bool> _isUserMessage = []; // Lista para controlar si el mensaje es del usuario
  final ChatService _chatService = ChatService(); // Instanciamos el servicio

  // Función para enviar el mensaje
  void _sendMessage(String message) async {
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(message); // Añadimos el mensaje del usuario
        _isUserMessage.add(true); // Añadimos 'true' indicando que es un mensaje del usuario
      });

      // Enviar el mensaje usando el servicio
      await _chatService.sendMessage(message);

      // Recibir un mensaje del "bot"
      String response = await _chatService.receiveMessage();
      setState(() {
        _messages.add(response); // Añadimos la respuesta del bot
        _isUserMessage.add(false); // Añadimos 'false' indicando que es un mensaje del bot
      });
    }
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Colors.deepPurple, // Personaliza el color del AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.home), // Ícono del botón de regresar a Home
            onPressed: () {
              Navigator.pushNamed(context, '/home'); // Navega a la ruta /home
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Aseguramos que los mensajes se muestren hacia abajo
          Expanded(
            child: MessageList(
              messages: _messages,
              isUserMessage: _isUserMessage, // Pasamos la lista de si es mensaje del usuario
            ), // Lista de mensajes
          ),
          MessageInput(onSend: _sendMessage), // Caja de entrada de mensajes
        ],
      ),
    );
  }
}