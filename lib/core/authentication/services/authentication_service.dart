//  Authentication Service - Provider that handles all FirebaseAuth Functions and User State Persistence
//
//  Author: SoTBurst
//  Co-Author: NightmindOfficial, damattl
//  (Refactored)

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linum/common/utils/subscription_handler.dart';
import 'package:linum/core/authentication/utils/apple_utils.dart';
import 'package:linum/core/authentication/utils/firebase_auth_extensions.dart';
import 'package:linum/core/authentication/utils/google_utils.dart';
import 'package:linum/core/events/event_service.dart';
import 'package:linum/core/events/event_types.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// TODO: Remove dependency on firebase
/// The AuthenticationService authenticates the user
/// and provides the information needed for other classes
class AuthenticationService extends SubscriptionHandler {
  /// The FirebaseAuth Object of the Project
  final FirebaseAuth _firebaseAuth;
  late Logger logger;


  /// Constructor
  AuthenticationService(this._firebaseAuth, {
    String? languageCode,
    required EventService eventService,
  }) {
    logger = Logger();

    super.subscribe(eventService.eventStream, (event) {
      if (event.type == EventType.languageChange) {
        updateLanguageCode(event.message);
      }
    });

    _user.add(_firebaseAuth.currentUser);
    updateLanguageCode(languageCode);
  }

  /// Returns the authStateChanges Stream from the FirebaseAuth
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  bool get isLoggedIn => _firebaseAuth.currentUid != "";

  bool get isInDebugMode => FirebaseFirestore.instance.settings.asMap["host"]
      .toString()
      .contains("localhost");

  final BehaviorSubject<User?> _user = BehaviorSubject();


  Stream<User?> get user => _user.stream;

  User? get currentUser => _user.value;
  String get userEmail => _firebaseAuth.userEmail;

  /// Tries to sign the user in
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
        setUser(_firebaseAuth.currentUser);

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

  /// Tries to sign the user up
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
        setUser(_firebaseAuth.currentUser);

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

      setUser(_firebaseAuth.currentUser);

      notifyListeners();
      onComplete("Successfully signed in to Firebase");
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
      onError("auth.${e.code}");
    }
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

      setUser(_firebaseAuth.currentUser);

      onComplete("Successfully signed in to Firebase");
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
      onError("auth.${e.code}");
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        logger.w("Sign in with Apple was aborted");
      } else {
        rethrow;
      }
    }
  }

  /// tells firebase that user wants to change its password to [newPassword]
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

        onComplete("alertdialog.update-password.message");

        notifyListeners();
      } else {
        onError("auth.not-logged-in-to-update-password");
        return;
      }
    } on FirebaseAuthException catch (e) {
      onError("auth.${e.code}");
    }
  }

  /// tells firebase that [email] wants to verify itself
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
      onError("auth.${e.code}");
    }
  }

  /// tells firebase that [email] wants to reset the password
  Future<void> resetPassword(
    String email, {
    void Function(String)? onComplete,
    void Function(String)? onError,
  }) async {
    onComplete ??= logger.i;
    onError ??= logger.e;
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      onComplete("alertdialog.reset-password.message");
    } on FirebaseAuthException catch (e) {
      onError("auth.${e.code}");
    }
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

      setUser(_firebaseAuth.currentUser);

      onComplete("Successfully signed out from Firebase");
    } on FirebaseAuthException catch (e) {
      onError("auth.${e.code}");
    }
  }

  Future<void> deleteUserAccount({
    void Function(String)? onComplete,
    void Function(String)? onError,
  }) async {
    onComplete ??= logger.i;
    onError ??= logger.e;
    try {
      await _firebaseAuth.currentUser?.delete();
      setUser(_firebaseAuth.currentUser);

      onComplete("Successfully deleted Account");
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        onError("auth.${e.code}");
        return signOut(onComplete: onComplete, onError: onError);
      }
      onError("auth.${e.code}");
    }
  }

  Future<void> setUser(User? user) async {
    if (user != null) {
      await setLastMail(_firebaseAuth.currentUser!.email);
    }
    _user.add(user);
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
