import 'package:flutter/material.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/data/services/notification_service.dart';
import 'package:mAIz/screens/navegator/main_screen.dart';
import 'package:mAIz/screens/profile/profile_screen.dart';
import 'package:mAIz/widgets/purple_loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  TimeOfDay? _selectedTime;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadSavedTime();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      _saveTime(picked);

      print('día desde screen $picked');
      _notificationService.scheduleNotification(picked);
    }
  }

  Future<void> _saveTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminder_hour', time.hour);
    await prefs.setInt('reminder_minute', time.minute);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PurpleLoadingIndicator(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text("Recordatorio programado a las ${time.format(context)}")),
    );

    await Future.delayed(Duration(seconds: 1));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  Future<void> _loadSavedTime() async {
    final prefs = await SharedPreferences.getInstance();
    final int? hour = prefs.getInt('reminder_hour');
    final int? minute = prefs.getInt('reminder_minute');
    if (hour != null && minute != null) {
      setState(() {
        _selectedTime = TimeOfDay(hour: hour, minute: minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Programar Recordatorio')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _selectedTime == null
                  ? 'No hay recordatorio programado'
                  : 'Recordatorio: ${_selectedTime!.format(context)}',
              style: TextStyle(
                  fontSize: Provider.of<FontSizeProvider>(context).fontSize),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text('Seleccionar Hora'),
            ),
          ],
        ),
      ),
    );
  }
}
