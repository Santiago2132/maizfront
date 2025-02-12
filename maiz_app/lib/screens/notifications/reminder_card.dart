import 'package:flutter/material.dart';
import 'package:mAIz/screens/notifications/reminder_screen.dart';

class ReminderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.alarm),
        title: Text('Configurar Recordatorio'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReminderScreen()),
          );
        },
      ),
    );
  }
}
