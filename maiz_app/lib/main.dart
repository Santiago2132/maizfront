import 'package:flutter/material.dart';
import 'package:maiz_app/routing/router.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:maiz_app/screens/login/login_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Elimina el banner de depuración
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: LoginScreen(),
      onGenerateRoute: AppRouter.generateRoute, // Usa AppRouter para generar las rutas
    );
  }
}

