class AuthService {
  Future<bool> signIn(String email, String password) async {
    // Simulación de validación de credenciales
    await Future.delayed(Duration(seconds: 2)); // Simula tiempo de respuesta del servidor
    return email == "usuario@ejemplo.com" && password == "123456";
  }
}