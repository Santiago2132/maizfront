import 'package:flutter/material.dart';
import 'package:maiz_app/data/services/auth_service.dart';
import 'package:maiz_app/screens/login/login_form.dart';
import 'package:maiz_app/screens/login/newAccount.dart';
import 'package:maiz_app/screens/navegator/main_screen.dart';
import 'package:maiz_app/widgets/avatarWidget.dart';
import 'package:maiz_app/widgets/terms_conditions.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _termsAccepted = false;
  AuthService _authService = AuthService();

  void _signInWithEmailAndPassword() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("El correo y la contraseña no pueden estar vacíos")),
      );
      return;
    }

    bool result = await _authService.signIn(email, password);
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Inicio de sesión exitoso")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Credenciales incorrectas o usuario no registrado")),
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

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/resources/fondoMorado.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AvatarWidget(),
                  SizedBox(height: 20),
                  LoginForm(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    termsAccepted: _termsAccepted,
                    onTermsChanged: (value) {
                      setState(() {
                        _termsAccepted = value;
                      });
                    },
                    onSignIn: _termsAccepted ? _signInWithEmailAndPassword : null,
                    onShowTerms: _showTermsAndConditions,
                    onNavigateToSignUp: _navigateToSignUp,
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