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
  Map<DateTime, int> _emotionalRecords = {};

  @override
  void initState() {
    super.initState();

    // Fetch emotional records directly from CalendarService
    CalendarService.getEmotionalRecords().then((records) {
      setState(() {
        _emotionalRecords = records;
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
      appBar: CustomAppBar(), // El CustomAppBar ahora está en la propiedad 'appBar'
      body: CalendarContainer(
        focusedDay: _focusedDay,
        selectedDay: _selectedDay,
        onDaySelected: _onDaySelected,
        emotionalRecords: _emotionalRecords,
      ),
    );
  }
}

