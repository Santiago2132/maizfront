import 'package:flutter/material.dart';


class AddEmotionButton extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;

  const AddEmotionButton({Key? key, required this.date, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 14, 
          height: 16,
          decoration: const BoxDecoration(
            color: Colors.deepPurple,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, size: 12, color: Colors.white),
        ),
      ),
    );
  }
}
