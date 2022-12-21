import 'dart:convert';
import 'package:fl_shared_link/fl_shared_link.dart';
import 'package:flutter/cupertino.dart';
import './define.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class URLPay {
  static final URLPay _singletonPattern = URLPay._internal();

  ///工厂构造函数
  factory URLPay() {
    return _singletonPattern;
  }

  ///构造函数私有化，防止被误创建
  URLPay._internal();
  // 参数
  bool needHandOpenurlMethod = false; //当前是否监听链接
  String wxKey = '';

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  ///监听状态回调
  void handleCompletedPayUrl(Function(int errCode, String msg)? callBack) async {
    FlSharedLink().receiveHandler(onUniversalLink: (IOSUniversalLinkModel? data) {
      /// 监听通过 universalLink 打开app 回调以及参数
    }, onOpenUrl: (IOSOpenUrlModel? data) {
      /// 监听通过 openUrl或者handleOpenUrl 打开app 回调以及参数
      String url = data?.url ?? "";
      String action = data?.action ?? "";
      debugPrint(url);
      if (action == "applicationWillEnterForeground") {
        if (needHandOpenurlMethod) {
          needHandOpenurlMethod = false;
          callBack?.call(-1, "支付状态未知");
        }
      }
      if (wxKey.isNotEmpty && url.startsWith("$wxKey://pay")) {
        var retArray = url.split('&');
        var errCode = -1;
        for (var s in retArray) {
          if (s.contains("ret=")) {
            errCode = int.parse(s.replaceAll("ret=", ""));
          }
        }
        var errStr = "普通错误";
        if (errCode == 0) {
          errStr = "成功";
        } else if (errCode == -2) {
          errStr = "用户取消";
        } else if (errCode == -3) {
          errStr = "发送失败";
        } else if (errCode == -4) {
          errStr = "授权失败";
        } else if (errCode == -5) {
          errStr = "不支持";
        }
        needHandOpenurlMethod = false;
        callBack?.call(errCode, errStr);
      } else if (url.startsWith("//${strDecrypt(encryptSafeP)}/")) {
        var retArray = url.split('?');
        var resultStr = retArray[1].replaceAll("ResultStatus", "resultStatus");
        var result = jsonDecode(resultStr);
        var resultDict = result["memo"];
        needHandOpenurlMethod = false;
        callBack?.call(resultDict["errCode"], resultDict["errStr"]);
      }
    });
  }

  Future<bool> isAppInstalled(String str) async {
    var url = Uri.dataFromString(str);
    var s = await canLaunchUrl(url);
    return s;
  }

  /// 是否安装wx
  Future<bool> isWxAppInstalled() async {
    String app = strDecrypt(encryptWx);
    return canLaunchUrl(Uri(scheme: app));
  }

  /// 是否安装ali
  Future<bool> isAliAppInstalled() async {
    String app = strDecrypt(encryptAl);
    return canLaunchUrl(Uri(scheme: app));
  }

  /// 开始wx支付
  Future<bool> wPay({
    required String appId,
    required String partnerId,
    required String prepayId,
    required String package,
    required String nonceStr,
    required int timeStamp,
    required String sign,
    String? signType,
  }) async {
    if (appId.isEmpty ||
        partnerId.isEmpty ||
        prepayId.isEmpty ||
        package.isEmpty ||
        nonceStr.isEmpty ||
        sign.isEmpty ||
        timeStamp == 0) {
      debugPrint("缺少pReq参数");
      return false;
    }
    if (!await isWxAppInstalled()) {
      debugPrint("未安装对应App");
      return false;
    }

    needHandOpenurlMethod = true;
    wxKey = appId;
    var packageStr = package.replaceAll("=", "%3D");
    var signTypeStr = signType ?? "SHA1";
    String wx = strDecrypt(encryptWx);
    var parameter =
        "nonceStr=$nonceStr&package=$packageStr&partnerId=$partnerId&prepayId=$prepayId&timeStamp=$timeStamp&sign=$sign&signType=$signTypeStr";
    var url = '$wx://app/$appId/pay/?$parameter';
    debugPrint(url);
    return launchUrlString(url);
  }

  /// 开始ali支付
  Future<bool> aPay(String orderStr, String schemeStr) async {
    if (orderStr.isEmpty) {
      debugPrint("缺少orderStr参数");
      return false;
    }
    if (schemeStr.isEmpty) {
      debugPrint("缺少schemeStr参数");
      return false;
    }

    if (!await isAliAppInstalled()) {
      debugPrint("未安装对应App");
      return false;
    }

    needHandOpenurlMethod = true;
    String safeP = strDecrypt(encryptSafeP);
    var dict = {"fromAppUrlScheme": schemeStr, "requestType": safeP, "dataString": orderStr};
    var dictStr = dict.toString();
    var parameter = Uri.encodeComponent(dictStr);
    String al = strDecrypt(encryptAl);
    String alClient = strDecrypt(encryptAlclient);
    final Uri emailLaunchUri = Uri(scheme: al, path: alClient, query: parameter);
    return launchUrl(emailLaunchUri);
  }
}
