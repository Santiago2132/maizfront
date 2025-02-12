// 🏆 Widget que muestra las insignias del usuario dentro de un Card
import 'package:flutter/material.dart';
import 'package:mAIz/data/services/badge_service.dart';
import 'package:mAIz/screens/profile/HexagonBadge.dart';

class BadgeCard extends StatelessWidget {
  const BadgeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final BadgeService badgeService = BadgeService();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                'Tus Insignias',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Muestra insignias en una fila
              Wrap(
                spacing: 16,
                children: badgeService.getBadges().map((badge) {
                  return HexagonWidget(
                    imagePath: badge.imagePath,
                    badgeName: badge.name,
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),

              // Botón para ver más insignias
              TextButton(
                onPressed: () {
                  // TODO: Navegar a pantalla de insignias detalladas
                },
                child: const Text(
                  "Ver más",
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
