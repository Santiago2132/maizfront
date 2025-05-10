import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: Colors.deepPurple,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.home_outlined, 0),
          activeIcon: _buildIcon(Icons.home_filled, 0, isActive: true),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.edit_calendar_outlined, 1),
          activeIcon: _buildIcon(Icons.edit_calendar_rounded, 1, isActive: true),
          label: 'Calendario',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.message_outlined, 2),
          activeIcon: _buildIcon(Icons.message, 2, isActive: true),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.play_circle_outline, 3),
          activeIcon: _buildIcon(Icons.play_circle_fill, 3, isActive: true),
          label: 'Tu Día',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.person_2_outlined, 4),
          activeIcon: _buildIcon(Icons.person_2, 4, isActive: true),
          label: 'Perfil',
        ),
      ],
    );
  }

  Widget _buildIcon(IconData icon, int index, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,  // Color del círculo cuando está activo
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.deepPurple : Colors.grey, // Color del ícono
        size: isActive ? 40 : 24,  // Tamaño del ícono cuando está activo
      ),
    );
  }
}
