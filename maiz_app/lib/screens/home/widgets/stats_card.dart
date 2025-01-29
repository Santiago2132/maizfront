import 'package:flutter/material.dart';
import 'package:maiz_app/widgets/custom_card.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: 'Estadisticas',
      height: 250,
    );
  }
}