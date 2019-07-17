import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_story_flutter/screens/me_page.dart';
import 'package:note_story_flutter/screens/club_page.dart';

import './client_provider.dart';

String get host {
  if (Platform.isAndroid) {
    return '10.0.2.2';
  } 
  return 'localhost';
}

// final String GRAPHQL_ENDPOINT = 'http://$host:3030/graphql';
final String GRAPHQL_ENDPOINT = 'https://wesy.club/graphql';
const Color themeColor = Color.fromRGBO(68, 186, 189, 1);

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClientProvider(
      uri: GRAPHQL_ENDPOINT,
      child: MaterialApp(
        // title: 'NoteStory',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          iconTheme: const IconThemeData(color: themeColor),
          backgroundColor: themeColor
        ),
        home: HomePage(title: "NoteStory"),
      ),
    );
  }
}


class HomePage extends StatefulWidget {
  HomePage({ Key key, this.title }): super(key: key);
  final String title;

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectIndex = 0;
  
  void _navigateTo(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectIndex == 1 ? MePage() : ClubPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          ClubPage.navItem,
          MePage.navItem
        ],
        currentIndex: _selectIndex,
        // backgroundColor: Color.fromRGBO(68, 186, 189, 1),
        selectedItemColor: themeColor,
        onTap: _navigateTo,
      ),
    );
  }
}
