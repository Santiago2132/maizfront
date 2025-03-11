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
  final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextButton.icon(
      onPressed: () => _signOut(context),
      icon:  Icon(Icons.logout, 
      color: isDarkMode ? Colors.white : Colors.black) ,// Texto           
      label: Text(
        "Cerrar sesion",
        style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black, // Texto           
        fontSize: Provider.of<FontSizeProvider>(context).fontSize,
        ),
      ),
    );
  }
}
