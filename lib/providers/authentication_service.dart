import 'dart:developer';

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
  Future<void> signIn(
    String email,
    String password, {
    void Function(String) onComplete = log,
    void Function(String) onError = log,
    void Function()? onNotVerified,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (isEmailVerified) {
        notifyListeners();
        onComplete("Successfully signed in to Firebase");
      } else {
        await sendVerificationEmail(email);
        signOut();
        if (onNotVerified != null) {
          onNotVerified();
        } else {
          log("Your mail is not verified.");
        }
      }
    } on FirebaseAuthException catch (e) {
      String? gerMessage = germanErrorVersion["auth/" + e.code];
      if (gerMessage != null) {
        onError(gerMessage);
      } else {
        onError(e.message != null
            ? e.message!
            : "Firebase Error with null message");
      }
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
          email: email, password: password);

      if (isEmailVerified) {
        notifyListeners();
        onComplete("Successfully signed up to Firebase");
      } else {
        await sendVerificationEmail(email);
        signOut();
        onNotVerified();
      }
    } on FirebaseAuthException catch (e) {
      String? gerMessage = germanErrorVersion["auth/" + e.code];
      if (gerMessage != null) {
        onError(gerMessage);
      } else {
        onError(e.message != null
            ? e.message!
            : "Firebase Error with null message");
      }
    }
  }

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
    void Function(String)? onComplete = log,
    void Function(String)? onError = log,
  }) async {
    try {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser!.updatePassword(newPassword);
      } else {
        onError!(germanErrorVersion["auth/not-logged-in-to-update-password"] ??
            "Error");
        return;
      }
      onComplete!("Successfully updated the password");
    } on FirebaseAuthException catch (e) {
      String? gerMessage = germanErrorVersion["auth/" + e.code];
      if (gerMessage != null) {
        onError!(gerMessage);
      } else {
        onError!(e.message != null
            ? e.message!
            : "Firebase Error with null message");
      }
    }
  }

  /// tells firebase that [email] wants to verify itself
  Future<void> sendVerificationEmail(
    String email, {
    void Function(String)? onComplete = log,
    void Function(String)? onError = log,
  }) async {
    try {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser!.sendEmailVerification();
      } else {
        onError!(germanErrorVersion["auth/not-logged-in-to-verify"] ?? "Error");
        return;
      }
      onComplete!("Successfully send Verification Mail request to Firebase");
    } on FirebaseAuthException catch (e) {
      String? gerMessage = germanErrorVersion["auth/" + e.code];
      if (gerMessage != null) {
        onError!(gerMessage);
      } else {
        onError!(e.message != null
            ? e.message!
            : "Firebase Error with null message");
      }
    }
  }

  /// tells firebase that [email] wants to reset the password
  Future<void> resetPassword(
    String email, {
    void Function(String)? onComplete = log,
    void Function(String)? onError = log,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      onComplete!("Successfully send password reset request to Firebase");
    } on FirebaseAuthException catch (e) {
      String? gerMessage = germanErrorVersion["auth/" + e.code];
      if (gerMessage != null) {
        onError!(gerMessage);
      } else {
        onError!(e.message != null
            ? e.message!
            : "Firebase Error with null message");
      }
    }
  }

  Future<void> signOut({
    void Function(String)? onComplete = log,
    void Function(String)? onError = log,
  }) async {
    try {
      await _firebaseAuth.signOut();
      notifyListeners();
      onComplete!("Successfully signed out from Firebase");
    } on FirebaseAuthException catch (e) {
      String? gerMessage = germanErrorVersion["auth/" + e.code];
      if (gerMessage != null) {
        onError!(gerMessage);
      } else {
        onError!(e.message != null
            ? e.message!
            : "Firebase Error with null message");
      }
    }
  }

  static const Map<String, String> germanErrorVersion = {
    "auth/claims-too-large":
        "Es gehen mehr Anfragen als zulässig ein. Bitte versuche es später noch einmal.",
    "auth/email-already-exists":
        "Die angegebene E-Mail wird bereits verwendet.",
    "auth/id-token-expired": "Das Authentication-ID-Token ist abgelaufen.",
    "auth/id-token-revoked": "Das Authentication-ID-Token wurde widerrufen.",
    "auth/insufficient-permission":
        "Dein Account hat nicht die Berechtigung, sich hier anzumelden. Bitte prüfe deine Anmeldedaten.",
    "auth/internal-error":
        "Es ist ein interner Fehler aufgetreten. Bitte melde dich bei support@investit-academy.de",
    "auth/invalid-argument":
        "Du hast eine ungültige Anmeldeangabe gemacht. Bitte melde dich bei support@investit-academy.de",
    "auth/invalid-claims":
        "Du hast eine Anmeldeanfrage ausgelöst, die nicht erlaubt ist. Bitte melde dich bei support@investit-academy.de",
    "auth/invalid-continue-uri":
        "Es ist ein interner Fehler aufgetreten. Bitte versuche es später noch einmal.",
    "auth/invalid-creation-time":
        "Der Server konnte deine Zeitzone nicht validieren. Bitte prüfe, ob die Zeit auf deinem Handy richtig eingestellt ist.",
    "auth/invalid-credential":
        "Die Anmeldeinformationen können nicht für die Anmeldung verwendet werden. Bitte melde dich bei support@investit-academy.de",
    "auth/invalid-disabled-field":
        "Wenn du diesen Fehler siehst, haben wir etwas grundfalsch gemacht. Bitte melde dich bei support@investit-academy.de",
    "auth/invalid-display-name":
        "Der bereitgestellte Wert für die displayName ist ungültig. Es muss eine nicht leere Zeichenfolge sein.",
    "auth/invalid-dynamic-link-domain":
        "Die bereitgestellte dynamische Linkdomäne ist für das aktuelle Projekt nicht konfiguriert oder autorisiert.",
    "auth/invalid-email":
        "Deine E-Mail-Adresse hat nicht das richtige Format. Vielleicht hast du dich vertippt?",
    "auth/invalid-email-verified":
        "Deine E-Mail-Adresse konnte nicht verifiziert werden. Vielleicht hast du dich vertippt?",
    "auth/invalid-hash-algorithm":
        "Der Hash-Algorithmus muss mit einer der Zeichenfolgen in der Liste der unterstützten Algorithmen übereinstimmen.",
    "auth/invalid-hash-block-size":
        "Die Hash-Blockgröße muss eine gültige Zahl sein.",
    "auth/invalid-hash-derived-key-length":
        "Die vom Hash abgeleitete Schlüssellänge muss eine gültige Zahl sein.",
    "auth/invalid-hash-key":
        "Der Hash-Schlüssel muss ein gültiger Byte-Puffer sein.",
    "auth/invalid-hash-memory-cost":
        "Die Hash-Speicherkosten müssen eine gültige Zahl sein.",
    "auth/invalid-hash-parallelization":
        "Die Hash-Parallelisierung muss eine gültige Zahl sein.",
    "auth/invalid-hash-rounds": "Die Hashrunden müssen eine gültige Zahl sein.",
    "auth/invalid-hash-salt-separator":
        "Das Salt-Separator-Feld des Hash-Algorithmus muss ein gültiger Byte-Puffer sein.",
    "auth/invalid-id-token":
        "Das bereitgestellte ID-Token ist kein gültiges Firebase-ID-Token.",
    "auth/invalid-last-sign-in-time":
        "Der Zeitpunkt der letzten Anmeldung muss eine gültige UTC-Datumszeichenfolge sein.",
    "auth/invalid-page-token":
        "Die bereitgestellten nächste Seite Token in listUsers() ist ungültig. Es muss sich um eine gültige, nicht leere Zeichenfolge handeln.",
    "auth/invalid-password":
        "Das eingegebene Passwort ist nicht korrekt. Vielleicht hast du dich vertippt?",
    "auth/invalid-password-hash":
        "Der Passwort-Hash muss ein gültiger Byte-Puffer sein.",
    "auth/invalid-password-salt":
        "Der Passwort-Salt muss ein gültiger Byte-Puffer sein",
    "auth/invalid-phone-number":
        "Der bereitgestellte Wert für den phoneNumber ist ungültig. Es muss sich um eine nicht leere, mit dem E.164-Standard kompatible Kennungszeichenfolge handeln.",
    "auth/invalid-photo-url":
        "Der bereitgestellte Wert für die photoURL Benutzereigenschaft ist ungültig. Es muss sich um eine Zeichenfolgen-URL handeln.",
    "auth/invalid-provider-data":
        "Die providerData muss ein gültiges Array von UserInfo-Objekten sein.",
    "auth/invalid-provider-id":
        "Die providerId muss eine gültige unterstützte Anbieterkennungszeichenfolge sein.",
    "auth/invalid-oauth-responsetype":
        "Nur genau ein OAuth responseType sollte auf true gesetzt werden.",
    "auth/invalid-session-cookie-duration":
        "Die Dauer des Sitzungscookies muss eine gültige Zahl in Millisekunden zwischen 5 Minuten und 2 Wochen sein.",
    "auth/invalid-uid":
        "Die bereitgestellte uid muss eine nicht leere Zeichenkette mit maximal 128 Zeichen.",
    "auth/invalid-user-import":
        "Der zu importierende Benutzerdatensatz ist ungültig.",
    "auth/maximum-user-count-exceeded":
        "Die maximal zulässige Anzahl von Benutzern zum Importieren wurde überschritten.",
    "auth/missing-android-pkg-name":
        "Ein Android-Paketname muss angegeben werden, wenn die Android-App installiert werden muss.",
    "auth/missing-continue-uri":
        "In der Anfrage muss eine gültige Weiter-URL angegeben werden.",
    "auth/missing-hash-algorithm":
        "Das Importieren von Benutzern mit Kennwort-Hashes erfordert, dass der Hashing-Algorithmus und seine Parameter bereitgestellt werden.",
    "auth/missing-ios-bundle-id": "In der Anfrage fehlt eine Bundle-ID.",
    "auth/missing-uid":
        "Eine uid Identifikator wird für den aktuellen Betrieb erforderlich.",
    "auth/missing-oauth-client-secret":
        "Der geheime OAuth-Konfigurationsclient ist erforderlich, um den OIDC-Codefluss zu aktivieren.",
    "auth/operation-not-allowed":
        "Der angegebene Anmeldeanbieter ist für Ihr Firebase-Projekt deaktiviert. Aktivieren Sie es aus dem Sign-in - Methode Abschnitt der Konsole Firebase.",
    "auth/phone-number-already-exists":
        "Der mitgelieferte phoneNumber ist bereits von einem vorhandenen Benutzer. Jeder Benutzer muss eine eindeutige haben phoneNumber .",
    "auth/project-not-found":
        "Für die zum Initialisieren der Admin-SDKs verwendeten Anmeldeinformationen wurde kein Firebase-Projekt gefunden. Siehe ein Projekt Firebase einrichten für Dokumentation, wie eine Berechtigung für Ihr Projekt zu generieren und es verwenden , um die Admin - SDKs zu authentifizieren.",
    "auth/reserved-claims":
        "Eine oder mehrere benutzerdefinierte Ansprüche bereitgestellt setCustomUserClaims() sind reserviert. Zum Beispiel OIDC spezifische Ansprüche wie (sub, iat, iss, exp, AUD, auth_time, usw.) sollen nicht als Schlüssel für die individuellen Ansprüche verwendet werden.",
    "auth/session-cookie-expired":
        "Das bereitgestellte Firebase-Sitzungscookie ist abgelaufen.",
    "auth/session-cookie-revoked":
        "Das Firebase-Sitzungscookie wurde widerrufen.",
    "auth/uid-already-exists":
        "Die bereitgestellte uid ist bereits von einem vorhandenen Benutzer. Jeder Benutzer muss eine eindeutige haben uid .",
    "auth/unauthorized-continue-uri":
        "Die Domain der Weiter-URL steht nicht auf der Whitelist. Setzen Sie die Domain in der Firebase Console auf die Whitelist.",
    "auth/user-not-found":
        "Mit dieser E-Mail-Adresse ist kein Account (mehr) verbunden. Du musst dich erst registrieren, um dich anmelden zu können.",
    "auth/not-logged-in-to-verify":
        "Du musst angemeldet zu sein um eine Verifikations-email los zu schicken.", // Custom error message
    "auth/not-logged-in-to-update-password":
        "Du musst angemeldet zu sein um dein Passwort in der App zu ändern.", // Custom error message
  };
}
