import 'package:flutter/material.dart';

class CalendarMarkers {
  final Map<DateTime, int> emotionalRecords;

  CalendarMarkers({required this.emotionalRecords});

  final Map<int, IconData> emotionIcons = {
    1: Icons.sentiment_very_dissatisfied,
    2: Icons.sentiment_dissatisfied,
    3: Icons.sentiment_neutral,
    4: Icons.sentiment_satisfied,
    5: Icons.sentiment_very_satisfied,
  };

  final Map<int, Color?> emotionColors = {
    1: Colors.purple[900],
    2: Colors.purple[700],
    3: Colors.purple[500],
    4: Colors.purple[300],
    5: Colors.purple[100],
  };

  Widget? buildMarker(BuildContext context, DateTime date) {
    if (emotionalRecords.containsKey(date)) {
      int emotionLevel = emotionalRecords[date]!;
      return Positioned(
        bottom: 5,
        child: Icon(
          emotionIcons[emotionLevel] ?? Icons.help_outline,
          size: 20,
          color: emotionColors[emotionLevel] ?? Colors.grey,
        ),
      );
    }
    return null;
  }
}
