import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:note_story_flutter/models/story.dart';
import 'package:note_story_flutter/screens/detail_page.dart';
import 'package:note_story_flutter/tabs/story_card.dart';

String allViewQuery = """
  query RllViewQuery(\$after: String, \$first: Int) {
    allViewer {
      stories(after: \$after, first: \$first) {
        edges {
          node {
            id
            title
            intro
            tags
            publishTime
            clientURL
            publisher {
              id
              email
              nickname
              avator
              banner
            }
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
  List<Story> _edges = [];
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
        List edges = result.data['allViewer']['stories']['edges'];
        setState(() {
          _loading = false;
          _edges = edges.map((item) => Story.fromJson(item['node'])).toList();
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
      List newEdges = result.data['allViewer']['stories']['edges'];
      List<Story> nextEdges = [
        ..._edges,
        ...newEdges.map((item) => Story.fromJson(item['node'])).toList()
      ];
      // List newEdges = [..._edges, ];
      setState(() {
        _loading = false;
        _edges = nextEdges;
        _hasMore = result.data['allViewer']['stories']['pageInfo']['hasNextPage'];
      });
    }
  }

  void _navToDetail(BuildContext context, Story story) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(story: story)
        // builder: (context) => WebViewContainer('http://bing.com')
      ),
    );
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
      child: Scrollbar(
        child: ListView.builder(
          itemCount: _edges.length + 1,
          itemBuilder: (context, index) {
            return (index == _edges.length ) ?
              Container(
                color: Colors.greenAccent,
                child: FlatButton(
                  child: _hasMore ? Text("Load More") : Text("没有了。。"),
                  onPressed: _hasMore ? () {
                    _fetchMore({ 'after': _edges[index - 1].id});
                  } : () {},
                ),
              ) : StoryCard(story: _edges[index], tapFun: () {
                _navToDetail(context, _edges[index]);
              });
          },
          // separatorBuilder: (context, index) {
          //   return Divider();
          // },
        ),
      )
    );
  }
}
