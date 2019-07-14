import 'package:flutter/material.dart';


class MePage extends StatelessWidget {
  static const BottomNavigationBarItem navItem = BottomNavigationBarItem(
    icon: Icon(Icons.account_circle),
    title: Text('me'),
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Me"),
      ),
      body: new Container(
          child: new Center(
        child: new Text("Account Screen"),
      )),
    );
  }
}
