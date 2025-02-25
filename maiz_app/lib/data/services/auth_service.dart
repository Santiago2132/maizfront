import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:4000';

  // Registro de usuario sin Google, enviando también el UID de Firebase
  Future<bool> registerUser(String name, String email, String password) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;
    print(user);
    if (user != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'photo': null,
          'password': password,
          'google_id': user.uid, // Enviar también el UID de Firebase
        }),
      );
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Usuario registrado correctamente');
        return true;
      } else {
        print('Error al registrar usuario: ${response.body}');
        return false;
      }
    } else {
      print('Error al obtener el UID de Firebase');
      return false;
    }
  }

  // Login sin google
  Future<bool> verifyUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
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

  // Enviar UID de Google/Firebase al servidor
  Future<bool> sendGoogleUid(
      String googleId, String email, String name, String? photoUrl) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'google_id': googleId,
        'email': email,
        'name': name,
        'photo': photoUrl,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Usuario de Google registrado/verificado correctamente');
      return true;
    } else {
      print('Error al enviar UID de Google: ${response.body}');
      return false;
    }
  }
}
