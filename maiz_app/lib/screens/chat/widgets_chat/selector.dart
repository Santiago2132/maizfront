import 'package:flutter/material.dart';
import 'package:mAIz/data/services/chat_service.dart';

class ChatModeSelector extends StatefulWidget {
  final void Function(String mode) onModeChanged;

  const ChatModeSelector({super.key, required this.onModeChanged});


  @override
  _ChatModeSelectorState createState() => _ChatModeSelectorState();
}

class _ChatModeSelectorState extends State<ChatModeSelector> {
  String _currentMode = 'basic';
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _loadChatMode();
  }

  Future<void> _loadChatMode() async {
    String mode = await _chatService.getChatMode();
    setState(() {
      _currentMode = mode;
    });
  }

  void _changeChatMode(String mode) async {
    await _chatService.setChatMode(mode);
    setState(() {
      _currentMode = mode;
    });
    print(_currentMode);
    widget.onModeChanged(mode); // Envía el nuevo modo
  }


  @override
  Widget build(BuildContext context) {

    return PopupMenuButton<String>(
      onSelected: _changeChatMode,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      itemBuilder: (context) => [
        _buildMenuItem('basic', 'Chat Freudy 2.0', Icons.lightbulb_outline),
        _buildMenuItem('premium', 'Chat Freudy Pro', Icons.workspace_premium),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _currentMode == 'basic'
                  ? Icons.lightbulb_outline
                  : Icons.workspace_premium,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              _currentMode == 'basic' ? 'Chat Freudy 2.0' : 'Chat Freudy Pro',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(
      String value, String text, IconData icon) {
    bool isSelected = value == _currentMode;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: isSelected ? Colors.deepPurple : isDarkMode ? Colors.white : Colors.black),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.deepPurple : isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          if (isSelected)
            const Icon(Icons.check, color: Colors.deepPurple, size: 18),
        ],
      ),
    );
  }
}
