import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebViewAward extends StatefulWidget {
  WebViewAward({Key key}) : super(key: key);

  @override
  _WebViewAwardState createState() => _WebViewAwardState();
}

class _WebViewAwardState extends State<WebViewAward> {
  
  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(data['title']),
      ),
      body: WebView(
        gestureNavigationEnabled: true,
        initialUrl: data['url'],
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}