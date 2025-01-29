import 'package:flutter/material.dart';
import 'package:maiz_app/screens/calendar/calendar_screen.dart';
import 'package:maiz_app/screens/chat/chat_screen.dart';
import 'package:maiz_app/screens/home/home_screen.dart';
import 'package:maiz_app/screens/profile/profile_screen.dart';
import 'package:maiz_app/screens/your_day/your_day_screen.dart';
import 'package:maiz_app/widgets/navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CalendarScreen(),
     ChatScreen(),
    const YourDayScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}