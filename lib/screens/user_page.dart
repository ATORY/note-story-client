import 'package:flutter/material.dart';
import 'package:note_story_flutter/models/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:note_story_flutter/utils/graphqls.dart';
import 'package:note_story_flutter/models/story.dart';
import 'package:note_story_flutter/tabs/story_card.dart';
import 'package:note_story_flutter/screens/detail_page.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _UserPageState createState() => new _UserPageState();
}

const kExpandedHeight = 150.0;

class _UserPageState extends State<UserPage> {
  ScrollController _scrollController;
  GraphQLClient _client;
  double _offset = 0.0;

  bool _hasFollow = false;
  bool _hasMore = false;
  bool _loading = true;
  List<Story> _edges = [];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() => setState(() {
        _offset = _scrollController.offset;
      }));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = GraphQLProvider.of(context).value;
    _initialQuery();
  }

  void _initialQuery() async {
    final QueryResult result = await _client.query(QueryOptions(
      document: userProfileQuery,
      variables: {
        'openId': widget.user.id,
        'after': '',
        'first': 10
      }
    ));
    if (result.errors != null) {
      print('errr');
        // setState(() {
        //   _errors = result.errors;
        // });
    } else {
      // print(result.data);
      Map profile = result.data['userProfile']; 
      List edges = profile['stories']['edges'];
      bool hasFollow = profile['hasFollow'];
      setState(() {
        _loading = false;
        _hasFollow = hasFollow;
        _edges = edges.map((item) => Story.fromJson(item['node'])).toList();
        _hasMore = profile['stories']['pageInfo']['hasNextPage'];
      });
    }
  }

  bool get _showTitle {
    return _scrollController.hasClients && _offset > kExpandedHeight - kToolbarHeight;
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
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).backgroundColor,
            pinned: true,
            // leading: IconButton(icon: Icon(Icons.menu), onPressed: () {},),
            expandedHeight: kExpandedHeight,
            title: _showTitle ? Text(widget.user.nickname) : null,
            flexibleSpace: _showTitle ? null : FlexibleSpaceBar(
              title: Container(
                child: CircleAvatar(
                  radius: 30.0,
                  foregroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    widget.user.avator
                  ),
                ), 
                width: 60.0,
                height: 60.0,
                // color: Theme.of(_context).backgroundColor,
                padding: const EdgeInsets.all(1.2), // borde width
                decoration: new BoxDecoration(
                  color: Colors.white, // border color
                  shape: BoxShape.circle,
                )
              ),
              background: Image.network(
                widget.user.banner,
                fit: BoxFit.cover,
              )
            ),
            actions: <Widget>[
              !_hasFollow ? FlatButton.icon(
                // padding: EdgeInsetsGeometry.lerp(a, b, t),
                label: Text("关注", style: TextStyle(color: Colors.white, fontSize: 16)),
                icon: Icon(Icons.add, color: Colors.white,),
                onPressed: () {
                },
              ) : FlatButton.icon(
                // padding: EdgeInsetsGeometry.lerp(a, b, t),
                label: Text("取消关注", style: TextStyle(color: Colors.white, fontSize: 16)),
                icon: Icon(Icons.add, color: Colors.white,),
                onPressed: () {
                },
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // Text("data"),
              ..._edges.map((item) => UserStoryCard(story: item, tapFun: () {
                item.publisher = widget.user;
                _navToDetail(context, item);
              })).toList()
            ]),
          ),
        ]
      ),
    );
  }
}

class UserInfo extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize {
    return new Size.fromHeight(20.0);
  }
  @override
  Widget build(BuildContext context) {
    return Text("data");
  }
}

// class UserPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//           return <Widget>[
//             SliverAppBar(
//               elevation: 0,
//               backgroundColor: Theme.of(context).backgroundColor,
//               expandedHeight: 200.0,
//               floating: false,
//               pinned: true,
//               flexibleSpace: FlexibleSpaceBar(
//                 // centerTitle: true,
//                 title: Text(
//                   "Collapsing Toolbar",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16.0,
//                   )
//                 ),
//                 background: Image.network(
//                   "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
//                   fit: BoxFit.cover,
//                 )
//               ),
//             ),
//           ];
//         },
//         body: Center(
//           child: Text("Sample Text"),
//         ),
//       ),
//     );
//   }
// }
