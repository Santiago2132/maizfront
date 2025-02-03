class AuthService {
  
  Future<bool> signIn(String email, String password) async {
    await Future.delayed(Duration(seconds: 2)); // Simula tiempo de respuesta
    print("Email: $email, Password: $password");
    return email == "usuario@gmail.com" && password == "123456";
  }


   Future<bool> signUp(String name, String email, String password) async {
    await Future.delayed(Duration(seconds: 2)); // Simula tiempo de respuesta

    // Aquí podrías agregar la lógica para verificar que el email no esté registrado,
    // y si lo está, retornar false, pero por ahora simulamos un registro exitoso.
    print("Registrando usuario: $name, Email: $email, Password: $password");
    
    // Suponemos que el registro siempre es exitoso
    return true;
  }
}
