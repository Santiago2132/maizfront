import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/data/services/calendar_service.dart';
import 'package:mAIz/data/services/emotional_service.dart';
import 'package:mAIz/models/emotion_storage.dart';
import 'package:mAIz/widgets/custom_card.dart';
import 'package:provider/provider.dart';

class GraphicCard extends StatelessWidget {
  final Map<String, double> emotionYValues = {
    'Deprimente': 0,
    'Triste': 1,
    'Regular': 2,
    'Feliz': 3,
    'Euforico': 4,
  };

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  
  final EmotionStorage _emotionStorage = EmotionStorage();

  static Future<List<FlSpot>> getWeeklyData(int year, int month) async {
    final weeklyEmotions = await CalendarService.getAllEmotionOccurrencesByWeek(year, month);
    final today = DateTime.now();
    final int currentWeek = ((today.day - 1) ~/ 7) + 1;
    final emotions = weeklyEmotions[currentWeek] ?? [];

    final Map<int, List<double>> dayEmotionValues = {
      for (var i = 0; i < 7; i++) i: []
    };

    for (var i = 0; i < emotions.length; i++) {
      final emotion = emotions[i];
      final double? y = EmotionService.emotionYValues[emotion];
      if (y != null) {
        final date = today.subtract(Duration(days: today.weekday - 1 - (i % 7)));
        final int dayIndex = date.weekday - 1; // Lunes = 0 ... Domingo = 6
        dayEmotionValues[dayIndex]?.add(y);
      }
    }

    final List<FlSpot> spots = [];

    dayEmotionValues.forEach((dayIndex, values) {
      final double avg = values.isEmpty
          ? 2.0
          : values.reduce((a, b) => a + b) / values.length;

      spots.add(FlSpot(dayIndex.toDouble(), avg));
    });

    return spots;
  }


  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context).fontSize;

    return CustomCard(
      title: 'Tu semana emocional',
      height: 300,
      child: FutureBuilder<List<FlSpot>>(
        future: getWeeklyData(DateTime.now().year, DateTime.now().month),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
               Text(
                'Tu semana emocional',
                style: TextStyle(
                  fontSize: fontSizeProvider,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF673AB7),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(enabled: false),
                    gridData: FlGridData(show: false),
                    titlesData: _buildTitlesData(),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 6,
                    minY: -0.5,
                    maxY: 4.5,
                    lineBarsData: [
                      LineChartBarData(
                        spots: snapshot.data ?? [],
                        isCurved: true,
                        color: const Color(0xFF673AB7),
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 5,
                              color: const Color(0xFF673AB7),
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  FlTitlesData _buildTitlesData() {
    final today = DateTime.now();
    final firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final weekDays =
        List.generate(7, (i) => firstDayOfWeek.add(Duration(days: i)));

    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final dayNames = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
            return Text(dayNames[value.toInt()]);
          },
          reservedSize: 30,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) {
            if (value % 1 != 0) return const SizedBox.shrink();

            final emotion = emotionYValues.entries
                .firstWhere((entry) => entry.value == value,
                    orElse: () => const MapEntry('', -1))
                .key;

            if (emotion.isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _EmotionIcon(emotion: emotion),
            );
          },
          reservedSize: 40,
        ),
      ),
      rightTitles: AxisTitles(),
      topTitles: AxisTitles(),
    );
  }
}

class _EmotionIcon extends StatelessWidget {
  final String emotion;

  _EmotionIcon({required this.emotion});

  final Map<String, String> emotionIcons = {
    'Deprimente': 'assets/icons/Depressed_icon.png',
    'Triste': 'assets/icons/sad_icon.png',
    'Regular': 'assets/icons/so_so_icon.png',
    'Feliz': 'assets/icons/Happy_icon.png',
    'Euforico': 'assets/icons/Euphoric_icon.png',
  };

  @override
  Widget build(BuildContext context) {
    if (!emotionIcons.containsKey(emotion)) return const SizedBox.shrink();

    return Image.asset(
      emotionIcons[emotion]!,
      width: 25,
      height: 25,
    );
  }
}
