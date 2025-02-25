import 'package:flutter/material.dart';
import 'package:mAIz/data/services/auth_service.dart';
import 'package:mAIz/screens/login/login_screen.dart';
import 'package:mAIz/widgets/avatarWidget.dart';
import 'package:mAIz/widgets/terms_conditions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _termsAccepted = false;

  final AuthService _authService = AuthService();

  void _signUp() async {
    if (!_validateFields()) return;

    bool result = await _authService.registerUser(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );

    if (result) {
      _showMessage("Registro exitoso");
      Navigator.pop(context);
    } else {
      _showMessage("Error al registrar la cuenta");
    }
  }

  bool _validateFields() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showMessage("Por favor complete todos los campos");
      return false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showMessage("Las contraseñas no coinciden");
      return false;
    }

    if (!_termsAccepted) {
      _showMessage("Debe aceptar los términos y condiciones");
      return false;
    }

    return true;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) => const TermsAndConditionsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AvatarWidget(),
                    _buildFormContainer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField(_nameController, "Nombre"),
          const SizedBox(height: 16),
          _buildTextField(_emailController, "Correo Electrónico"),
          const SizedBox(height: 16),
          _buildTextField(_passwordController, "Contraseña", obscureText: true),
          const SizedBox(height: 16),
          _buildTextField(_confirmPasswordController, "Confirmar contraseña", obscureText: true),
          const SizedBox(height: 16),
          _buildTermsCheckbox(),
          const SizedBox(height: 20),
          _buildRegisterButton(),
          const SizedBox(height: 20),
          _buildLoginLink(),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.7),
      ),
      obscureText: obscureText,
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _termsAccepted,
          onChanged: (bool? value) => setState(() => _termsAccepted = value ?? false),
        ),
        GestureDetector(
          onTap: _showTermsAndConditions,
          child: const Text(
            "Acepto los términos y condiciones",
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _signUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
      child: const Text("Registrar", style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }

  Widget _buildLoginLink() {
    return TextButton(
      onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      ),
      child: const Text(
        "¿Ya tienes una cuenta? Inicia sesión",
        style: TextStyle(
          color: Colors.white,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white,
        ),
      ),
    );
  }
}