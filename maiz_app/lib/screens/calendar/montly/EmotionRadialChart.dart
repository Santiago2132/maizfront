import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mAIz/data/services/emotional_service.dart';
import 'package:mAIz/widgets/custom_card.dart';

class EmotionRadialChart extends StatefulWidget {
  final int year;
  final int month;

  const EmotionRadialChart(
      {super.key, required this.year, required this.month});

  @override
  _EmotionRadialChartState createState() => _EmotionRadialChartState();
}

class _EmotionRadialChartState extends State<EmotionRadialChart> {
  late Future<Map<String, int>> _emotionData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didUpdateWidget(covariant EmotionRadialChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.year != oldWidget.year || widget.month != oldWidget.month) {
      _fetchData(); // Recargar datos si cambian el año o mes
    }
  }

  void _fetchData() {
    setState(() {
      _emotionData = _processMonthlyEmotions();
    });
  }

  Future<Map<String, int>> _processMonthlyEmotions() async {
    final records =
        await EmotionService.fetchAllEmotionSpots(widget.year, widget.month);
    final Map<String, int> emotionCounts = {};

    for (var spot in records) {
      final emotion = EmotionService.getEmotionByValue(spot.y);
      if (emotion.isNotEmpty) {
        emotionCounts[emotion] = (emotionCounts[emotion] ?? 0) + 1;
      }
    }
    return emotionCounts;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: 'Distribución Emocional Mensual',
      height: 400,
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<Map<String, int>>(
              future: _emotionData,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                final emotionCounts = snapshot.data ?? {};
                if (emotionCounts.isEmpty) {
                  return const Center(
                      child: Text('No hay registros de emociones.'));
                }

                return PieChart(
                  PieChartData(
                    sections: _generatePieSections(emotionCounts),
                    sectionsSpace: 2,
                    centerSpaceRadius: 50,
                    borderData: FlBorderData(show: false),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          _buildLegend(), // Agrega la leyenda de colores debajo del gráfico
        ],
      ),
    );
  }

  List<PieChartSectionData> _generatePieSections(
      Map<String, int> emotionCounts) {
    final List<Color> colors = [
      Colors.red.shade900, // Deprimente
      Colors.orange.shade700, // Triste
      Colors.yellow.shade600, // Regular
      Colors.green.shade500, // Feliz
      Colors.blue.shade700, // Euforico
    ];

    final List<String> emotions = [
      'Deprimente',
      'Triste',
      'Regular',
      'Feliz',
      'Euforico',
    ];

    return emotions
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final emotion = entry.value;
          final count = emotionCounts[emotion] ?? 0;

          if (count == 0) return null;

          return PieChartSectionData(
            color: colors[index],
            value: count.toDouble(),
            title: '$count',
            radius: 60,
            titleStyle: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          );
        })
        .whereType<PieChartSectionData>()
        .toList();
  }

  Widget _buildLegend() {
    final Map<String, Color> emotionColors = {
      'Deprimente': Colors.red.shade900,
      'Triste': Colors.orange.shade700,
      'Regular': Colors.yellow.shade600,
      'Feliz': Colors.green.shade500,
      'Euforico': Colors.blue.shade700,
    };

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      children: emotionColors.entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: entry.value,
              ),
            ),
            const SizedBox(width: 5),
            Text(entry.key, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }
}
