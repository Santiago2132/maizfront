import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AvatarWidget extends StatefulWidget {
  const AvatarWidget({super.key});

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        SimpleAnimation('idle'); // Usa el nombre exacto de tu animación
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: ClipOval(
        child: Stack(
          children: [
            Container(
              color: const Color(0xFF7B1FA2),
            ),
            RiveAnimation.asset(
              'assets/rive/saludo_ratita.riv',
              controllers: [_controller],
              fit: BoxFit.cover,
              antialiasing: false, // Importante para reducir carga
              onInit: (artboard) {
                // Verifica que la animación existe
                final controller = StateMachineController.fromArtboard(
                    artboard, 'State Machine 1' // Nombre de tu state machine
                    );
                if (controller != null) {
                  artboard.addController(controller);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
