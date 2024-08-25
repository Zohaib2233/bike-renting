import 'dart:convert';
import 'package:bike_gps/core/env/keys.dart';
import 'package:crypto/crypto.dart';

class KnaapEncryption {
  // Private constructor
  KnaapEncryption._privateConstructor();

  // Singleton instance variable
  static KnaapEncryption? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to KnaapEncryption.instance will return the same instance that was created before.

  // Getter to access the singleton instance
  static KnaapEncryption get instance {
    _instance ??= KnaapEncryption._privateConstructor();
    return _instance!;
  }

  //method to encrypt 32-bit string
  String _encryptMD5(String input) {
    //converting the input string into bytes
    var bytes = utf8.encode(input);

    //calculating MD5 hash
    var md5Hash = md5.convert(bytes);

    //returning the hash as a string
    return md5Hash.toString();
  }

  //method to generate signature (for getting access token)
  (String, String) generateSignature() {
    //MichaelFiering login key
    String loginKey = michaelFieringLoginKey;

    //encrypting the login key
    String encryptedLoginKey = _encryptMD5(loginKey);

    DateTime now = DateTime.now();

    int timestampInSeconds = now.toUtc().millisecondsSinceEpoch ~/ 1000;

    //concatenating the encryptedLoginKey and current timestamp
    String encryptedKeyWithTimestamp =
        encryptedLoginKey + timestampInSeconds.toString();

    //encyrpting the concatented string again
    String signature = _encryptMD5(encryptedKeyWithTimestamp);

    return (signature, timestampInSeconds.toString());
  }
}
