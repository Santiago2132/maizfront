import 'package:flutter/material.dart';
import 'package:mAIz/data/services/emotional_service.dart';
import 'package:mAIz/widgets/custom_card.dart';

class MonthlyHeatMap extends StatefulWidget {
  final int year;
  final int month;

  const MonthlyHeatMap({super.key, required this.year, required this.month});

  @override
  _MonthlyHeatMapState createState() => _MonthlyHeatMapState();
}

class _MonthlyHeatMapState extends State<MonthlyHeatMap> {
  late Future<Map<int, String>> _monthlyEmotions;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didUpdateWidget(covariant MonthlyHeatMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.year != widget.year || oldWidget.month != widget.month) {
      _fetchData(); // Recargar datos si cambia el mes
    }
  }

  void _fetchData() {
    setState(() {
      _monthlyEmotions = EmotionService.fetchMonthlyEmotions(widget.year, widget.month);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int daysInMonth = DateTime(widget.year, widget.month + 1, 0).day;

    return CustomCard(
      title: 'Mapa de calor emocional',
      height: 250,
      child: FutureBuilder<Map<int, String>>(
        future: _monthlyEmotions,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final Map<int, String> emotions = snapshot.data ?? {};

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, // Días de la semana
              childAspectRatio: 1.2,
            ),
            itemCount: daysInMonth,
            itemBuilder: (context, index) {
              final day = index + 1;
              final emotion = emotions[day] ?? "Sin registro";
              final color = _getEmotionColor(emotion);

              return Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    day.toString(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case 'Deprimente':
        return Colors.red.shade900;
      case 'Triste':
        return Colors.orange.shade700;
      case 'Regular':
        return Colors.yellow.shade600;
      case 'Feliz':
        return Colors.green.shade500;
      case 'Euforico':
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade300;
    }
  }
}
