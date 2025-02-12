import 'package:flutter/material.dart';

class CalendarMarkers {
  final Map<DateTime, String> emotionalRecords;

  CalendarMarkers({required this.emotionalRecords});

  final Map<String, String> feelings = {
    'Deprimente': 'assets/icons/Depressed_icon.png',
    'Triste': 'assets/icons/sad_icon.png',
    'Regular': 'assets/icons/so_so_icon.png',
    'Feliz': 'assets/icons/Happy_icon.png',
    'Euforico': 'assets/icons/Euphoric_icon.png',
  };

  final Map<String, Color?> emotionColors = {
    'Deprimente': Colors.purple[900],
    'Triste': Colors.purple[700],
    'Regular': Colors.purple[500],
    'Feliz': Colors.purple[300],
    'Euforico': Colors.purple[100],
  };

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Widget? buildMarker(BuildContext context, DateTime date) {
    DateTime normalizedDate = normalizeDate(date);

    if (emotionalRecords.containsKey(normalizedDate)) {
      String emotion = emotionalRecords[normalizedDate]!;

      return Align(
        alignment: Alignment.topCenter,
        child: Container(
        width: 20, // Ajusta el tamaño del fondo
        height: 20,
        decoration: BoxDecoration(
          color: Color(0xFFF9E7A7),
          shape: BoxShape.circle, 
        ),
          child: Image.asset(
            feelings[emotion] ?? "assets/icons/default_icon.png",
            width: 15,
            height: 15,
          ),
        ),
      );
    }
    return null;
  }
}
