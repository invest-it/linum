import 'package:firebase_auth/firebase_auth.dart';

extension FirebaseAuthExtensions on FirebaseAuth {
  String get currentUid { // TODO Remove
    if (currentUser != null) {
      return currentUser!.uid;
    }
    return "";
  }

  String get userEmail {
    if (currentUser != null) {
      return currentUser!.email ?? "No Email found";
    }
    return "";
  }

  String get displayName {
    if (currentUser != null) {
      return currentUser!.displayName ?? "No Display-Name found";
    }
    return "";
  }

  bool get isEmailVerified {
    if (currentUser != null) {
      return currentUser!.emailVerified;
    }
    return false;
  }

  DateTime? get lastLogin {
    if (currentUser != null) {
      return currentUser!.metadata.lastSignInTime;
    }
    return null;
  }

  DateTime? get creationDate {
    if (currentUser != null) {
      return currentUser!.metadata.creationTime;
    }
    return null;
  }
}