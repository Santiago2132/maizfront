import 'package:flutter/material.dart';
import 'package:maiz_app/widgets/HexagonBadge.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkMode = false; // Controla el modo oscuro

  String name = "Maria Suarez";
  List<String> badges = ["Insignia 1", "Insignia 2", "Insignia 3"];

  // Cambia el modo oscuro
  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Regresar a la pantalla anterior
          },
        ),
      ),
      body: Container(
        color: _isDarkMode ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Foto de perfil
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    "https://www.example.com/profile.jpg", // Reemplaza con URL real
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Nombre de usuario
              Text(
                'Hola, $name',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              
            ],
          ),
          ),
        ),
    );
  }
}
