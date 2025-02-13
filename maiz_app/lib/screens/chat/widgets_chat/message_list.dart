import 'package:flutter/material.dart';


class MessageList extends StatelessWidget {
  final List<String> messages;
  final List<bool> isUserMessage;
  final bool isTyping;

  const MessageList({super.key, required this.messages, required this.isUserMessage, required this.isTyping});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && isTyping) {
          return _typingIndicator();
        }
        return _buildMessageBubble(messages[index], isUserMessage[index]);
      },
    );
  }

  Widget _buildMessageBubble(String message, bool isUserMessage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Align(
        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isUserMessage ? Colors.deepPurple[200] : Colors.yellow[200],
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

  Widget _typingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.yellow[200],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Text(
            "...",
            style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }
}
