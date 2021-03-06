//  Cryptography - Accommodates basic encryption functions, mainly Secure Hash Algorithm Class 2 (SHA-2) functions.
//
//  Author: damattl
//  Co-Author: NightmindOfficial (Not for the code, only regarding Security Concerns)
//

import 'dart:convert';
import 'package:crypto/crypto.dart';

/* String generateNonce([int length = 32]) {
  const charset = "0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._";
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
} */

String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
