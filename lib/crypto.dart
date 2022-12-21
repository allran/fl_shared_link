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

      /// 这里可以配置类型
      final enc = Encrypter(AES(key, mode: AESMode.cbc));
      final encrypted = enc.encrypt(plainText, iv: IV.fromLength(16));
      return encrypted.base64;
    } catch (err) {
      // print("aes encode error:$err");
      return plainText;
    }
  }

  //AES解密
  static dynamic aesDecrypt(String encrypted) {
    try {
      final key = Key.fromUtf8(_key);
      final enc = Encrypter(AES(key, mode: AESMode.cbc));
      final decrypted = enc.decrypt64(encrypted, iv: IV.fromLength(16));
      return decrypted;
    } catch (err) {
      // print("aes decode error:$err");
      return encrypted;
    }
  }
}
