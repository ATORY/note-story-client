import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:note_story_flutter/screens/detail_page.dart';
import 'package:note_story_flutter/screens/web_view.dart';

String allViewQuery = """
  query RllViewQuery(\$after: String, \$first: Int) {
    allViewer {
      stories(after: \$after, first: \$first) {
        edges {
          node {
            id
          }
        }
        pageInfo {
          hasNextPage
        }
      }
    }
  }
""";

class AllTab extends StatefulWidget {
  @override
  QueryFetchMoreState createState() {
    return new QueryFetchMoreState();
  }
}

class QueryFetchMoreState extends State<AllTab> {
  bool _init = false;
  bool _loading = true;
  List _edges = [];
  List<GraphQLError> _errors;
  bool _hasMore = false;

  GraphQLClient _client;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = GraphQLProvider.of(context).value;
    _initialQuery();
  }

  void _initialQuery() async {
    if (_init == false) {
      _init = true;
      final QueryResult result = await _client.query(QueryOptions(
        document: allViewQuery,
        variables: {
          'after': '',
          'first': 10
        }
      ));
      if (result.errors != null) {
        setState(() {
          _errors = result.errors;
        });
      } else {
        setState(() {
          _loading = false;
          _edges = result.data['allViewer']['stories']['edges'];
          _hasMore = result.data['allViewer']['stories']['pageInfo']['hasNextPage'];
        });
      }
      
    }
  }

  void _fetchMore(
    Map<String, dynamic> variables,
  ) async {
    setState(() {
      _loading = true;
    });

    final QueryOptions nextOptions = QueryOptions(
      document: allViewQuery,
      variables: variables
    );
    final QueryResult result = await _client.query(nextOptions);

    if (result.errors != null) {
      setState(() {
        _errors = result.errors;
      });
    } else {
      List newEdges = [..._edges, ...result.data['allViewer']['stories']['edges']];
      setState(() {
        _loading = false;
        _edges = newEdges;
        _hasMore = result.data['allViewer']['stories']['pageInfo']['hasNextPage'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_errors != null) {
      return Text(_errors.toString());
    }

    if (_loading) {
      return Text('Loading');
    }

    return new Container(
      child: ListView.builder(
        itemCount: _edges.length + 1,
        itemBuilder: (context, index) {
          return (index == _edges.length ) ?
            Container(
              color: Colors.greenAccent,
              child: FlatButton(
                child: _hasMore ? Text("Load More") : Text("没有了。。"),
                onPressed: _hasMore ? () {
                  _fetchMore({ 'after': _edges[index - 1]['node']['id']});
                } : () {},
              ),
            ) : ListTile(
              title: Text(_edges[index]['node']['id']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(id: _edges[index]['node']['id'])
                    // builder: (context) => WebViewContainer('http://bing.com')
                  ),
                );
              },
            );
        }
      ),
    );
  }
}
