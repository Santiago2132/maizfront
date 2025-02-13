import 'package:flutter/material.dart';
import 'package:mAIz/core/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeToggleCard extends StatelessWidget {
  const ThemeToggleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(Icons.brightness_6, color: Colors.deepPurple),
        title: Text(
          'Modo de Tema',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        trailing: Switch(
          value: themeProvider.themeMode == ThemeMode.dark,
          onChanged: (value) {
            themeProvider.toggleTheme();
          },
        ),
      ),
    );
  }
}
