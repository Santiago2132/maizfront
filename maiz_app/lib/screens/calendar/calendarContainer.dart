import 'package:flutter/material.dart';
import 'package:mAIz/data/services/calendar_service.dart';
import 'package:mAIz/screens/calendar/add_emotion.dart';
import 'package:mAIz/screens/calendar/calendarMarkets.dart';
import 'package:mAIz/screens/calendar/emotion_selector.dart';
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

  Future<void> _showFeelingSelection(BuildContext context, DateTime date) async {
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
    final calendarMarkers = CalendarMarkers(emotionalRecords: _emotionalRecords);

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
          color: Colors.deepPurple.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        markersAlignment: Alignment.bottomCenter,
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, _) {
          final emotion = _emotionalRecords[DateTime(date.year, date.month, date.day)];
          final bool hasEmotion = emotion != null;
          
          return Stack(
            alignment: Alignment.center,
            children: [
              // 📌 Día del mes (número en el calendario)
              Container(
                width: 36, // Ajusta el tamaño para evitar superposiciones
                height: 36,
                alignment: Alignment.center,
                child: Text(
                  '${date.day}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              // 🎭 Ícono de emoción en la esquina inferior
              if (hasEmotion)
                Positioned(
                  bottom: -3,
                  right: -2,
                  child: SizedBox(
                    width: 20, // Ajusta el tamaño del icono
                    height: 20,
                    child:   calendarMarkers.buildMarker(context, date) ?? const SizedBox.shrink()

                  ),
                ),

              // ➕ Botón para agregar emoción
              if (!hasEmotion)
                Positioned(
                  top: 1,
                  right: 3,
                  child: GestureDetector(
                    onTap: () => _showFeelingSelection(context, date),
                    child: Container(
                      width: 16, // Tamaño más pequeño para evitar solapamiento
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, size: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          );
        },
      ),

    );
  }
}
