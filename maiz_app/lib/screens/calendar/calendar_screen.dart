import 'package:flutter/material.dart';
import 'package:mAIz/data/services/calendar_service.dart';
import 'package:mAIz/screens/calendar/calendarBar.dart';
import 'package:mAIz/screens/calendar/calendarContainer.dart';
import 'package:mAIz/screens/calendar/montly/MonthlyEmotionChart.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  int _currentYear = DateTime.now().year;
  int _currentMonth = DateTime.now().month;
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

  void _onMonthChanged(int year, int month) {
    setState(() {
      _focusedDay = DateTime(year, month, 1);
      _currentYear = year;
      _currentMonth = month;
      print('Mes cambiado: $_focusedDay'); // Para ver si detecta el cambio
    });
  }



  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CalendarContainer(
                focusedDay: _focusedDay,
                selectedDay: _selectedDay,
                onDaySelected: _onDaySelected,
                onMonthChanged: _onMonthChanged,
              ),
              const SizedBox(height: 20),
             Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0), // Margen horizontal
                child: SizedBox(
                  height: 300, // Asegura una altura fija
                  width: 500, // Asegura que ocupe todo el ancho disponible
                  child: MonthlyEmotionChart(year: _currentYear, month: _currentMonth),

                ),
              ),
            ],
          ),
        ),

      );
    }
}
