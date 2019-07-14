import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


String homeViewQuery = """
  query ReadRepositories(\$after: String, \$first: Int) {
    homeViewer {
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

class RecommandTab extends StatefulWidget {
  @override
  RecommandTabState createState() {
    return RecommandTabState();
  }
}

class RecommandTabState extends State<RecommandTab> {
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: homeViewQuery,
        variables: {
          'after': '',
          'first': 10
        }
      ),
      builder: (QueryResult result, { VoidCallback refetch }) {
        if (result.errors != null) {
          return Text(result.errors.toString());
        }

        if (result.loading) {
          return Text('Loading');
        }

        // it can be either Map or List
        List edges = result.data['homeViewer']['stories']['edges'];
        bool hasNextPage = result.data['homeViewer']['stories']['pageInfo']['hasNextPage'];
        // print(edges);
        // print(hasNextPage);
        // return Text("data");
        return ListView.builder(
          itemCount: edges.length,
          itemBuilder: (context, index) {
            final node = edges[index]['node'];

            return Text(node['id']);
        });
      },
    );
  }

  // Widget build(BuildContext context) {
  //   return new Scaffold(
  //     backgroundColor: Colors.green,
  //     body: new Container(
  //       child: new Center(
  //         child: new Column(
  //           // center the children
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             new Icon(
  //               Icons.adb,
  //               size: 160.0,
  //               color: Colors.white,
  //             ),
  //             new Text(
  //               "Second Tab",
  //               style: new TextStyle(color: Colors.white),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
