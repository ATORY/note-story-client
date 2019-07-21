import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:note_story_flutter/models/story.dart';
import 'package:note_story_flutter/screens/detail_page.dart';
import 'package:note_story_flutter/tabs/story_card.dart';

import 'package:note_story_flutter/utils/graphqls.dart';

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
    if (!_hasMore) return;
    if (_loading) return;
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (_errors != null) {
      return Text(_errors.toString());
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _fetchMore({ 'after': _edges[_edges.length - 1].id});
        }
        return;
      },
      child: Scrollbar(
        child: ListView.builder(
          itemCount: _edges.length + 2,
          itemBuilder: (context, index) {
            if (index == _edges.length) {
              return Container(
                // color: Colors.greenAccent,
                child: Container(
                  alignment: FractionalOffset.center,
                  child: !_hasMore ?
                    Text("没有了。。", style: TextStyle(color: Colors.grey, ),) :
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).backgroundColor),
                    ),
                ),
              );
            }
            if (index == _edges.length + 1) {
              return Container(
                height: 30,
              );
            }
            return StoryCard(story: _edges[index], tapFun: () {
              _navToDetail(context, _edges[index]);
            });
          },
          // separatorBuilder: (context, index) {
          //   return Divider();
          // },
        ),
      ),
    );
    
  }
}
