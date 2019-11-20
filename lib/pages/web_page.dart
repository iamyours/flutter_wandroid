import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/my_colors.dart';

class WebPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebPageState();
  }
}

class _WebPageState extends State<WebPage> {
  Future<Response> _interceptRequest(String url) async {
    if (url.startsWith("https://b-gold-cdn.xitu.io/v3/static/css/0") && url.endsWith(".css")) {
      try {
        ByteData data = await rootBundle.load("assets/css/juejin/juejin.css");
        Uint8List bytes = Uint8List.view(data.buffer);
        return Response("text/css", "utf-8", bytes);
      }catch(e){
        print("=========e:$e");
      }
    }
    return null;
  }

  Future<Response> loadResource(String path) async {
    ByteData data = await rootBundle.load(path);
    Uint8List bytes = Uint8List.view(data.buffer);
    return Response("text/css", "utf-8", bytes);
  }

  @override
  Widget build(BuildContext context) {
    var link = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.readColor,
        title: Text("Web"),
      ),
      body: Container(
        child: WebView(
          initialUrl: link,
          backgroundColor: MyColors.bgDark,
          javascriptMode: JavascriptMode.unrestricted,
          debuggingEnabled: true,
          onPageFinished: (url) {
            print("finished:$url");
          },
          onProgressChanged: (int progress) {
            print("progress:$progress%");
          },
          shouldInterceptRequest: _interceptRequest,
          onWebViewCreated: (web) {},
        ),
      )
    );
  }
}
