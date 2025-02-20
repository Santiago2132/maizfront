import 'package:flutter/material.dart';
import 'package:mAIz/screens/your_day/widgets/your_day_cards.dart';

class PhrasesScreen extends StatelessWidget {
  const PhrasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Frases del Día"),
        backgroundColor: const Color(0xff673ab7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: const YourDayCards(),
        ),
      ),
    );
  }
}
