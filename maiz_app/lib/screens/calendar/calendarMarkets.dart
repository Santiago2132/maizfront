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

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Widget? buildMarker(BuildContext context, DateTime date) {
    DateTime normalizedDate = normalizeDate(date);

    if (emotionalRecords.containsKey(normalizedDate)) {
      String? emotion = emotionalRecords[normalizedDate];
      String? iconPath = feelings[emotion];

    if (iconPath == null) return null; // No renderiza si no hay imagen;

    return Positioned(
          bottom: 2,  // Ajusta la posición para evitar desbordamiento
          right: 2,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // Fondo blanco para mayor visibilidad
            ),
            padding: const EdgeInsets.all(1), // Espaciado interno
            child: Image.asset(
              iconPath,
              width: 14,
              height: 14,
              fit: BoxFit.contain,
            ),
          ),
        );
      }
      return null;
    }
  }