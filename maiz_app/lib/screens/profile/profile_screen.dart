import 'package:flutter/material.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/screens/navegator/main_screen.dart';
import 'package:mAIz/screens/notifications/reminder_card.dart';
import 'package:mAIz/screens/payment/PaymentButton.dart';
import 'package:mAIz/screens/payment/PaymentMethodsPage.dart';
import 'package:mAIz/screens/profile/widgets/badgeCard.dart';
import 'package:mAIz/screens/profile/widgets/fontSize_card.dart';
import 'package:mAIz/screens/profile/widgets/logout.dart';
import 'package:mAIz/screens/profile/widgets/theme_switch.dart';
import 'package:mAIz/screens/profile/widgets/userInfo.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perfil',
          style: TextStyle(
            fontSize: Provider.of<FontSizeProvider>(context).fontSize, 
          ),
        ),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const UserInfoSection(),
              const SizedBox(height: 20),
              const BadgeCard(),
              ReminderCard(),
              ThemeToggleCard(),
              const FontSizeCard(),
              const PaymentCardButton(),
              const LogoutButton(),
              const SizedBox(height: 20),
             

            ],
          ),
        ),
      ),
    );
  }
}