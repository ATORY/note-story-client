import 'package:flutter/material.dart';

class Publish extends StatelessWidget {
  static const Tab tab = Tab(text: "发布");
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
          child: Text("publish"),
        ),
      ),
    );
  }
}