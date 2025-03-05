import 'package:flutter/material.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:provider/provider.dart';

class MessageList extends StatefulWidget {
  final List<String> messages;
  final List<bool> isUserMessage;
  final bool isTyping;

  const MessageList({
    super.key,
    required this.messages,
    required this.isUserMessage,
    required this.isTyping,
  });

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void didUpdateWidget(covariant MessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length > oldWidget.messages.length || widget.isTyping != oldWidget.isTyping) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.messages.length + (widget.isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.messages.length && widget.isTyping) {
          return _typingIndicator();
        }
        return _buildMessageBubble(
          context,
          widget.messages[index],
          widget.isUserMessage[index],
        );
      },
    );
  }

  Widget _buildMessageBubble(BuildContext context, String message, bool isUserMessage) {
    double fontSize = Provider.of<FontSizeProvider>(context).fontSize;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color userMessageColor = isUserMessage
        ? (isDarkMode ? Colors.deepPurpleAccent : Colors.deepPurple)
        : (isDarkMode ? Colors.blueGrey : Colors.yellow);

    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Align(
        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: userMessageColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            message,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor,
            ),
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
