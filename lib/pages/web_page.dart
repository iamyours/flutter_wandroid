import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/my_colors.dart';

class WebPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebPageState();
  }
}

class _WebPageState extends State<WebPage> {
  @override
  Widget build(BuildContext context) {
    var link = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.bgDark,
        title: Text("Web"),
      ),
      body: WebView(
        initialUrl: link,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (url) {
          print("finished:$url");
        },
        onWebViewCreated: (web){
        },
      ),
    );
  }
}
