import 'package:flutter/material.dart';
import 'package:mAIz/screens/calendar/calendarMarkets.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarContainer extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final Map<DateTime, String> emotionalRecords;
  final CalendarMarkers calendarMarkers;

  const CalendarContainer({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.emotionalRecords,
    required this.calendarMarkers,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2025, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: onDaySelected,
      calendarFormat: CalendarFormat.month,
      availableGestures: AvailableGestures.all,
      headerStyle: const HeaderStyle(formatButtonVisible: false),
      calendarStyle: const CalendarStyle(
        markersAlignment: Alignment.center, // No afecta aquí, lo corregimos abajo
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, focusedDay) {
          return Stack(
            alignment: Alignment.center, // Centra todo
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  '${date.day}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              calendarMarkers.buildMarker(context, date) ?? Container(), // Agrega el ícono en el centro
            ],
          );
        },
      ),
    );
  }

}
