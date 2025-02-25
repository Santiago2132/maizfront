
import 'package:flutter/material.dart';

class DayNumber extends StatelessWidget {
  final DateTime date;

  const DayNumber({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 36, 
      height: 36,
      alignment: Alignment.topCenter,
      child: Text(
        '${date.day}',
        style:  TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black, // Texto

        ),
      ),
    );
  }
}
