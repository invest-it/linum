import 'package:firebase_auth/firebase_auth.dart';
import 'package:linum/common/utils/cryptography.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<OAuthCredential> acquireAppleCredentials() async {
  final rawNonce = generateNonce();
  final nonce = sha256ofString(rawNonce);

  final appleCredential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    nonce: nonce,
  );
  return OAuthProvider("apple.com").credential(
    idToken: appleCredential.identityToken,
    rawNonce: rawNonce,
  );
}
