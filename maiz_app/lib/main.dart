import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:provider/provider.dart';

import 'package:mAIz/core/theme_provider.dart';
import 'package:mAIz/data/services/notification_service.dart';
import 'package:mAIz/routing/router.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(" Mensaje recibido en segundo plano: ${message.notification?.title}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {

    
    await Firebase.initializeApp(
      options: kIsWeb
          ? const FirebaseOptions(
              apiKey: "AIzaSyB0YGIkJxr2laXNHOm_pSP8jYEGAuZA5hU",
              appId: "1:686512163452:android:a902a1bed4c191644217f9",
              messagingSenderId: "686512163452",
              projectId: "maiz-d686b",
            )
          : null,
    );

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
    );

    // Configurar notificaciones
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      await FirebaseMessaging.instance.requestPermission();
    }

    NotificationService(); // Inicializar servicio de notificaciones

  } catch (e) {
    debugPrint(" Error al inicializar Firebase: $e");
  }

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FontSizeProvider()), 
      ],
      child: Consumer2<ThemeProvider, FontSizeProvider>(
        builder: (context, themeProvider, fontSizeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              textTheme: TextTheme(
                bodyMedium: TextStyle(fontSize: Provider.of<FontSizeProvider>(context).fontSize),

              ),
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.deepPurple,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.grey[900],
              textTheme: TextTheme(
                bodyMedium: TextStyle(fontSize: Provider.of<FontSizeProvider>(context).fontSize),
              ),
            ),
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}