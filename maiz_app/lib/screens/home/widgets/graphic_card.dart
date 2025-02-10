import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mAIz/models/emotion_storage.dart';
import 'package:mAIz/widgets/custom_card.dart';

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

  Future<List<FlSpot>> getWeeklyData() async {
    final emotions = await EmotionStorage.getEmotions();
    final today = DateTime.now();
    final firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final weekDays =
        List.generate(7, (i) => firstDayOfWeek.add(Duration(days: i)));

    // Debug: Imprimir emociones almacenadas
    debugPrint('Emociones almacenadas: $emotions');

    return weekDays.map((day) {
      final dailyEmotions = emotions
          .where((e) => _isSameDay(DateTime.parse(e['date']!), day))
          .toList();

      // Debug: Imprimir emociones del día
      debugPrint(
          'Día ${day.toString()}: ${dailyEmotions.map((e) => e['emotion'])}');

      final average = dailyEmotions.isEmpty
          ? 2.0
          : dailyEmotions
                  .map((e) => emotionYValues[e['emotion']]!)
                  .reduce((a, b) => a + b) /
              dailyEmotions.length;

      // Debug: Imprimir promedio
      debugPrint('Promedio para ${day.toString()}: $average');

      return FlSpot(weekDays.indexOf(day).toDouble(), average);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      height: 300,
      child: FutureBuilder<List<FlSpot>>(
        future: getWeeklyData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              const Text(
                'Tu semana emocional',
                style: TextStyle(
                  fontSize: 18,
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
