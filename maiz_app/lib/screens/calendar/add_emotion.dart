import 'package:flutter/material.dart';

class AddEmotionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddEmotionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 16,
        height: 16,
        decoration: const BoxDecoration(
          color: Colors.grey, // Color del botón
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.add,
          size: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}
