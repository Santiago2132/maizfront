import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mAIz/data/services/insignia_service.dart';
import 'package:mAIz/data/services/user_service.dart';
import 'package:mAIz/screens/navegator/main_screen.dart';
import 'package:mAIz/screens/profile/HexagonBadge.dart';
import 'package:mAIz/widgets/avatarWidget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final BadgeService badgeService = BadgeService();

  final UserService userService = UserService(); 


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
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AvatarWidget(),
              const SizedBox(height: 20),

              //  FutureBuilder con el UserService
              FutureBuilder<String>(
                future: userService.getUserName(), //  servicio
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Cargando
                  } else if (snapshot.hasError) {
                    return const Text("Error al obtener el nombre");
                  } else {
                    return Text(
                      'Hola, ${snapshot.data}', // nombre del usuario
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 20),
              const Text(
                'Tus Insignias',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              //  insignias en una fila
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
