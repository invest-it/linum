import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linum/common/utils/subscription_handler.dart';
import 'package:linum/core/authentication/domain/utils/apple_utils.dart';
import 'package:linum/core/authentication/domain/utils/firebase_auth_extensions.dart';
import 'package:linum/core/authentication/domain/utils/google_utils.dart';
import 'package:linum/core/events/event_service.dart';
import 'package:linum/core/events/event_types.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// TODO: Remove dependency on firebase
/// The AuthenticationService authenticates the user
/// and provides the information needed for other classes
class AuthenticationService extends SubscriptionHandler {
  /// The FirebaseAuth Object of the Project
  final FirebaseAuth _firebaseAuth;
  late Logger logger;


  AuthenticationService(this._firebaseAuth, {
    String? languageCode,
    required EventService eventService,
  }) {
    logger = Logger();

    super.subscribe(eventService.getGlobalEventStream(), (event) {
      if (event.type == EventType.languageChange) {
        updateLanguageCode(event.message);
      }
    });

    updateLanguageCode(languageCode);
  }

  /// Returns the authStateChanges Stream from the FirebaseAuth
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  bool get isLoggedIn => _firebaseAuth.currentUid != "";

  bool get isInDebugMode => FirebaseFirestore.instance.settings.asMap["host"]
      .toString()
      .contains("localhost");


  User? get currentUser => _firebaseAuth.currentUser;
  String get userEmail => _firebaseAuth.userEmail;

  Future<void> signIn(
    String email,
    String password, {
    void Function(String)? onComplete,
    void Function(String)? onError,
    void Function()? onNotVerified,
  }) async {
    onComplete ??= logger.i;
    onError ??= logger.e;

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (_firebaseAuth.isEmailVerified) {
        await handleUserChange();

        onComplete("Successfully signed in to Firebase");
      } else {
        await sendVerificationEmail(email, onError: onError);
        await signOut();

        if (onNotVerified != null) {
          onNotVerified();
        } else {
          logger.i("Your mail is not verified.");
        }
      }

    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
      onError("auth.${e.code}");
    }
  }

  Future<void> signUp(
    String email,
    String password, {
    void Function(String)? onComplete,
    void Function(String)? onError,
    required void Function() onNotVerified,
  }) async {
    onComplete ??= logger.i;
    onError ??= logger.e;

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (_firebaseAuth.isEmailVerified) {
        await handleUserChange();

        onComplete("Successfully signed up to Firebase");
      } else {
        await sendVerificationEmail(email);
        await signOut();
        onNotVerified();
      }
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
      onError("auth.${e.code}");
    }
  }

  Future<void> signInWithGoogle({
    void Function(String)? onComplete,
    void Function(String)? onError,
  }) async {
    onComplete ??= logger.i;
    onError ??= logger.e;

    try {
      final credentials = await acquireGoogleCredentials();
      await _firebaseAuth.signInWithCredential(credentials);
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
      return onError("auth.${e.code}");
    }

    onComplete("Successfully signed in to Firebase");
    await handleUserChange();
  }

  Future<void> signInWithApple({
    void Function(String)? onComplete,
    void Function(String)? onError,
  }) async {
    onComplete ??= logger.i;
    onError ??= logger.e;

    try {
      final credentials = await acquireAppleCredentials();
      await _firebaseAuth.signInWithCredential(credentials);
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
      return onError("auth.${e.code}");
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        logger.w("Sign in with Apple was aborted");
      } else {
        rethrow; // TODO: This is quite ugly
      }
      return;
    }

    onComplete("Successfully signed in to Firebase");
    await handleUserChange();
  }

  Future<void> updatePassword(
    String newPassword, {
    void Function(String)? onComplete,
    void Function(String)? onError,
  }) async {
    onComplete ??= logger.i;
    onError ??= logger.e;
    try {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser!.updatePassword(newPassword);
      } else {
        return onError("auth.not-logged-in-to-update-password");
      }
    } on FirebaseAuthException catch (e) {
      return onError("auth.${e.code}");
    }

    onComplete("alertdialog.update-password.message");
    notifyListeners();
  }

  Future<void> updateEmail(
      String newEmail, {
        void Function(String)? onComplete,
        void Function(String)? onError,
      }) async {
    onComplete ??= logger.i;
    onError ??= logger.e;
    try {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser!.updateEmail(newEmail);
      } else {
        return onError("auth.not-logged-in-to-update-email");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        onError("auth.${e.code}");
        return signOut(onError: onError);
      }
      if (e.code == "email-already-in-use") {
        return onError("auth.email-already-exists");
      }
      return onError("auth.${e.code}");
    }
    onComplete("alertdialog.update-email.message");
    notifyListeners();
  }

  /// Sends a verification email to the current users email address.
  /// Fails if there is no user currently logged in.
  Future<void> sendVerificationEmail(
    String email, {
    void Function(String)? onError,
  }) async {
    onError ??= logger.e;
    try {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser!.sendEmailVerification();
      } else {
        onError("auth.not-logged-in-to-verify");
        return;
      }
      logger.i("Successfully send Verification Mail request to Firebase");
    } on FirebaseAuthException catch (e) {
      return onError("auth.${e.code}");
    }
  }

  /// Sends a reset password email to the current users email address.
  Future<void> resetPassword(
    String email, {
    void Function(String)? onComplete,
    void Function(String)? onError,
  }) async {
    onComplete ??= logger.i;
    onError ??= logger.e;
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if(e.code == "user-not-found"){
        return onError("auth.email-not-found");
      }
      if(e.code == "invalid-email"){
        return onError("auth.invalid-email");
      }
      return onError("auth.unknown");
    }
    onComplete("alertdialog.reset-password.message");
  }

  Future<void> signOut({
    void Function(String)? onComplete,
    void Function(String)? onError,
  }) async {
    onComplete ??= logger.i;
    onError ??= logger.e;
    try {
      final isSignedInWithGoogle = await GoogleSignIn().isSignedIn();
      if (isSignedInWithGoogle) {
        await GoogleSignIn().signOut();
      }
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return onError("auth.${e.code}");
    }
    await handleUserChange();
    onComplete("Successfully signed out from Firebase");
  }

  Future<void> deleteUserAccount({
    void Function(String)? onComplete,
    void Function(String)? onError,
  }) async {
    onComplete ??= logger.i;
    onError ??= logger.e;
    try {
      await _firebaseAuth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        onError("auth.${e.code}");
        return signOut(onComplete: onComplete, onError: onError);
      }
      return onError("auth.${e.code}");
    }
    await handleUserChange();
    Fluttertoast.showToast(
      msg: tr(translationKeys.auth.userDeleted),
      toastLength: Toast.LENGTH_LONG,
    );
    onComplete("Successfully deleted Account");
  }

  Future<void> handleUserChange() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await setLastMail(user.email);
    }
    notifyListeners();
  }

  Future<void> setLastMail(String? email) async {
    if (email == null) {
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastMail', email);
  }


  void updateLanguageCode(String? languageCode) {
    _firebaseAuth.setLanguageCode(languageCode);
  }


}
