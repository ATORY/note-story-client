import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

String loginQuery = """
  query loginQuery(\$input: UserInput) {
    token: userLogin(input: \$input)
  }
""";

String userInfoQuery = """
  query userInfoQuery(\$token: String!) {
    userInfo(token: \$token) {
      id
      email
      nickname
      intro
      avator
      banner
    }
  }
""";

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

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
      _getUserInfo(token);
    }
  }

  void _getUserInfo(String token) async {
    final QueryResult result = await _client.query(QueryOptions(
      document: userInfoQuery,
      variables: {
        "token": token
      }
    ));
    if (result.errors != null) {
      print('err');
    } else {
      print(result.data['token']);
      String token = result.data['token'] as String;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      _getUserInfo(token);
    }
  }

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
          child: FloatingActionButton(
            child: Text('login'),
            onPressed: _login,
          ),
        ),
      ),
    );
  }
}