import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initialize();
  }

  void _initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    await _localNotifications.initialize(initSettings);

    await _messaging.requestPermission();

    String? token = await _messaging.getToken();
    print("FCM Token: $token");

    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (token != null && userId != null) {
      await registerFCMToken(userId, token);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notificación abierta: ${message.notification?.title}");
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'reminder_channel',
      'Recordatorio',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      0,
      message.notification?.title ?? 'Registra tu daily mood',
      message.notification?.body ??
          '¿Tienes un minuto para registrar tu emoción diaria?',
      notificationDetails,
    );
  }

  final String _baseUrl = 'http://192.168.20.71:4000';

  Future<void> registerFCMToken(String userId, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'token': token}),
    );

    if (response.statusCode == 200) {
      print('Token registrado correctamente');
    } else {
      print('Error al registrar el token: ${response.body}');
    }
  }

  Future<void> sendNotification(String token, String title, String body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/send-notification'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'title': title, 'body': body}),
    );

    if (response.statusCode == 200) {
      print('Notificación enviada correctamente');
    } else {
      print('Error al enviar la notificación: ${response.body}');
    }
  }

  Future<void> createReminder(
    String sheetId, String message, DateTime date) async {

    String? userId = FirebaseAuth.instance.currentUser?.uid;

    print('createReminder() ha sido llamada');

    if (userId == null) {
      print('Error: Usuario no autenticado');
      return;
    }
    print(userId);
    final response = await http.post(
      Uri.parse('$_baseUrl/reminders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'sheetId': sheetId,
        'message': message,
        'date': date.toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      print('Recordatorio creado');
    } else {
      print(response.statusCode);
      print('Error al crear el recordatorio: ${response.body}');
    }
  }

  Future<void> sendNotificationToUser(String userId, String message) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/send-notification'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'message': message}),
    );

    if (response.statusCode == 200) {
      print(
          'Notificación enviada correctamente después de crear el recordatorio');
    } else {
      print('Error al enviar la notificación: ${response.body}');
    }
  }

  Future<void> scheduleNotification(TimeOfDay time) async {
    final now = DateTime.now();
    var scheduledDate =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 0));
    }
    print('Fecha programada: $scheduledDate');
    print('Fecha actual: $now');
    
    await createReminder(
          'recordatorio', 'Regitra tu emoción hoy', scheduledDate);

    await _localNotifications.zonedSchedule(
      0,
      'Recordatorio Programado',
      'Este es tu recordatorio para la hora seleccionada',
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Recordatorio',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
   
    print('Notificación programada para: $scheduledDate');
  }
}
