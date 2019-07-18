import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:note_story_flutter/models/story.dart';
import 'package:note_story_flutter/screens/detail_page.dart';
import 'package:note_story_flutter/tabs/story_card.dart';

String homeViewQuery = """
  query HomeViewerQuery(\$after: String, \$first: Int) {
    homeViewer {
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

class RecommandTab extends StatefulWidget {
  @override
  RecommandTabState createState() {
    return RecommandTabState();
  }
}

class RecommandTabState extends State<RecommandTab> {

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
        // bool hasNextPage = result.data['homeViewer']['stories']['pageInfo']['hasNextPage'];
        List<Story> _edges = edges.map((item) => Story.fromJson(item['node'])).toList();
        // print(edges);
        // print(hasNextPage);
        // return Text("data");
        return new Container(
          child: Scrollbar(
            child: ListView.builder(
              itemCount: _edges.length,
              itemBuilder: (context, index) {
                return StoryCard(story: _edges[index], tapFun: () {
                  _navToDetail(context, _edges[index]);
                });
              }
            ),
          )
        );
      },
    );
  }
}
