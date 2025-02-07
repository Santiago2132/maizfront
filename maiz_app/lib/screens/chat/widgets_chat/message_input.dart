import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final Function(String) onSend; // Recibe la función para enviar el mensaje

  const MessageInput({super.key, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

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
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: () {
              onSend(controller.text); // Llama a la función onSend cuando se presiona el botón
              controller.clear(); // Limpia el campo de texto después de enviar
            },
            backgroundColor: Colors.deepPurple,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
