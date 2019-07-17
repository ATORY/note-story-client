import 'package:flutter/material.dart';
import 'package:note_story_flutter/main.dart';

class MePage extends StatelessWidget {
  static const BottomNavigationBarItem navItem = BottomNavigationBarItem(
    icon: Icon(Icons.person),
    title: Text('我的'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: new AppBar(
      //   title: new Text("我的"),
      // ),
      body: Container(
        color: themeColor,
        child: new Center(
          child: new Text("Account Screen"),
        )
      ),
    );
  }
}
