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

final String GRAPHQL_ENDPOINT = 'http://$host:3030/graphql';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClientProvider(
      uri: GRAPHQL_ENDPOINT,
      child: MaterialApp(
        // title: 'NoteStory',
        theme: ThemeData(primarySwatch: Colors.blue),
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
        selectedItemColor: Colors.amber[800],
        onTap: _navigateTo,
      ),
    );
  }

}


// class Home extends StatefulWidget {
//   @override
//   HomeState createState() => new HomeState();
// }

// class HomeState extends State<Home> with SingleTickerProviderStateMixin {
//  TabController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = new TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text("Using Bottom Navigation Bar"),
//         backgroundColor: Colors.blue,
//       ),

//       body: new TabBarView(
//         children: <Widget>[new FirstTab(), new SecondTab()],
//         controller: controller,
//       ),

//       bottomNavigationBar: new Material(
//         color: Colors.blue,
//         child: new TabBar(
//           tabs: <Tab>[
//             new Tab(icon: new Icon(Icons.favorite)),
//             new Tab(icon: new Icon(Icons.adb))
//           ],
//           controller: controller,
//         ),
//       ),
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ClientProvider(
//       uri: GRAPHQL_ENDPOINT,
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: new DrawerScreen(),
//         routes: <String, WidgetBuilder> {
//           SettingsScreen.routeName: (BuildContext context) => new SettingsScreen(),
//           AccountScreen.routeName: (BuildContext context) => new AccountScreen()
//         },
//       ),
//     );
//   }
// }
