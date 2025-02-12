import 'package:flutter/material.dart';
import 'package:mAIz/data/services/user_service.dart';
import 'package:mAIz/widgets/avatarWidget.dart';

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();

    return Column(
      children: [
        const AvatarWidget(),
        const SizedBox(height: 20),

        // FutureBuilder para obtener el nombre del usuario
        FutureBuilder<String>(
          future: userService.getUserName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text("Error al obtener el nombre");
            } else {
              return Text(
                'Hola, ${snapshot.data}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}