import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:note_story_flutter/models/user.dart';

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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  GraphQLClient _client;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = GraphQLProvider.of(context).value;
  }

  void _login(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final QueryResult result = await _client.query(QueryOptions(
      document: loginQuery,
      variables: {
        "input": {
          "email": email,
          "password": password
        }
      }
    ));
    if (result.errors != null) {
      print('login err');
    } else {
      // print(result.data['token']);
      String token = result.data['token'] as String;
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
      print('err userinfo');
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      Map userInfo = result.data['userInfo'];
      Self().rebuild(
        token,
        userInfo['id'] as String,
        userInfo['email'] as String,
        userInfo['nickname'] as String,
        userInfo['avator'] as String,
        userInfo['banner'] as String,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: new Text("登录"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.close),
            onPressed: () => {
              Navigator.of(context).pop()
            },
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Builder(
          builder: (context) => Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'email'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'password'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'password';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      _login(context);
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      // if (_formKey.currentState.validate()) {
                      //   print(_emailController.text);
                      //   // If the form is valid, display a Snackbar.
                      //   // Scaffold.of(context)
                      //       // .showSnackBar(SnackBar(content: Text('Processing Data')));
                      // }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ]
            ),
          )
        )
      ),
    );
  }
}