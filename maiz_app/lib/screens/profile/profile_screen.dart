import 'package:flutter/material.dart';
import 'package:maiz_app/screens/home/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String name = "Maria Suarez";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );          
          },
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Foto de perfil
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(
                    "assets/avatar.png", // Reemplaza con URL real
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
                ),
              ),
              
            ],
          ),
          ),
        ),
    );
  }
}
