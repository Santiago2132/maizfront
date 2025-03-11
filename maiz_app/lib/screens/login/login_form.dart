import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool termsAccepted;
  final ValueChanged<bool> onTermsChanged;
  final VoidCallback? onSignIn;
  final VoidCallback? onSignGoogle;
  final VoidCallback onShowTerms;
  final VoidCallback onNavigateToSignUp;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.termsAccepted,
    required this.onTermsChanged,
    required this.onSignIn,
    required this.onSignGoogle,
    required this.onShowTerms,
    required this.onNavigateToSignUp,
  });

  @override
  Widget build(BuildContext context) {
      final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Correo Electrónico",
              labelStyle:  TextStyle(color: isDarkMode ? Colors.black : Colors.white,),
              filled: true,
              fillColor: Colors.white.withOpacity(0.7),
            ),
            style: TextStyle(color: isDarkMode ? Colors.black : Colors.black ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Contraseña",
              labelStyle:  TextStyle(color: isDarkMode ? Colors.black : Colors.white,),
              filled: true,
              fillColor: Colors.white.withOpacity(0.7),
            ),
            style: TextStyle(color: isDarkMode ? Colors.black : Colors.black ),

            obscureText: true,
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: termsAccepted,
                onChanged: (bool? value) {
                  onTermsChanged(value ?? false);
                },
              ),
              GestureDetector(
                onTap: onShowTerms,
                child: Text(
                  "Términos y Condiciones",
                  style: TextStyle(
                      color: Colors.white, // Texto
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white),
                      textAlign: TextAlign.center,
                ),
                
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onSignIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade900,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            ),
            child: Text(
              "INICIAR SESIÓN",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onSignGoogle,
            icon: Image.asset('assets/resources/logoGoogle.png', height: 24),
            label: Text("Ingresar con Google"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: onNavigateToSignUp,
            child: Text(
              "¿No tienes una cuenta? Regístrate",
              style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white),
                  textAlign: TextAlign.center,

            ),
          ),
        ],
      ),
    );
  }
}
