import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


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

typedef void FetchMoreCallback(
  Map<String, dynamic> variables,
  MergeResults mergeResults,
);

typedef Map<String, dynamic> MergeResults(
  dynamic prev,
  dynamic moreResults,
);

typedef Widget FetchMoreBuilder(
  QueryResult result,
  FetchMoreCallback fetchMore,
);

class AllTab extends StatefulWidget {
  @override
  QueryFetchMoreState createState() {
    return new QueryFetchMoreState();
  }
}

class QueryFetchMoreState extends State<AllTab> {
  bool _init = false;
  GraphQLClient _client;
  QueryResult _currentResult = QueryResult(loading: true);

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
      print(result);
      setState(() {
        _currentResult = result;
      });
    }
  }

  void _fetchMore(
    Map<String, dynamic> variables,
  ) async {
    setState(() {
      _currentResult = QueryResult(data: _currentResult.data, loading: true);
    });

    final QueryOptions nextOptions = QueryOptions(
      document: allViewQuery,
      variables: variables
    );
    final QueryResult result = await _client.query(nextOptions);

    if (result.errors != null) {
      setState(() {
        _currentResult = QueryResult(data: _currentResult.data, errors: result.errors);
      });
      return;
    }

    // final QueryResult mergedResult = QueryResult(
    //   data: mergeResults(_currentResult.data, result.data),
    // );

    // setState(() {
    //   _currentResult = mergedResult;
    // });
  }

  @override
  Widget build(BuildContext context) {
    print('build..');
    if (_currentResult.errors != null) {
      return Text(_currentResult.errors.toString());
    }

    if (_currentResult.loading) {
      return Text('Loading');
    }
    List edges = _currentResult.data['allViewer']['stories']['edges'];
    return new Container(
      child: ListView.builder(
        itemCount: edges.length,
        itemBuilder: (context, index) {
          final node = edges[index]['node'];

          return Text(node['id']);
        }
      ),
    );
  }
}
// class AllTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       backgroundColor: Colors.green,
//       body: new Container(
//         child: new Center(
//           child: new Column(
//             // center the children
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               new Icon(
//                 Icons.adb,
//                 size: 160.0,
//                 color: Colors.white,
//               ),
//               new Text(
//                 "Second Tab",
//                 style: new TextStyle(color: Colors.white),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
