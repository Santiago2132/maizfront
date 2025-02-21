import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/screens/welcomePage/welcome.dart';
import 'package:provider/provider.dart';

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
      label: Text(
        "Cerrar sesión",
        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0),                 
        fontSize: Provider.of<FontSizeProvider>(context).fontSize,
        ),
      ),
    );
  }
}
