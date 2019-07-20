import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter/material.dart';
import 'package:note_story_flutter/client_provider.dart';
import 'package:note_story_flutter/models/user.dart';
import 'package:note_story_flutter/screens/add_page.dart';
import 'package:note_story_flutter/screens/me_page.dart';
import 'package:note_story_flutter/screens/club_page.dart';

import 'package:note_story_flutter/utils/graphqls.dart';

import './client_provider.dart';

String get host {
  if (Platform.isAndroid) {
    return '10.0.2.2';
  } 
  return 'localhost';
}

// final GRAPHQL_ENDPOINT = 'http://$host:3030/graphql';
const GRAPHQL_ENDPOINT = 'https://wesy.club/graphql';
const Color themeColor = Color.fromRGBO(68, 186, 189, 1);

void initUser() async {
  GraphQLClient graphqlClient = GraphQLClient(
    cache: cache,
    link: HttpLink(uri: GRAPHQL_ENDPOINT) as Link
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  if (token == "") return;
  final QueryResult result = await graphqlClient.query(QueryOptions(
    document: userInfoQuery,
    variables: {
      'token': token,
    }
  ));
  if (result.errors != null) {
    print('err hanpend');
    return;
  }
  Map userInfo = result.data['userInfo'];
  Self(
    token: token,
    id: userInfo['id'] as String,
    email: userInfo['email'] as String,
    nickname: userInfo['nickname'] as String,
    avator: userInfo['avator'] as String,
    banner: userInfo['banner'] as String,
  );
}

void main() {
  initUser();
  return runApp(App());
}
// void main() => runApp(App());

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
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => AddPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                var begin = Offset(0.0, 1.0);
                var end = Offset.zero;
                var curve = Curves.ease;
                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              }
            )
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class AddPateRoute<T> extends MaterialPageRoute<T> {
  AddPateRoute({WidgetBuilder builder, RouteSettings settings}): super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}


// PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => Page2(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       return child;
//     },