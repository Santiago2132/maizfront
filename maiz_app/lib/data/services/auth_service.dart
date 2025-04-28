import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mAIz/models/shared_preferences.dart';

class AuthService {
  final String baseUrl =
      'http://10.153.90.103:4000'; //sirve en la api de base de datos

  final prefsService = SharedPreferencesService();

  Future<bool> registerUser(BuildContext context, String name, String email,
      String password, String confirmPasssword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/registro/app'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'confirm_password': confirmPasssword
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Usuario registrado correctamente en el servidor');

        return true;
      } else {
        print('Error al registrar usuario en el servidor: ${response.body}');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en el registro: ${e.message}')),
      );
      return false;
    }
  }

  Future<bool> verifyEmailUser(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios/verificar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      print('Usuario encontrado: ${response.body}');

      return true;
    } else if (response.statusCode == 404) {
      print('Usuario no registrado');
      return false;
    } else {
      print('Error al verificar usuario: ${response.body}');
      return false;
    }
  }

  // Login sin google
  Future<bool> loginApp(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/app'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Usuario encontrado: ${response.body}');

      print(response.body);
      final data = jsonDecode(response.body);
      print(data);
      //token y userId de la respuesta
      final token = data['token'];
      final userId = data['user']['id'] as int;
      final userName = data['user']['name'];

      print('Usuario encontrado: $data');

      await prefsService.saveUserSession(
          token: token, userId: userId, name: userName);

      return true;
    } else if (response.statusCode == 404) {
      print('Usuario no registrado');
      return false;
    } else {
      print('Error al verificar usuario: ${response.body}');
      return false;
    }
  }

  //registro google para nuestr app
  Future<int?> sendGoogleUid(String googleId, String email, String name) async {
    
    final response = await http.post(
      Uri.parse('$baseUrl/registro/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'name': name,
        'google_id': googleId,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Usuario registrado/verificado correctamente');
      final id = responseData['user_id'] as int;
      return id; 
    } else {
      print('Error al enviar UID de Google: ${response.body}');
      return 0; //TEMPORAL
    }
  }

  void logOut() async {
    final prefsService = SharedPreferencesService();

    await prefsService.clearSession();
    await FirebaseAuth.instance.signOut();
  }
}
