import 'package:mAIz/data/services/insignia_service.dart';
import 'package:mAIz/screens/navegator/main_screen.dart';
import 'package:mAIz/screens/profile/HexagonBadge.dart';
import 'package:flutter/material.dart';
import 'package:mAIz/widgets/avatarWidget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "Maria Suarez";

  // Instanciamos el servicio de insignias
  final BadgeService badgeService = BadgeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
              }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AvatarWidget(),
              Text(
                'Hola, $name',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Tus Insignias',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              // Mostramos las insignias en una fila
              Wrap(
                spacing: 16,
                children: badgeService.getBadges().map((badge) {
                  return HexagonWidget(
                    imagePath: badge.imagePath,
                    badgeName: badge.name,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
    
  }
}
