import 'package:firebase_auth/firebase_auth.dart';
import 'package:style_ml/models/user.dart';
import 'package:style_ml/providers/auth_provider.dart';

class FirebaseAuthProvider implements AuthProvider {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<UserModel?> get stream {
    return _firebaseAuth
        .authStateChanges()
        .map((user) => user != null ? UserModel(uid: user.uid) : null);
  }

  @override
  Future<void> createUser(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      } else {
        throw InvalidEmailException();
      }
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw InvalidEmailException();
      } else {
        throw WrongCredentialsException();
      }
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
