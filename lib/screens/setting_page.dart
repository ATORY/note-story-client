import 'package:flutter/material.dart';
import 'package:note_story_flutter/models/user.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: new Text("设置"),
      ),
      body: new Container(
        // Sets the padding in the main container
        padding: const EdgeInsets.only(bottom: 2.0),
        child: new Center(
          child: Text("Setting"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("logout"),
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("token", "");
          Self().destroy();
          Navigator.of(context).pop();
        },
      ),
    );
  }
}