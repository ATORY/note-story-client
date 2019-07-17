import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:note_story_flutter/models/story.dart';

class DetailScreen extends StatefulWidget {
  final Story story;
  DetailScreen({Key key, @required this.story}) : super(key: key);
  @override
  createState() => _WebViewContainerState(this.story);
}

class _WebViewContainerState extends State<DetailScreen> {
  Story _story;
  // final Completer<WebViewController> _controller =
  //     Completer<WebViewController>();
  final _key = UniqueKey();
  _WebViewContainerState(this._story);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this._story.title),
        ),
        body: Column(
          children: [
            Expanded(
              child: WebView(
                key: _key,
                debuggingEnabled: true,
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: 'http://localhost:5000/story/client/' + this._story.id,
                // onWebViewCreated: (WebViewController webViewController) {
                //   _controller.complete(webViewController);
                // },
              )
            )
          ],
        ));
  }
}
