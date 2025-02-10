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
  Map<DateTime, String> _emotionalRecords = {}; // Cambiado a Map<DateTime, String>

  @override
  void initState() {
    super.initState();

   CalendarService.getEmotionalRecords().then((records) {
      setState(() {
        _emotionalRecords = records; // Ya está en el formato correcto
      });
    });

  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  String _convertEmotion(int emotionLevel) {
    final Map<int, String> emotionMapping = {
      1: "Deprimente",
      2: "Triste",
      3: "Regular",
      4: "Feliz",
      5: "Euforico",
    };
    return emotionMapping[emotionLevel] ?? "Regular"; // Default to "Regular" if not found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: CalendarContainer(
        focusedDay: _focusedDay,
        selectedDay: _selectedDay,
        onDaySelected: _onDaySelected,
        emotionalRecords: _emotionalRecords,
      ),
    );
  }
}
