import 'package:flutter/material.dart';
import 'package:mAIz/data/services/chat_service.dart';
import 'package:mAIz/screens/navegator/main_screen.dart';
import 'package:mAIz/screens/chat/widgets_chat/message_input.dart';
import 'package:mAIz/screens/chat/widgets_chat/message_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

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
        _messages.add(message); // Añadi el mensaje del usuario
        _isUserMessage.add(true); 
      });

      // Enviar el mensaje usando el servicio
      await _chatService.sendMessage(message);

      // Recibir un mensaje del "bot"
      String response = await _chatService.receiveMessage();
      setState(() {
        _messages.add(response); //  respuesta del bot
        _isUserMessage.add(false); // 'false' indicando que es un mensaje del bot
      });
    }
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
          title: const Text('Freuddy'),
          backgroundColor: Colors.deepPurple,
          leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Reemplaza la pantalla actual con Home
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()), 
              (route) => false, // Elimina todas las rutas anteriores
            );
          },
        ),
        
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