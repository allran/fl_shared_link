import 'dart:convert';
import 'package:encrypt/encrypt.dart';

///定义秘钥 密钥长度为16/24/32位
var _key = "0123456789becoin";

/// 加密工具类
class EncryptUtils {
  //Base64编码
  static String encodeBase64(String data) {
    return base64Encode(utf8.encode(data));
  }

  //Base64解码
  static String decodeBase64(String data) {
    return String.fromCharCodes(base64Decode(data));
  }

  //AES加密
  static aesEncrypt(String plainText) {
    try {
      final key = Key.fromUtf8(_key);
      // final iv = IV.fromLength(16); (ok in 5.0.1 not in 5.0.3)
      final iv = IV.allZerosOfLength(16);
      final encrypter = Encrypter(AES(key));
      return encrypter.encrypt(plainText, iv: iv).base64;
    } catch (err) {
      print("aes encode error:$err");
      return plainText;
    }
  }

  //AES解密
  static dynamic aesDecrypt(String encrypted) {
    try {
      final key = Key.fromUtf8(_key);
      // final iv = IV.fromLength(16); (ok in 5.0.1 not in 5.0.3)
      final iv = IV.allZerosOfLength(16);
      final encrypter = Encrypter(AES(key));
      return encrypter.decrypt(Encrypted.fromBase64(encrypted), iv: iv);
    } catch (err) {
      print("aes decode error:$err");
      return encrypted;
    }
  }
}
