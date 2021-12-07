import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth) {
    print("created Service");
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Successfully signed in to Firebase";
    } on FirebaseAuthException catch (e) {
      return e.message != null
          ? e.message!
          : "Firebase Error with null message";
    }
  }

  Future<String> signUp(String email, String password) async {
    print("starting sign up");
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Successfully signed in to Firebase";
    } on FirebaseAuthException catch (e) {
      return e.message != null
          ? e.message!
          : "Firebase Error with null message";
    }
  }
}
