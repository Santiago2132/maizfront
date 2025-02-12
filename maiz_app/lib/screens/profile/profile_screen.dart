import 'package:flutter/material.dart';
import 'package:mAIz/screens/navegator/main_screen.dart';
import 'package:mAIz/screens/notifications/reminder_card.dart';
import 'package:mAIz/screens/profile/widgets/badgeCard.dart';
import 'package:mAIz/screens/profile/widgets/logout.dart';
import 'package:mAIz/screens/profile/widgets/userInfo.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const UserInfoSection(),
            const SizedBox(height: 20),
            const BadgeCard(),
            ReminderCard(),
            const LogoutButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}