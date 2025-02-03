import 'package:flutter/material.dart';

class MessageList extends StatelessWidget {
  final List<String> messages;
  final List<bool> isUserMessage; // Lista que indica si es un mensaje del usuario

  const MessageList({super.key, required this.messages, required this.isUserMessage});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return _buildMessageBubble(messages[index], isUserMessage[index]);
      },
    );
  }

  Widget _buildMessageBubble(String message, bool isUserMessage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Align(
        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft, // Alinea a la derecha o izquierda
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isUserMessage ? Colors.deepPurple[200] : Colors.grey[300], // Color diferente para el usuario y el bot
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            message,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
