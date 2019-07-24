import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:notus/convert.dart';
import 'package:zefyr/zefyr.dart';

import 'package:note_story_flutter/models/story.dart';
import 'package:note_story_flutter/screens/stories_page.dart';

final initDeltaStr = r'[{"insert":""},{"insert":"\n","attributes":{"heading":1}}]';

Delta getDelta(String doc) {
  return Delta.fromJson(json.decode(doc) as List);
}

class AddPage extends StatefulWidget {

  final int storyId;
  AddPage({Key key, this.storyId}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  ZefyrController _controller;
  final FocusNode _focusNode = new FocusNode();

  int _storyId;
  bool _editing = true;
  StreamSubscription<NotusChange> _sub;

  @override
  void initState() {
    super.initState();
    _storyId = widget.storyId;
    _controller = ZefyrController(NotusDocument.fromDelta(getDelta(initDeltaStr)));
    _sub = _controller.document.changes.listen((change) {
      // print('--- ${change.source}: ${change.change} ---');
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
        // brightness: Brightness.light,
        title: _storyId == null ? Text('新建') : Text('编辑'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.close),
            onPressed: () => {
              Navigator.of(context).pop()
            },
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoriesPage()
                ),
              );
              // print(result);
              if (result != null) {
                LocalStory story = await LocalStory.getOne(result);
                String deltaStr = story.content == null ? initDeltaStr : story.content;
                setState(() {
                  _editing = true;
                  _storyId = result;
                  _controller = ZefyrController(NotusDocument.fromDelta(getDelta(deltaStr)));
                });
              } else {
                setState(() {
                  _editing = true;
                  _storyId = null;
                  _controller = ZefyrController(NotusDocument.fromDelta(getDelta(initDeltaStr)));
                });
              }
            },
          )
        ],
      ),
      body:  ZefyrScaffold(
        child: ZefyrTheme(
          data: theme,
          child: ZefyrEditor(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            controller: _controller,
            focusNode: _focusNode,
            enabled: _editing,
            imageDelegate: new CustomImageDelegate(),
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

  void _startEditing() async {
    if (_editing) {
      print('save content');
      Delta delta = _controller.document.toDelta();
      List deltaList = delta.toJson();
      String mdStr = notusMarkdown.encode(_controller.document.toDelta());
      String deltaJsonStr = json.encode(deltaList);
      // print(deltaJsonStr);

      String title = '';
      if (deltaList[0].attributes == null) {
        title = deltaList[0].value;
      } else {
        title = 'no title';
      }

      String intro = mdStr.substring(0, mdStr.length > 200 ? 200 : mdStr.length);
      if (_storyId != null) {
        LocalStory(
          id: _storyId,
          title: title,
          intro: intro,
          content: deltaJsonStr,
        ).update();
      } else {
        int storyId = await LocalStory(
          title: title,
          intro: intro,
          content: deltaJsonStr,
        ).save();
        setState(() {
          _storyId = storyId;
        });
      }
      
      // Delta _delta = Delta.fromJson(json.decode(deltaJsonStr));
      // print(_delta);
      // print(notusMarkdown.decode(mdStr));
    }
    setState(() {
      _editing = !_editing;
    });
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
