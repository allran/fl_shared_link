import './crypto.dart';

const String encryptWx = "jE+mv74cky9+SjEgi1CB1A==";
const String encryptWxname = "HpRhI2jTky9+SjEgi1CB1A==";
const String encryptSafep = "iEupoqcT4Cx9STIjiFOC1w==";

const String encryptAl = "mkamt7YLky9+SjEgi1CB1A==";
const String encryptSafeP = "qEupoocT4Cx9STIjiFOC1w==";
const String encryptAlclient = "mkamt7YL+kkdJVVehV6P2g==";
const String encryptAlname = "Hb5gI2zqfIvpRzwthl2M2Q==";

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
