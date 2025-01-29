import 'package:flutter/material.dart';
import 'package:maiz_app/routing/router.dart';
import 'package:maiz_app/screens/calendar/calendar_screen.dart';
import 'package:maiz_app/screens/chat/chat_screen.dart';
import 'package:maiz_app/screens/home/home_screen.dart';
import 'package:maiz_app/screens/navegator/main_screen.dart';
import 'package:maiz_app/screens/profile/profile_screen.dart';
import 'package:maiz_app/screens/welcomePage/welcome.dart';
import 'package:maiz_app/screens/your_day/your_day_screen.dart';
import 'package:maiz_app/widgets/navbar.dart';

void main(){
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
      onGenerateRoute: AppRouter.generateRoute, // Usa AppRouter para generar las rutas
    );
  }
}

