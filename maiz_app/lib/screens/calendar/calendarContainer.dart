import 'package:flutter/material.dart';
import 'package:mAIz/screens/calendar/calendarMarkets.dart';
import 'package:table_calendar/table_calendar.dart';


class CalendarContainer extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final Map<DateTime, int> emotionalRecords;

  const CalendarContainer({super.key, 
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.emotionalRecords,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        calendarStyle: _buildCalendarStyle(),
        headerStyle: _buildHeaderStyle(),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            return CalendarMarkers(emotionalRecords: emotionalRecords).buildMarker(context, date);
          },
        ),
      ),
    );
  }

  CalendarStyle _buildCalendarStyle() {
    return CalendarStyle(
      todayDecoration: BoxDecoration(
        color: Colors.deepPurple,
        shape: BoxShape.circle,
      ),
      selectedDecoration: BoxDecoration(
        color: Colors.purple[300],
        shape: BoxShape.circle,
      ),
      defaultTextStyle: TextStyle(color: Colors.purple[900]),
      weekendTextStyle: TextStyle(color: Colors.purple[900]),
    );
  }

  HeaderStyle _buildHeaderStyle() {
    return HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      leftChevronIcon: Icon(Icons.chevron_left, color: Colors.purple[300]),
      rightChevronIcon: Icon(Icons.chevron_right, color: Colors.purple[300]),
    );
  }
}
