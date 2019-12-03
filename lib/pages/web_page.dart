import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iwebview_flutter/webview_flutter.dart';
import '../utils/my_colors.dart';
import '../utils/web_intercept.dart';

class WebPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebPageState();
  }
}

class _WebPageState extends State<WebPage> {
  Future<Response> _interceptRequest(String url) async {
    return WebIntercept.intercept(url, link);
  }

  Future<Response> loadResource(String path) async {
    ByteData data = await rootBundle.load(path);
    Uint8List bytes = Uint8List.view(data.buffer);
    return Response("text/css", "utf-8", bytes);
  }

  String title = "";
  int offsetY = 0;
  WebViewController _controller;
  double progress = 0.0;
  String link;

  @override
  Widget build(BuildContext context) {
    link = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.bgDark,
          title: Text(
            offsetY > 20 ? title : "",
            style: const TextStyle(color: MyColors.titleColor),
          ),
        ),
        body: Container(
            child: Stack(
          children: <Widget>[
            WebView(
              initialUrl: link,
              backgroundColor: MyColors.bgDark,
              javascriptMode: JavascriptMode.unrestricted,
              debuggingEnabled: true,
              onPageFinished: (url) async {
                String _title = await _controller.getTitle();
                setState(() {
                  title = _title;
                });
              },
              onScroll: (int x, int y) {
                setState(() {
                  offsetY = y;
                });
              },
              onProgressChanged: (int p) {
                setState(() {
                  progress = p / 100.0;
                });
              },
              shouldInterceptRequest: _interceptRequest,
              onWebViewCreated: (controller) {
                _controller = controller;
              },
            ),
            Offstage(
                offstage: progress == 1,
                child: SizedBox(
                  height: 1,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: MyColors.bgDark,
                    valueColor: const AlwaysStoppedAnimation(MyColors.tabSelected),
                  ),
                ))
          ],
        )));
  }
}
