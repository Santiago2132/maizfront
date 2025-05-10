
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mAIz/models/shared_preferences.dart';

class UserService {
  final prefsService = SharedPreferencesService();
  // Método para iniciar sesión con Google y guardar el UID en Firestore
  /* Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn
          .signOut(); // Cerrar sesión previa para elegir otra cuenta
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          String uid = user.uid; // 🔥 Obtén el UID del usuario

          // Guardar en Firestore si no existe
          DocumentSnapshot userDoc =
              await _firestore.collection('users').doc(uid).get();

          if (!userDoc.exists) {
            await _firestore.collection('users').doc(uid).set({
              'uid': uid, // Guarda el UID
              'name': user.displayName ?? 'Usuario',
              'email': user.email,
              'photoUrl': user.photoURL,
              'createdAt': DateTime.now(),
            });
          }
        }
      }
    } catch (e) {
      print("Error al iniciar sesión con Google: $e");
    }
  }
*/

  // Método para obtener el nombre del usuario autenticado
  Future<String> getUserName() async {
  
    final name = await prefsService.getUserName();

    // Si no existe, retorna un valor por defecto
    return name ?? 'Invitado';
  }

  Future<int> getUserId() async {
   
    final id = await prefsService.getUserId();
    print('id de la app');
    print(id);
    // Si no existe, retorna un valor por defecto
    return id ?? 0;
  }





}
