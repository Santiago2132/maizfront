import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/data/services/emotional_service.dart';
import 'package:mAIz/screens/calendar/montly/EmotionIcon.dart';
import 'package:mAIz/widgets/custom_card.dart';
import 'package:provider/provider.dart';
class MonthlyEmotionChart extends StatefulWidget {
  final int year;
  final int month;

  const MonthlyEmotionChart({
    super.key,
    required this.year,
    required this.month,
  });

  @override
  State<MonthlyEmotionChart> createState() => _MonthlyEmotionChartState();
}

class _MonthlyEmotionChartState extends State<MonthlyEmotionChart> {
  late Future<List<FlSpot>> _monthlyStats;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didUpdateWidget(covariant MonthlyEmotionChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.year != widget.year || oldWidget.month != widget.month) {
      _fetchData(); // Refrescar datos si cambia el mes
    }
  }

  void _fetchData() {
    setState(() {
      _monthlyStats = EmotionService.fetchMonthlyStatistics(widget.year, widget.month);
    });
  }

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context).fontSize;

    final int daysInMonth = DateTime(widget.year, widget.month + 1, 1)
        .subtract(const Duration(days: 1))
        .day;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomCard(
        title: 'Tu mes emocional',
        height: 300,
        child: FutureBuilder<List<FlSpot>>(
          future: _monthlyStats,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Text(
                  'Tu mes emocional (${widget.month}/${widget.year})',
                  style: TextStyle(
                    fontSize: fontSizeProvider,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF673AB7),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(enabled: false),
                      gridData: FlGridData(show: false),
                      titlesData: _buildTitlesData(daysInMonth),
                      borderData: FlBorderData(show: false),
                      minX: 1,
                      maxX: daysInMonth.toDouble(),
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
      ),
    );
  }

  FlTitlesData _buildTitlesData(int daysInMonth) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            if (value % 5 == 0 || value == 1 || value == daysInMonth) {
              return Text(value.toInt().toString());
            }
            return const SizedBox.shrink();
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

            final emotion = EmotionService.emotionYValues.entries
                .firstWhere(
                  (entry) => entry.value == value,
                  orElse: () => const MapEntry('', -1),
                )
                .key;

            if (emotion.isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: EmotionIcon(emotion: emotion),
            );
          },
          reservedSize: 50,
        ),
      ),
      rightTitles: const AxisTitles(),
      topTitles: const AxisTitles(),
    );
  }
}
