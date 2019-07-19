import 'package:flutter/material.dart';

class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: new Text("New Story"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.close),
            onPressed: () => {
              Navigator.of(context).pop()
            },
          ),
        ),
      ),
      body: new Container(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: new Center(
          child: Text("add"),
        ),
      ),
    );
  }
}