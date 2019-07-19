// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:note_story_flutter/screens/user_page.dart';
import 'package:note_story_flutter/models/story.dart';

class DetailScreen extends StatefulWidget {
  final Story story;
  DetailScreen({Key key, @required this.story}) : super(key: key);
  @override
  createState() => _WebViewContainerState(this.story);
}

class _WebViewContainerState extends State<DetailScreen> {
  Story _story;
  // final Completer<WebViewController> _controller = Completer<WebViewController>();
  final _key = UniqueKey();
  bool _isLoadingPage;
  _WebViewContainerState(this._story);

  @override
  void initState() {
    super.initState();
    _isLoadingPage = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(this._story.title),
        actions: <Widget>[
          IconButton(
            icon: ClipOval(
              // borderRadius: new BorderRadius.circular(20),
              child: Image.network(
                this._story.publisher.avator,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
              ),
            ),
            tooltip: 'Show Snackbar',
            padding: EdgeInsets.only(right: 10),
            // disabledColor: null,
            splashColor: Colors.transparent,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserPage(user: this._story.publisher)
                  // builder: (context) => WebViewContainer('http://bing.com')
                ),
              );
            },
          ),
          // Container(
          //   width: 20,
          //   child: CircleAvatar(
          //     radius: 10.0,
          //     backgroundImage: NetworkImage(
          //       'https://wesy.club/image_s/ODhiMGZmMmYtZjY1MS00Yjk5LWI1NTItNmUzYTJkNmNlYTg1Cg==/dd27667e90a28ab4149e5aa24f6ec979.jpeg'
          //     ),
          //   ),
          // )
        ],
      ),
      body:  Scrollbar(
        child: Stack(
          children: <Widget>[
            WebView(
              key: _key,
              initialUrl: this._story.clientURL,
              javascriptMode: JavascriptMode.unrestricted,
              // onWebViewCreated: (webViewCreate) {
              //   _controller.complete(webViewCreate);
              // },
              onPageFinished: (finish) {
                setState(() {
                  _isLoadingPage = false;
                });
              },
            ),
            _isLoadingPage ? Container(
              alignment: FractionalOffset.center,
              child: CircularProgressIndicator(),
            ) : Container(
              height: 0,
              color: Colors.transparent,
            ),
          ],
        ),
      )
      // body: Column(
      //   children: [
      //     Expanded(
      //       child: WebView(
      //         key: _key,
      //         debuggingEnabled: true,
      //         javascriptMode: JavascriptMode.unrestricted,
      //         initialUrl: 'http://localhost:5000/story/client/' + this._story.id,
      //         onWebViewCreated: (WebViewController webViewController) {
      //           _controller.complete(webViewController);
      //         },
      //         onPageFinished: (finish) {
      //           setState(() {
      //             _isLoadingPage = false;
      //           });
      //         },
      //       )
      //     )
      //   ],
      // )
    );
  }
}
