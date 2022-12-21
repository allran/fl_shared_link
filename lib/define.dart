import './crypto.dart';

const String encryptWx = "pine1Jzl1ZUpxcM1LbEkxg==";
const String encryptWxname = "NWsi9XvGVjkfBWC670z1JQ==";
const String encryptSafep = "eR9EZrdqvq5blvEKpMxc+w==";

const String encryptAl = "FtFVwxkL/d6vBBgMRhULKg==";
const String encryptSafeP = "RqvtdSUd2HdjbZOM981kqw==";
const String encryptAlclient = "PrFrU1bBBj3qR3zCimnTyQ==";
const String encryptAlname = "CtELlQClUWF3UOA7ET56Ag==";

/// 加密文字
String strEncrypt(String str) {
  return EncryptUtils.aesEncrypt(str);
}

/// 解密文字
String strDecrypt(String str) {
  return EncryptUtils.aesDecrypt(str);
}

/// 文字
String strWxname() {
  return strDecrypt(encryptWxname);
}

String strAliname() {
  return strDecrypt(encryptAlname);
}
