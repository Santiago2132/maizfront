import 'package:flutter/material.dart';
import 'package:maiz_app/screens/your_day/widgets/your_day_cards.dart';
import 'package:maiz_app/screens/your_day/widgets/your_day_message.dart';

class YourDayScreen extends StatelessWidget {
  const YourDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Contenido principal
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  const YourDayMessage(),
                  const SizedBox(height: 10),
                  const YourDayCards(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}