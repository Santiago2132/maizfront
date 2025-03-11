import 'package:flutter/material.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:provider/provider.dart';

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
        return _buildMessageBubble(context, messages[index], isUserMessage[index]);
      },
    );
  }

  Widget _buildMessageBubble(BuildContext context, String message, bool isUserMessage) {
    double fontSize = Provider.of<FontSizeProvider>(context).fontSize; 
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
            style: TextStyle(fontSize: fontSize,
             color:
                    isDarkMode ? Colors.black : Colors.black) // Texto adaptable),
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
