import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: AssetImage('assets/resources/avatar.png'),
      backgroundColor: Colors.purple.shade700,
    );
  }
}