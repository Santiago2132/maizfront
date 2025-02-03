import 'package:flutter/material.dart';
import 'package:maiz_app/data/services/auth_service.dart';
import 'package:maiz_app/screens/login/login_screen.dart';
import 'package:maiz_app/widgets/terms_login.dart'; // Importar la pantalla de login

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _termsAccepted = false;

  // Instancia del servicio
  AuthService _authService = AuthService();

  void _signUp() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor complete todos los campos")),
      );
      return;
    }

    // Simulación de registro
    bool result = await _authService.signUp(name, email, password);
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registro exitoso")),
      );
      Navigator.pop(context); // Regresa a la pantalla de login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al registrar la cuenta")),
      );
    }
  }
  
  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TermsAndConditionsDialog();
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro"),
        backgroundColor: Colors.purple.shade700, // Fondo morado en la AppBar
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/fondoMorado.jpg', // Fondo morado
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/avatar.png'), // Avatar
                    backgroundColor: Colors.purple.shade700,
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: "Nombre",
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Correo Electrónico",
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Checkbox(
                              value: _termsAccepted,
                              onChanged: (bool? value) {
                                setState(() {
                                  _termsAccepted = value ?? false;
                                });
                              },
                            ),
                            GestureDetector(
                              onTap: _showTermsAndConditions,
                              child: Text("Acepto los términos y condiciones"),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _termsAccepted ? _signUp : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 24),
                          ),
                          child: Text("Registrar",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            // Navegar hacia la pantalla de login
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text(
                            "¿Ya tienes una cuenta? Inicia sesión",
                            style: TextStyle(color: Colors.purple.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
