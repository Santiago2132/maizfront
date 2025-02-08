import 'package:flutter/material.dart';
import 'package:mAIz/data/services/auth_service.dart';
import 'package:mAIz/screens/login/Firebase/firebase_auth.dart';
import 'package:mAIz/screens/login/login_form.dart';
import 'package:mAIz/screens/login/newAccount.dart';
import 'package:mAIz/screens/navegator/main_screen.dart';
import 'package:mAIz/widgets/avatarWidget.dart';
import 'package:mAIz/widgets/terms_conditions.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _termsAccepted = false;
  final AuthService _authService = AuthService();

  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void _signInWithEmailAndPassword() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("El correo y la contraseña no pueden estar vacíos")),
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
        SnackBar(
            content: Text("Credenciales incorrectas o usuario no registrado")),
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
  
  void _signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        await firebaseAuth.signInWithCredential(credential);
        Navigator.pushNamed(context, "/home");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Inicio de sesión fallido: $e")),
      );
    }
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
                    onSignGoogle:  _signInWithGoogle ,
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

