
import 'package:flutter/material.dart';

class DayNumber extends StatelessWidget {
  final DateTime date;

  const DayNumber({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36, 
      height: 36,
      alignment: Alignment.topCenter,
      child: Text(
        '${date.day}',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
