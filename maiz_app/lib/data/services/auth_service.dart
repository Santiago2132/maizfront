import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mAIz/models/shared_preferences.dart';

class AuthService {
  final String baseUrl =
      'http://10.153.90.64:4000'; //sirve en la api de base de datos

  final prefsService = SharedPreferencesService();

  Future<bool> registerUser(
      BuildContext context, String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        //ScaffoldMessenger.of(context).showSnackBar(
        //SnackBar(content: Text('Usuario registrado correctamente: UID: ${user.uid}')),
        //);
        final response = await http.post(
          Uri.parse('$baseUrl/registro/app'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
            'google_id': user.uid,
          }),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          print('Usuario registrado correctamente en el servidor');

          return true;
        } else {
          print('Error al registrar usuario en el servidor: ${response.body}');
          return false;
        }
      } else {
        print('Error al obtener el UID de Firebase');
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
  Future<bool> verifyUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/app'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print('Usuario encontrado: ${response.body}');

      final data = jsonDecode(response.body);
      print(data);
      //token y userId de la respuesta
      final token = data['token'];
      final userId = data['user']['id'];
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
  Future<String?> sendGoogleUid(
      String googleId, String email, String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registro/google/'),
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
      return responseData['id'].toString();
    } else {
      print('Error al enviar UID de Google: ${response.body}');
      return null;
    }
  }

  void logOut() async {
    final prefsService = SharedPreferencesService();

    await prefsService.clearSession();
    await FirebaseAuth.instance.signOut();
  }
}
