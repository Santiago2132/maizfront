import 'package:flutter/material.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/data/services/badge_service.dart';
import 'package:mAIz/screens/profile/widgets/HexagonBadge.dart';
import 'package:provider/provider.dart';

class BadgeCard extends StatefulWidget {
  const BadgeCard({super.key});

  @override
  _BadgeCardState createState() => _BadgeCardState();
}

class _BadgeCardState extends State<BadgeCard> {
  final BadgeService badgeService = BadgeService();
  bool showAll = false; // Estado para mostrar todas las insignias

  @override
  Widget build(BuildContext context) {
    final badges = badgeService.getBadges();
    final displayBadges = showAll ? badges : badges.take(3).toList(); // Muestra solo 3 o todas

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
              Text(
                'Tus Insignias',
                style: TextStyle(
                 fontSize: Provider.of<FontSizeProvider>(context).fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Muestra hasta 3 insignias o todas si showAll = true
              Wrap(
                spacing: 14,
                children: displayBadges.map((badge) {
                  return HexagonWidget(
                    imagePath: badge.imagePath,
                    badgeName: badge.name,
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),

              // Mostrar botón solo si hay más de 3 insignias
              if (badges.length > 3)
                TextButton(
                  onPressed: () {
                    setState(() {
                      showAll = !showAll; // Alternar entre mostrar 3 o todas
                    });
                  },
                  child: Text(
                    showAll ? "Ver menos" : "Ver más",
                    style: const TextStyle(color: Colors.deepPurple),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
