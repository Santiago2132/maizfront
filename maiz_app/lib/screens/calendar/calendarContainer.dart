import 'package:flutter/material.dart';
import 'package:mAIz/data/services/calendar_service.dart';
import 'package:mAIz/screens/calendar/calendarMarkets.dart';
import 'package:mAIz/screens/calendar/widgets/add_button.dart';
import 'package:mAIz/screens/calendar/widgets/day_number.dart';
import 'package:mAIz/screens/calendar/emotion_selector.dart';
import 'package:mAIz/screens/calendar/widgets/show_emotion.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarContainer extends StatefulWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime) onDaySelected;

  const CalendarContainer({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  _CalendarContainerState createState() => _CalendarContainerState();
}

class _CalendarContainerState extends State<CalendarContainer> {
  Map<DateTime, String> _emotionalRecords = {};

  @override
  void initState() {
    super.initState();
    _loadEmotionalRecords();
  }

  Future<void> _loadEmotionalRecords() async {
    final records = await CalendarService.getEmotionalRecords();
    setState(() {
      _emotionalRecords = records.map(
        (key, value) => MapEntry(DateTime(key.year, key.month, key.day), value),
      );
    });
  }

  Future<void> _showFeelingSelection(
      BuildContext context, DateTime date) async {
    final today = DateTime.now();
    final selectedDate = DateTime(date.year, date.month, date.day);

    if (selectedDate.isAfter(today)) {
      // Opcional: Mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("No puedes registrar emociones en días futuros.")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return EmotionSelector(
          onEmotionSelected: (selectedEmotion) async {
            await CalendarService.saveEmotion(date, selectedEmotion);
            await _loadEmotionalRecords();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final calendarMarkers =
        CalendarMarkers(emotionalRecords: _emotionalRecords);

    return TableCalendar(
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2025, 12, 31),
      focusedDay: widget.focusedDay,
      selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
      onDaySelected: widget.onDaySelected,
      calendarFormat: CalendarFormat.month,
      availableGestures: AvailableGestures.all,
      headerStyle: const HeaderStyle(formatButtonVisible: false),
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        markersAlignment: Alignment.center,
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, _) {
          final today = DateTime.now();
          final selectedDate = DateTime(date.year, date.month, date.day);
          final emotion = _emotionalRecords[selectedDate];
          final bool hasEmotion = emotion != null;
          final bool isFutureDate = selectedDate.isAfter(today);

          return Stack(
            alignment: Alignment.center,
            
            children: [
              DayNumber(date: date), // Muestra el número del día

              if (hasEmotion) 
                EmotionMarker(date: date, calendarMarkers: calendarMarkers), // Muestra el ícono de emoción

              if (!hasEmotion && !isFutureDate) 
                AddEmotionButton(date: date, onTap: () => _showFeelingSelection(context, date)), // Muestra "+"
            ],
          );
        },
      ),
    );
  }
}
