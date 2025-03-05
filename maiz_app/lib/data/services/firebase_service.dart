import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para iniciar sesión con Google y guardar el UID en Firestore
  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut(); // Cerrar sesión previa para elegir otra cuenta
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

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
              'uid': uid,  // Guarda el UID
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

  // Método para obtener el nombre del usuario autenticado
  Future<String> getUserName() async {
    final User? user = _auth.currentUser;

    if (user == null) return 'Usuario';

    // Nombre desde Firebase Auth
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!;
    }

    // Nombre desde Firestore
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();
    if (userDoc.exists && userDoc.data() != null) {
      var data = userDoc.data() as Map<String, dynamic>;
      if (data.containsKey('name') && data['name'] != null) {
        return data['name'];
      }
    }

    return 'Usuario';
  }


  Future<void> registerUser(String email, String password, String name) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'createdAt': DateTime.now(),
      });

      await user.updateDisplayName(name);
    }
  }

  Future<String?> _getUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }
}
