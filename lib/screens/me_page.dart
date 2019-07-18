import 'package:flutter/material.dart';
import 'package:note_story_flutter/main.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:note_story_flutter/models/user.dart';

String loginQuery = """
  query loginQuery(\$input: UserInput) {
    token: userLogin(input: \$input)
  }
""";


class MePage extends StatefulWidget {
  static const BottomNavigationBarItem navItem = BottomNavigationBarItem(
    icon: Icon(Icons.person),
    title: Text('我的'),
  );

  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  var counter = 0;
  var token = "";
  var tokenKey = "token";
  var key = "counter";
  var status = "init";

  GraphQLClient _client;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = GraphQLProvider.of(context).value;
  }

  void _login() async {
    final QueryResult result = await _client.query(QueryOptions(
      document: loginQuery,
      variables: {
        'input': {
          "email": "d_ttang@163.com",
          "password": "654321"
        }
      }
    ));
    if (result.errors != null) {
      print('err');
    } else {
      print(result.data['token']);
      String token = result.data['token'] as String;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
    }
  }

  @override
  Widget build(BuildContext context) {
    Self loginUser = Self();
    if (loginUser.id == null) {
      return Scaffold(
        body: Container(
          color: themeColor,
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  '$counter',
                  textScaleFactor: 10.0,
                ),
                new RaisedButton(
                  onPressed: _login,
                  child: new Text('Login')
                ),
              ],
            )
          )
        )
      );
    }
    return Scaffold(
      // appBar: new AppBar(
      //   title: new Text("我的"),
      // ),
      body: Container(
        color: themeColor,
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                '$counter',
                textScaleFactor: 10.0,
              ),
              new Padding(padding: new EdgeInsets.all(10.0)),
              // new RaisedButton(
              //     onPressed: _onIncrementHit,
              //     child: new Text('Increment Counter')),
              // new Padding(padding: new EdgeInsets.all(10.0)),
              // new RaisedButton(
              //     onPressed: _onDecrementHit,
              //     child: new Text('Decrement Counter')),
            ],
          ),
        ),
      ),
    );
  }
}

// class MePage extends StatelessWidget {
//   static const BottomNavigationBarItem navItem = BottomNavigationBarItem(
//     icon: Icon(Icons.person),
//     title: Text('我的'),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: new AppBar(
//       //   title: new Text("我的"),
//       // ),
//       body: Container(
//         color: themeColor,
//         child: new Center(
//           child: new Text("Account Screen"),
//         )
//       ),
//     );
//   }
// }
