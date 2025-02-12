import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mAIz/screens/navegator/main_screen.dart';
import 'package:mAIz/screens/welcomePage/welcome.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _signOut(context),
      icon: const Icon(Icons.logout, color: Color.fromARGB(255, 0, 0, 0)),
      label: const Text(
        "Cerrar sesión",
        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
      ),
    );
  }
}
