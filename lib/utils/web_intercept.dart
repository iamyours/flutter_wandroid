import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:iwebview_flutter/webview_flutter.dart';
import 'dart:convert' show utf8;

class WebIntercept {
  static const String wan = "wanandroid.com";
  static const String jianShu = "https://www.jianshu.com";
  static const String jueJin = "https://juejin.im/post/";
  static const String weiXin = "https://mp.weixin.qq.com/s";
  static const String csdn = "https://blog.csdn.net";
  static const List<String> wanCssFiles = [
    "blog/default.css",
    "pc/common.css",
    "pc/header.css",
    "wenda/wenda_md.css",
    "m/common.css"
  ];

  static Future<Response> intercept(String url, String link) async {
    if (link.contains(wan)) {
      //玩Android
      for (var i = 0; i < wanCssFiles.length; i++) {
        var name = wanCssFiles[i];
        if (url.contains(name)) {
          return loadCss("wanandroid/$name");
        }
      }
    }
    if (link.startsWith(jueJin)) {
      //掘金
      if (url.startsWith("https://b-gold-cdn.xitu.io/v3/static/css/0") && url.endsWith(".css")) {
        ByteData data = await rootBundle.load("assets/css/juejin/juejin.css");
        Uint8List bytes = Uint8List.view(data.buffer);
        return Response("text/css", "utf-8", bytes);
      }
    }
    if (link.startsWith(jianShu)) {
      if (url == link) {
        return wget(url);
      }
    }
    if (link.startsWith(csdn)) {
      //csdn
      if (url.startsWith("https://csdnimg.cn/release/phoenix/production/mobile_detail_style") && url.endsWith(".css")) {
        return loadCss("csdn/mobile_detail.css");
      }
      if (url.startsWith("https://csdnimg.cn/release/phoenix/production/wapedit_views_md")) {
        return loadCss("csdn/md.css");
      }
      if (url.startsWith("https://csdnimg.cn/release/phoenix/template") &&
          url.endsWith(".css") &&
          url.contains("wap_detail_view")) {
        return loadCss("csdn/wap_detail_view.css");
      }
    }
    return null;
  }

  static Future<Response> loadCss(String path) async {
    ByteData data = await rootBundle.load("assets/css/$path");
    Uint8List bytes = Uint8List.view(data.buffer);
    return Response("text/css", "utf-8", bytes);
  }

  static RegExp jianShuReg = RegExp(r"(<style data-vue-ssr-id=.*>)([^<]*?)(</style>)");
  static RegExp bodyReg = RegExp(r"<body class=(.*?)>");
  static String jianShuNightBody = "<body class=\"reader-night-mode normal-size\">";

  static Future<Response> wget(String url) async {
    dio.Dio d = dio.Dio();
    d.options.headers["user-agent"] =
        "Mozilla/5.0 (Linux; Android 8.0; Pixel 2 Build/OPD3.170816.012) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3887.7 Mobile Safari/537.36";
//    d.interceptors.add(dio.LogInterceptor(responseBody: true));
    dio.Response<String> res = await d.get(url);
    if (res.statusCode == 200) {
      String data = res.data;
      String jianShuCss = await rootBundle.loadString("assets/css/jianshu/jianshu.css");
      data = data.replaceFirst(jianShuReg, "<style>$jianShuCss</style>");
      data = data.replaceFirst(bodyReg, jianShuNightBody);
      try {
        Uint8List bytes = Uint8List.fromList(utf8.encode(data));
        return Response("text/html", null, bytes);
      } catch (e) {
        print("eeeeeeeeee");
        print(e);
      }
    }
    return null;
  }
}
