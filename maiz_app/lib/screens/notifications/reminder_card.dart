import 'package:flutter/material.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/screens/navegator/main_screen.dart';
import 'package:provider/provider.dart';

class ReminderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.alarm),
        title: Text('Configurar Recordatorio'),
          titleTextStyle: TextStyle(color: Colors.black ,fontSize: Provider.of<FontSizeProvider>(context).fontSize, 
            ),
        
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        },
      ),
    );
  }
}
