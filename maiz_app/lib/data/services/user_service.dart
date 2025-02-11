import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // nombre del usuario autenticado en Firebase
  Future<String> getUserName() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      return 'Usuario';
    }

    //  nombre desde Firebase Auth
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!;
    }

    //  desde Firestore
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
}
