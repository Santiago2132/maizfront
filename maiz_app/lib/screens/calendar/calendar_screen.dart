import 'package:flutter/material.dart';
import 'package:maiz_app/screens/navegator/main_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _MonthlyCalendarState createState() => _MonthlyCalendarState();
}

class _MonthlyCalendarState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, IconData> _dayIcons = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario emocional'),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Reemplaza la pantalla actual con Home
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
              (route) => false, // Elimina todas las rutas anteriores
            );
          },
        ),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _dayIcons[selectedDay] = Icons.star; // Ejemplo de icono
          });
        },
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (_dayIcons.containsKey(date)) {
              return Positioned(
                bottom: 5,
                child: Icon(_dayIcons[date], size: 20, color: Colors.blue),
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
