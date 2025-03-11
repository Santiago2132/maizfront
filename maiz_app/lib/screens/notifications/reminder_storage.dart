import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderStorage {
  Future<void> saveTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminder_hour', time.hour);
    await prefs.setInt('reminder_minute', time.minute);
  }

  Future<TimeOfDay?> loadSavedTime() async {
    final prefs = await SharedPreferences.getInstance();
    final int? hour = prefs.getInt('reminder_hour');
    final int? minute = prefs.getInt('reminder_minute');
    if (hour != null && minute != null) {
      return TimeOfDay(hour: hour, minute: minute);
    }
    return null;
  }
}
