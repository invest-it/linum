import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linum/backend_functions/cryptography.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// The AuthenticationService authenticates the user
/// and provides the information needed for other classes
class AuthenticationService extends ChangeNotifier {
  /// The FirebaseAuth Object of the Project
  final FirebaseAuth _firebaseAuth;

  /// Constructor
  AuthenticationService(this._firebaseAuth, BuildContext context) {
    updateLanguageCode(context);
  }

  /// Returns the authStateChanges Stream from the FirebaseAuth
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  bool get isLoggedIn => uid != "";

  bool get isInDebugMode => FirebaseFirestore.instance.settings.asMap["host"]
      .toString()
      .contains("localhost");

  /// Tries to sign the user in
  Future<void> signIn(
    String email,
    String password, {
    void Function(String) onComplete = log,
    void Function(String) onError = log,
    void Function()? onNotVerified,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (isEmailVerified) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('lastMail', email);
        notifyListeners();
        onComplete("Successfully signed in to Firebase");
      } else {
        await sendVerificationEmail(email, onError: onError);
        await signOut();
        if (onNotVerified != null) {
          onNotVerified();
        } else {
          log("Your mail is not verified.");
        }
      }
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      onError("auth/${e.code}");
    }
  }

  /// Tries to sign the user up
  Future<void> signUp(
    String email,
    String password, {
    void Function(String) onComplete = log,
    void Function(String) onError = log,
    required void Function() onNotVerified,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (isEmailVerified) {
        notifyListeners();
        onComplete("Successfully signed up to Firebase");
      } else {
        await sendVerificationEmail(email);
        signOut();
        onNotVerified();
      }
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      onError("auth/${e.code}");
    }
  }

  Future<void> signInWithGoogle({
    void Function(String) onComplete = log,
    void Function(String) onError = log,
  }) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );


    try {
      await _firebaseAuth.signInWithCredential(credential);
      notifyListeners();
      onComplete("Successfully signed in to Firebase");
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      onError("auth/${e.code}");
    }

  }

  Future<void> signInWithApple({
    void Function(String) onComplete = log,
    void Function(String) onError = log,
  }) async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      await _firebaseAuth.signInWithCredential(oauthCredential);
      notifyListeners();
      onComplete("Successfully signed in to Firebase");
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      onError("auth/${e.code}");
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        log("Sign in with Apple was aborted");
      } else {
        rethrow;
      }
    }
  }
  // TODO: Refactor already??

  /// returns the uid, and if the user isnt logged in return ""
  String get uid {
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser!.uid;
    }
    return "";
  }

  String get userEmail {
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser!.email ?? "No Email found";
    }
    return "";
  }

  /// Shouldn't be found
  String get displayName {
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser!.displayName ?? "No Displayname found";
    }
    return "";
  }

  bool get isEmailVerified {
    if (isInDebugMode) {
      return true;
    }
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser!.emailVerified;
    }
    return false;
  }

  DateTime? get lastLogin {
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser!.metadata.lastSignInTime;
    }
    return null;
  }

  DateTime? get creationDate {
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser!.metadata.creationTime;
    }
    return null;
  }

  /// tells firebase that user wants to change its password to [newPassword]
  Future<void> updatePassword(
    String newPassword, {
    void Function(String) onComplete = log,
    void Function(String) onError = log,
  }) async {
    try {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser!.updatePassword(newPassword);

        onComplete("alertdialog/update-password/message");

        notifyListeners();
      } else {
        onError("auth/not-logged-in-to-update-password");
        return;
      }
    } on FirebaseAuthException catch (e) {
      onError("auth/${e.code}");
    }
  }

  /// tells firebase that [email] wants to verify itself
  Future<void> sendVerificationEmail(
    String email, {
    void Function(String) onError = log,
  }) async {
    try {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser!.sendEmailVerification();
      } else {
        onError("auth/not-logged-in-to-verify");
        return;
      }
      log("Successfully send Verification Mail request to Firebase");
    } on FirebaseAuthException catch (e) {
      onError("auth/${e.code}");
    }
  }

  /// tells firebase that [email] wants to reset the password
  Future<void> resetPassword(
    String email, {
    void Function(String) onComplete = log,
    void Function(String) onError = log,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      onComplete("alertdialog/reset-password/message");
    } on FirebaseAuthException catch (e) {
      onError("auth/${e.code}");
    }
  }

  Future<void> signOut({
    void Function(String) onComplete = log,
    void Function(String) onError = log,
  }) async {
    try {
      final isSignedInWithGoogle = await GoogleSignIn().isSignedIn();
      if (isSignedInWithGoogle) {
        await GoogleSignIn().signOut();
      }
      await _firebaseAuth.signOut();
      notifyListeners();
      onComplete("Successfully signed out from Firebase");
    } on FirebaseAuthException catch (e) {
      onError("auth/${e.code}");
    }


  }

  void updateLanguageCode(BuildContext context) {
    _firebaseAuth.setLanguageCode(
      AppLocalizations.of(context)?.locale.languageCode ?? "en",
    );
  }
}
