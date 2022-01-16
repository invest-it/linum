import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// The AuthenticationService authenticates the user
/// and provides the information needed for other classes
class AuthenticationService extends ChangeNotifier {
  /// The FirebaseAuth Object of the Project
  final FirebaseAuth _firebaseAuth;

  /// Constructor
  AuthenticationService(this._firebaseAuth);

  /// Returns the authStateChanges Stream from the FirebaseAuth
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  bool get isLoggedIn => uid != "";

  /// Tries to sign the user in
  Future<String> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();

      return "Successfully signed in to Firebase";
    } on FirebaseAuthException catch (e) {
      return e.message != null
          ? e.message!
          : "Firebase Error with null message";
    }
  }

  /// Tries to sign the user up
  Future<String> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
      return "Successfully signed in to Firebase";
    } on FirebaseAuthException catch (e) {
      return e.message != null
          ? e.message!
          : "Firebase Error with null message";
    }
  }

  /// returns the uid, and if the user isnt logged in return ""
  String get uid {
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser!.uid;
    }
    return "";
  }

  /// tells firebase that [email] wants to reset the password
  Future<String> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "Successfully send password reset request to Firebase";
    } on FirebaseAuthException catch (e) {
      return e.message != null
          ? e.message!
          : "Firebase Error with null message";
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }
}
