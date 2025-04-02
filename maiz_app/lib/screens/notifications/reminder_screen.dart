import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/data/services/notification_service.dart';
import 'package:mAIz/screens/navegator/main_screen.dart';
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
        content: Text("Recordatorio programado a las ${time.format(context)}"),
      ),
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
    final fontSize = Provider.of<FontSizeProvider>(context).fontSize;

    return Scaffold(
      appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 255, 255, 255)),
              onPressed: () => Navigator.pop(context),
            ),
          ),      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color.fromARGB(255, 182, 130, 236)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Programa tu Recordatorio",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  child: Text(
                    _selectedTime == null
                        ? ' No hay recordatorio programado'
                        : ' Recordatorio: ${_selectedTime!.format(context)}',
                    key: ValueKey(_selectedTime),
                    style: GoogleFonts.poppins(
                      fontSize: fontSize,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Seleccionar Hora',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
