import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mAIz/widgets/custom_card.dart';

class EmotionTest extends StatelessWidget {
  final List<Map<String, String>> mockEmotions = [
    {'fecha': '2025-02-10', 'emotion': 'Euforico'},
    {'fecha': '2025-02-11', 'emotion': 'Deprimente'},
    {'fecha': '2025-02-12', 'emotion': 'Regular'},
    {'fecha': '2025-02-13', 'emotion': 'Feliz'},
    {'fecha': '2025-02-14', 'emotion': 'Triste'},
  ];

  final Map<String, double> emotionYValues = {
    'Deprimente': 0,
    'Triste': 1,
    'Regular': 2,
    'Feliz': 3,
    'Euforico': 4,
  };

  List<FlSpot> getWeeklyData() {
    // Fecha de prueba (ej: 2025-02-10, lunes)
    final today =
        DateTime(2025, 2, 10); // Fuerza una fecha específica para pruebas

    // Encuentra el lunes de esta semana
    final firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));

    // Genera 7 días a partir del lunes
    final weekDays =
        List.generate(7, (index) => firstDayOfWeek.add(Duration(days: index)));

    return weekDays.map((day) {
      final emotionEntry = mockEmotions.firstWhere(
        (entry) => _isSameDay(DateTime.parse(entry['fecha']!), day),
        orElse: () => {'emotion': ''},
      );

      return FlSpot(
        weekDays.indexOf(day).toDouble(),
        emotionYValues[emotionEntry['emotion']] ?? 2.0,
      );
    }).toList();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      height: 300, // Incrementar la altura del CustomCard
      child: Column(
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
            // Usar Expanded para que LineChart ocupe el espacio disponible
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
                    spots: getWeeklyData(),
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
      ),
    );
  }

  FlTitlesData _buildTitlesData() {
    final today = DateTime(2025, 2, 10); // Misma fecha de prueba
    final firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final weekDays =
        List.generate(7, (index) => firstDayOfWeek.add(Duration(days: index)));

    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final day = weekDays[value.toInt()];
            final dayNames = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
            return Text(
                dayNames[day.weekday - 1]); // Ajuste para que L=1 (lunes)
          },
          reservedSize: 30,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1, // Añade esto para puntos específicos en Y
          getTitlesWidget: (value, meta) {
            // Solo mostrar íconos en valores Y enteros (0, 1, 2, 3, 4)
            if (value % 1 != 0) return const SizedBox.shrink();

            final emotion = emotionYValues.entries
                .firstWhere(
                  (entry) => entry.value == value,
                  orElse: () =>
                      const MapEntry('', -1), // No coincide con ninguna emoción
                )
                .key;

            if (emotion.isEmpty)
              return const SizedBox.shrink(); // Ocultar si no hay coincidencia

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
    // Si la emoción no existe, no mostrar nada (evitar "so_so" por defecto)
    if (!emotionIcons.containsKey(emotion)) return const SizedBox.shrink();

    return Image.asset(
      emotionIcons[emotion]!,
      width: 25,
      height: 25,
    );
  }
}
