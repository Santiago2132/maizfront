import 'package:flutter/material.dart';
import 'package:mAIz/data/services/chat_service.dart';
import 'package:mAIz/screens/chat/widgets_chat/message_input.dart';
import 'package:mAIz/screens/chat/widgets_chat/message_list.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> _messages = [];
  final List<bool> _isUserMessage = [];
  bool _isTyping = false;

  final ChatService _chatService = ChatService();

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
        title: const Text('Freuddy'),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
