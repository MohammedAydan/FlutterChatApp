import 'package:encrypt/encrypt.dart';

class EncryptData {
  static const String _keyString = 'CHAT-MAG-V1-PRIVATE-KEY-12345678';
  static final Key _key = Key.fromUtf8(_keyString);
  static final Encrypter _encrypter = Encrypter(AES(_key, padding: null));

  static String encryptAES(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: IV.fromLength(0));
    return encrypted.base64;
  }

  static String? decryptAES(String cipherText) {
    try {
      final decrypted = _encrypter.decrypt64(cipherText, iv: IV.fromLength(0));
      return decrypted;
    } catch (error) {
      print("Error decrypting: $error");
      return cipherText;
    }
  }
}
