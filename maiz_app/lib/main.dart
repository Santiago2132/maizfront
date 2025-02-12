import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mAIz/data/services/notification_service.dart';
import 'package:mAIz/routing/router.dart';
//HOLI
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyB0YGIkJxr2laXNHOm_pSP8jYEGAuZA5hU",
        appId: "1:686512163452:android:a902a1bed4c191644217f9",
        messagingSenderId: "686512163452",
        projectId: "maiz-d686b",
        // Your web Firebase config options
      ),
    );

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );

    await FirebaseMessaging.instance.requestPermission(); // Solicitar permisos
    NotificationService();
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Elimina el banner de depuración
      theme: ThemeData(
        useMaterial3: true,
      ),

      onGenerateRoute:
          AppRouter.generateRoute, // Usa AppRouter para generar las rutas
    );
  }
}
