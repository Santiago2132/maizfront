import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final Function(String) onSend;

  const MessageInput({super.key, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final TextEditingController controller = TextEditingController();

    void sendMessage() {
      if (controller.text.trim().isNotEmpty) {
        onSend(controller.text.trim()); // Enviar mensaje
        controller.clear(); // Limpiar campo de texto
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje...',
                filled: true,
                fillColor:   isDarkMode ? Colors.black : Colors.white, // Texto 
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                
              ),
              onSubmitted: (value) => sendMessage(), // Enviar con Enter
            ),
          ),
          const SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: sendMessage, // Enviar con el botón
            backgroundColor: Colors.deepPurple,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
