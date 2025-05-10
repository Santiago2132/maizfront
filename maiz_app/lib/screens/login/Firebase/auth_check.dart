import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mAIz/screens/navegator/main_screen.dart';
import 'package:mAIz/screens/welcomePage/welcome.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser; // Verifica si hay sesión activa

    // Si el usuario está autenticado, lo manda al Home, sino al WelcomePage
    return user != null ? const MainScreen() : const WelcomeScreen();
  }
}