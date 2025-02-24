import 'package:flutter/material.dart';
import 'package:mAIz/data/services/calendar_service.dart';
import 'package:mAIz/screens/calendar/calendarBar.dart';
import 'package:mAIz/screens/calendar/calendarContainer.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, String> _emotionalRecords = {}; 

  @override
  void initState() {
    super.initState();

    CalendarService.getEmotionalRecords().then((records) {
      setState(() {
        _emotionalRecords = records.map((key, value) => MapEntry(
              DateTime(key.year, key.month, key.day), // Normaliza la fecha
              value,
            ));
      });
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  @override
 Widget build(BuildContext context) {
  return Scaffold(
    appBar: CustomAppBar(),
    body: CalendarContainer(
      focusedDay: _focusedDay,
      selectedDay: _selectedDay,
      onDaySelected: _onDaySelected,
    ),
  );
}

}
