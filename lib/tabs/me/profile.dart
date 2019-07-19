import 'package:flutter/material.dart';
import 'package:note_story_flutter/models/user.dart';

class Profile extends StatelessWidget {
  static const Tab tab = Tab(text: "资料");

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: new AppBar(
      //   title: new Text("Stateless Widget"),
      // ),
      body: new Container(
        // Sets the padding in the main container
        padding: const EdgeInsets.only(bottom: 2.0),
        child: new Center(
          child: Column(
            children: <Widget>[
              Text(Self().email ?? ''),
              Text(Self().nickname ?? ''),
            ],
          ),
        ),
      ),
    );
  }
}