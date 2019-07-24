import 'package:flutter/material.dart';

class StoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text('故事'),
      ),
      body: Container(
        child: Text('list'),
      ),
    );
  }
}