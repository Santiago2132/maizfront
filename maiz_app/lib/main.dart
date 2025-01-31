import 'package:flutter/material.dart';
import 'package:maiz_app/routing/router.dart';

void main(){
  runApp(const MyApp());
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
      onGenerateRoute: AppRouter.generateRoute, //  AppRouter para generar las rutas
    );
  }
}

