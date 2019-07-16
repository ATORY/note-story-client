// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  DetailScreen({Key key, @required this.id}) : super(key: key);
  @override
  createState() => _WebViewContainerState(this.id);
}

class _WebViewContainerState extends State<DetailScreen> {
  var _id;
  // final Completer<WebViewController> _controller =
  //     Completer<WebViewController>();
  final _key = UniqueKey();
  _WebViewContainerState(this._id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this._id),
        ),
        body: Column(
          children: [
            Expanded(
              child: WebView(
                key: _key,
                debuggingEnabled: true,
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: 'http://localhost:5000/story/client/' + this._id,
                // onWebViewCreated: (WebViewController webViewController) {
                //   _controller.complete(webViewController);
                // },
              )
            )
          ],
        ));
  }
}
