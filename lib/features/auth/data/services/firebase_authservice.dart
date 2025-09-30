import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> loginWithEmailandPassword(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    final userDoc = await _firestore.collection('admins').doc(uid).get();

    final role = userDoc.data()?['role'];

    if (role == 'admin') {
      return credential.user;
    } else {
      // User is authenticated but not an admin — sign them out
      await _auth.signOut();
      return null;
    }
  }

  Future<User?> getCurrentAdmin() async {
    return _auth.currentUser;
  }

  Future<void> signout() async {
    await _auth.signOut();
  }
}
