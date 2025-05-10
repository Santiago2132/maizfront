import 'package:firebase_auth/firebase_auth.dart';
import 'package:mAIz/widgets/toast.dart';


class FirebaseAuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {

      if (e.code == 'email-already-in-use') {
        showToast(message: 'El correo electrónico ya está en uso.');
      } else {
        showToast(message: 'Ha ocurrido un error: ${e.code}');
      }
    }
    return null;

  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Correo o contaseña invalidos.');
      } else {
        showToast(message: 'Ha ocurrido un error: ${e.code}');
      }

    }
    return null;

  }




}