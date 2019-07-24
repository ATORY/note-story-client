import 'dart:async';
import 'dart:convert';
// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:note_story_flutter/screens/stories_page.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:notus/convert.dart';
import 'package:zefyr/zefyr.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final ZefyrController _controller = ZefyrController(new NotusDocument());
  final FocusNode _focusNode = new FocusNode();
  bool _editing = true;
  StreamSubscription<NotusChange> _sub;

  @override
  void initState() {
    super.initState();
    _sub = _controller.document.changes.listen((change) {
      print('${change.source}: ${change.change}');
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = new ZefyrThemeData(
      cursorColor: Colors.blue,
      toolbarTheme: ZefyrToolbarTheme.fallback(context).copyWith(
        color: Colors.grey.shade800,
        toggleColor: Colors.grey.shade900,
        iconColor: Colors.white,
        disabledIconColor: Colors.grey.shade500,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).backgroundColor,
        brightness: Brightness.light,
        title: Text('NewStory'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoriesPage()
                ),
              );
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: ZefyrScaffold(
          child: ZefyrTheme(
            data: theme,
            child: ZefyrEditor(
              controller: _controller,
              focusNode: _focusNode,
              enabled: _editing,
              imageDelegate: new CustomImageDelegate(),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).backgroundColor,
          heroTag: null,
          child: _editing ? Icon(Icons.done) : Icon(Icons.edit),
          onPressed: _startEditing,
        ),
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _editing = !_editing;
    });
    if (!_editing) {
      print('save contetn');
      Delta delta = _controller.document.toDelta();
      List deltaList = delta.toJson();
      // String mdStr = notusMarkdown.encode(_controller.document.toDelta());
      String deltaJsonStr = json.encode(deltaList);
      print(deltaJsonStr);

      Delta _delta = Delta.fromJson(json.decode(deltaJsonStr));
      print(_delta);
      // print(notusMarkdown.decode(mdStr));
    }
  }
}

/// Custom image delegate used by this example to load image from application
/// assets.
///
/// Default image delegate only supports [FileImage]s.
class CustomImageDelegate extends ZefyrDefaultImageDelegate {
  @override
  Widget buildImage(BuildContext context, String imageSource) {
    // We use custom "asset" scheme to distinguish asset images from other files.
    if (imageSource.startsWith('asset://')) {
      final asset = new AssetImage(imageSource.replaceFirst('asset://', ''));
      return new Image(image: asset);
    } else {
      return super.buildImage(context, imageSource);
    }
  }
}
