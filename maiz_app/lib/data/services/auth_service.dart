import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final String baseUrl =
      'http://192.168.20.71:4000'; //sirve en la api de base de datos
 
 
  Future<bool> registerUser(BuildContext context, String name, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        //ScaffoldMessenger.of(context).showSnackBar(
         //SnackBar(content: Text('Usuario registrado correctamente: UID: ${user.uid}')),
        //);

        final response = await http.post(
          Uri.parse('$baseUrl/usuarios'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
            'google_id': user.uid,
          }),
        );

        if (response.statusCode == 201) {
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
        Uri.parse('$baseUrl/login'),
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

