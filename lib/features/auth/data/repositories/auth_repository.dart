import 'package:firebase_auth/firebase_auth.dart';
import 'package:perfect_super_admin/features/auth/data/services/firebase_authservice.dart';

class AuthRepository {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  Future<User?> getadmindetail() async {
    return _firebaseAuthService.getCurrentAdmin();
  }

  Future<User?> loginWithEmailandPassword(String email, String password) {
    return _firebaseAuthService.loginWithEmailandPassword(email, password);
  }

  Future<void> signout() async {
    await _firebaseAuthService.signout();
  }
}
