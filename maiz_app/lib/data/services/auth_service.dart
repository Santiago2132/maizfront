class AuthService {
  
  Future<bool> signIn(String email, String password) async {
    await Future.delayed(Duration(seconds: 2)); // Simula tiempo de respuesta
    print("Email: $email, Password: $password");
    return email == "usuario@gmail.com" && password == "123456";
  }



   Future<bool> signUp(String name, String email, String password) async {
    await Future.delayed(Duration(seconds: 2)); // Simula tiempo de respuesta

    print("Registrando usuario: $name, Email: $email, Password: $password");
    
    // registro siempre es exitoso
    return true;
  }
}
