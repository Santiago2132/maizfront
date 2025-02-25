import 'package:flutter/material.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/data/services/calendar_service.dart';
import 'package:mAIz/screens/calendar/calendarMarkets.dart';
import 'package:mAIz/screens/calendar/widgets/add_button.dart';
import 'package:mAIz/screens/calendar/widgets/day_number.dart';
import 'package:mAIz/screens/calendar/emotion_selector.dart';
import 'package:mAIz/screens/calendar/widgets/show_emotion.dart';
import 'package:provider/provider.dart';
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
    final double fontSizee = Provider.of<FontSizeProvider>(context).fontSize;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth, // Usa el ancho disponible
          height: fontSizee * 50, // Ajusta la altura en función del tamaño de la fuente
          child: TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: widget.focusedDay,
            selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
            onDaySelected: widget.onDaySelected,
            calendarFormat: CalendarFormat.month,
            availableGestures: AvailableGestures.all,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                  fontSize: fontSizee + 2), // Ajusta el tamaño de la fuente del encabezado
            ),
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
              defaultTextStyle: TextStyle(
                fontSize: fontSizee.clamp(12, 24), // Asegura que el tamaño sea ajustable
                fontWeight: FontWeight.bold,
              ),
              outsideTextStyle: TextStyle(fontSize: fontSizee - 2),
            ),

            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                fontSize: fontSizee.clamp(12, 24), 
                height: 1,// Ajusta tamaño de días de semana
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black, // Texto
              ),
              weekendStyle: TextStyle(
                fontSize: fontSizee.clamp(12, 24), // Ajusta tamaño de sábados y domingos
                fontWeight: FontWeight.bold,
                                height: 1,// Ajusta tamaño de días de semana
                color: isDarkMode ? Colors.white : Colors.black, // Texto

              ),
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
                    DayNumber(
                        date: date), // Ajusta el número del día

                    if (hasEmotion)
                      EmotionMarker(
                          date: date,
                          calendarMarkers: calendarMarkers), // Ícono de emoción

                    if (!hasEmotion && !isFutureDate)
                      AddEmotionButton(
                          date: date,
                          onTap: () => _showFeelingSelection(
                              context, date)), // Botón "+"
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
