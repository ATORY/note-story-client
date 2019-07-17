import 'package:flutter/material.dart';
import 'package:note_story_flutter/models/user.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _UserPageState createState() => new _UserPageState();
}

const kExpandedHeight = 150.0;

class _UserPageState extends State<UserPage> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients
        && _scrollController.offset > kExpandedHeight - kToolbarHeight;
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
              // title: new Column(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: <Widget>[
              //     Text('_SliverAppBar'),
              //     Text('subtitle'),
              //   ],
              // ),
              background: Image.network(
                widget.user.banner,
                fit: BoxFit.cover,
              )
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(List<Text>.generate(100, (int i) {
              return Text("List item $i");
            })),
          ),
        ]
      ),
    );
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
