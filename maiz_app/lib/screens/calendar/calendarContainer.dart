import 'package:flutter/material.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/data/services/calendar_service.dart';
import 'package:mAIz/models/emotion_storage.dart';
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
  final Function(int, int) onMonthChanged; // Nuevo callback para el mes
  final VoidCallback? onEmotionSaved; // nuevo callback

  const CalendarContainer(
      {super.key,
      required this.focusedDay,
      required this.selectedDay,
      required this.onDaySelected,
      required this.onMonthChanged,
      required this.onEmotionSaved});

  @override
  _CalendarContainerState createState() => _CalendarContainerState();
}

class _CalendarContainerState extends State<CalendarContainer> {
  Map<DateTime, String> _emotionalRecords = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    await _loadEmotionalRecords();
  }

  Future<void> _loadEmotionalRecords() async {
    final focused = widget.focusedDay;

    final records = await CalendarService.getDailyDominantEmotionsList(
      focused.year,
      focused.month,
    );

    setState(() {
      _emotionalRecords = {};
      for (var item in records) {
        final dateStr = item['date'];
        final emotion = item['emotion'];
        print(item);

        if (dateStr is String && emotion is String) {
          final parsedDate = DateTime.tryParse(dateStr);
          if (parsedDate != null) {
            final normalized =
                DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
            _emotionalRecords[normalized] = emotion;

            if (normalized.weekday == DateTime.monday) {
              print(
                  'Registro del ${dateStr} encontrado: $normalized -> $emotion');
            }
          }
        }
      }
    });

    widget.onEmotionSaved?.call();
  }

  Future<void> _loadEmotionalRecordsForMonth(int year, int month) async {
    final records =
        await CalendarService.getDailyDominantEmotionsList(year, month);

    if (!mounted) return;

    setState(() {
      _emotionalRecords = {};
      for (var item in records) {
        final dateStr = item['date'];
        final emotion = item['emotion'];
        print(item);

        if (dateStr is String && emotion is String) {
          final parsedDate = DateTime.tryParse(dateStr);
          if (parsedDate != null) {
            final normalized =
                DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
            _emotionalRecords[normalized] = emotion;

            if (normalized.weekday == DateTime.monday) {
              print(
                  'Registro del ${dateStr} encontrado: $normalized -> $emotion');
            }
          }
        }
      }
    });

    widget.onEmotionSaved?.call();
  }

  Future<void> _showFeelingSelection(
      BuildContext context, DateTime date) async {
    final today = DateTime.now();
    final selectedDate = DateTime(date.year, date.month, date.day);
    final EmotionStorage _emotionstorage = EmotionStorage();
    if (selectedDate.isAfter(today)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("No puedes registrar emociones en días futuros.")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return EmotionSelector(onEmotionSelected: (selectedEmotion) async {
          await _emotionstorage.saveEmotion(selectedEmotion, date);

          if (context.mounted) {
            final normalizedDate = DateTime(date.year, date.month, date.day);
            setState(() {
              _emotionalRecords[normalizedDate] = selectedEmotion;
            });

            widget.onEmotionSaved?.call();
          }

        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final calendarMarkers =
        CalendarMarkers(emotionalRecords: _emotionalRecords);
    final double fontSizee = Provider.of<FontSizeProvider>(context).fontSize;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    CalendarFormat _calendarFormat = CalendarFormat.month;
    final Function(int year, int month) onMonthChanged;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth, // Usa el ancho disponible
          height: 400, // Ajusta la altura en función del tamaño de la fuente
          child: TableCalendar(
            key: ValueKey(_emotionalRecords.length),
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: widget.focusedDay,
            selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
            onDaySelected: widget.onDaySelected,
            onPageChanged: (focusedDay) {
              _loadEmotionalRecordsForMonth(focusedDay.year, focusedDay.month);
              widget.onMonthChanged(focusedDay.year, focusedDay.month);
            },
            calendarFormat: CalendarFormat.month,
            availableGestures: AvailableGestures.all,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                  fontSize: fontSizee +
                      2), // Ajusta el tamaño de la fuente del encabezado
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
                fontSize: fontSizee.clamp(
                    12, 24), // Asegura que el tamaño sea ajustable
                fontWeight: FontWeight.bold,
              ),
              outsideTextStyle: TextStyle(fontSize: fontSizee - 2),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                fontSize: fontSizee.clamp(12, 24),
                height: 1, // Ajusta tamaño de días de semana
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black, // Texto
              ),
              weekendStyle: TextStyle(
                fontSize: fontSizee.clamp(
                    12, 24), // Ajusta tamaño de sábados y domingos
                fontWeight: FontWeight.bold,
                height: 1, // Ajusta tamaño de días de semana
                color: isDarkMode ? Colors.white : Colors.black, // Texto
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, _) {
                return _buildCalendarCell(context, date);
              },
              selectedBuilder: (context, date, _) {
                return _buildCalendarCell(context, date, isSelected: true);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarCell(BuildContext context, DateTime date,
      {bool isSelected = false}) {
    final today = DateTime.now();
    final selectedDate = DateTime(date.year, date.month, date.day);
    final emotion = _emotionalRecords[selectedDate];
    final bool hasEmotion = emotion != null;
    final bool isFutureDate = selectedDate.isAfter(today);
    final calendarMarkers =
        CalendarMarkers(emotionalRecords: _emotionalRecords);

    final decoration = isSelected
        ? BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.3),
            shape: BoxShape.circle,
          )
        : null;

    return Container(
      decoration: decoration,
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(
        minWidth: 40,
        minHeight: 30,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          DayNumber(date: date),
          if (hasEmotion)
            calendarMarkers.buildMarker(context, date) ?? const SizedBox(),
          if (!hasEmotion && !isFutureDate)
            AddEmotionButton(
              date: date,
              onTap: () => _showFeelingSelection(context, date),
            ),
        ],
      ),
    );
  }
}
