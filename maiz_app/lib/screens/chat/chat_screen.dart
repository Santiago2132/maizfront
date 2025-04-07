import 'package:flutter/material.dart';
import 'package:mAIz/data/services/chat_service.dart';
import 'package:mAIz/screens/chat/widgets_chat/message_input.dart';
import 'package:mAIz/screens/chat/widgets_chat/message_list.dart';
import 'package:mAIz/screens/chat/widgets_chat/selector.dart';
import 'package:rive/rive.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> _messages = [];
  final List<bool> _isUserMessage = [];
  bool _isTyping = false;
  String _chatMode = 'premium'; // Modo por defecto

  final ChatService _chatService = ChatService();
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _fetchChatMode();
    _controller =
        SimpleAnimation('idle'); // Usa el nombre exacto de tu animación
  }

  void _fetchChatMode() async {
    String mode = await _chatService.getChatMode();
    setState(() {
      _chatMode = mode;
    });
  }

  void _sendMessage(String text) async {
    setState(() {
      _messages.add(text);
      _isUserMessage.add(true);
      _isTyping = true;
    });

    String botResponse = _chatMode == 'premium'
        ? await _chatService.sendMessagePro(text)
        : await _chatService.sendMessage(text);

    if (!mounted) return;

    setState(() {
      _messages.add(botResponse);
      _isUserMessage.add(false);
      _isTyping = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Freudy", style: TextStyle( color: isDarkMode ? Colors.white: Colors.white)),
        backgroundColor: _chatMode == 'premium' ? Colors.amber : Colors.deepPurple,
        actions: [
          ChatModeSelector(onModeChanged: _fetchChatMode), // Recarga cuando se cambia el modo
        ],
      ),
      body: Stack(
        children: [
          // Mensaje de bienvenida si no hay mensajes
          if (_messages.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 150, // Ajusta el tamaño según tu animación
                      width: 150,
                      child: RiveAnimation.asset(
                        'assets/rive/sorprendido2.riv',
                        controllers: [_controller],
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                     Text(
                      "¡Hola! Soy Freudy 🤖\nTu asistente virtual emocional.\nEstoy aquí para acompañarte.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18,  color: isDarkMode ? Colors.white: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

          // Lista de mensajes
          Column(
            children: <Widget>[
              Expanded(
                child: MessageList(
                  messages: _messages,
                  isUserMessage: _isUserMessage,
                  isTyping: _isTyping,
                ),
              ),
              MessageInput(onSend: _sendMessage),
            ],
          ),
        ],
      ),
    );
  }
}


/*
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> _messages = [];
  final List<bool> _isUserMessage = [];
  bool _isTyping = false;
  String _chatMode = 'basic'; // Modo por defecto

  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _fetchChatMode();
  }

  void _fetchChatMode() async {
    String mode = await _chatService.getChatMode();
    setState(() {
      _chatMode = mode;
    });
  }

 void _sendMessage(String text) async {
  setState(() {
    _messages.add(text);
    _isUserMessage.add(true);
    _isTyping = true; // Activamos el estado "escribiendo..."
  });

  String botResponse = await _chatService.sendAndReceiveMessage(text);

  setState(() {
    _messages.add(botResponse);
    _isUserMessage.add(false);
    _isTyping = false; // Desactivamos la burbuja de carga
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _chatMode == 'premium' ? Colors.amber : Colors.deepPurple,
        actions: [
          ChatModeSelector(onModeChanged: _fetchChatMode), // Recarga cuando se cambia el modo
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageList(
              messages: _messages,
              isUserMessage: _isUserMessage,
              isTyping: _isTyping,
            ),
          ),
          MessageInput(onSend: _sendMessage),
        ],
      ),
    );
  }
}
*/