
import 'package:fl_shared_link/define.dart';

void encrypt_eecrypt_str(String str, String name) {
  final String eStr = strEncrypt(str);
  final String str_new = strDecrypt(eStr);
  print('${name}=${str}: 加密后:${eStr}  解密后:${str_new}');
}

void startEncrypt() {
  encrypt_eecrypt_str('weixin', 'encryptWx');
  encrypt_eecrypt_str('微信', 'encryptWxname');
  encrypt_eecrypt_str('safepay', 'encryptSafep');
  encrypt_eecrypt_str('SafePay', 'encryptSafeP');
  encrypt_eecrypt_str('alipay', 'encryptAl');
  encrypt_eecrypt_str('alipayclient', 'encryptAlclient');
  encrypt_eecrypt_str('支付宝', 'encryptAlname');
  print('end');
}
