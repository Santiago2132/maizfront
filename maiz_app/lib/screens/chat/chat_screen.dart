import 'package:flutter/material.dart';
import 'package:mAIz/data/services/chat_service.dart';
import 'package:mAIz/screens/chat/widgets_chat/message_input.dart';
import 'package:mAIz/screens/chat/widgets_chat/message_list.dart';
import 'package:mAIz/screens/chat/widgets_chat/selector.dart';

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
      _isTyping = true;
    });

    String botResponse = await _chatService.sendAndReceiveMessage(text);

    setState(() {
      _messages.add(botResponse);
      _isUserMessage.add(false);
      _isTyping = false;
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
