import 'package:flutter/material.dart';
import 'package:maiz_app/screens/calendar/calendar_screen.dart';
import 'package:maiz_app/screens/chat/chat_screen.dart';
import 'package:maiz_app/screens/home/home_screen.dart';
import 'package:maiz_app/screens/profile/profile_screen.dart';
import 'package:maiz_app/screens/welcomePage/welcome.dart';
import 'package:maiz_app/screens/your_day/your_day_screen.dart';



class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) =>  WelcomeScreen());  // Configura MainScreen aquí
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/calendar':
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
      case '/chatbot':
        return MaterialPageRoute(builder: (_) =>  ChatScreen());
      case '/multimedia':
        return MaterialPageRoute(builder: (_) => const YourDayScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 - Página no encontrada')),
          ),
        );
    }
  }
}
