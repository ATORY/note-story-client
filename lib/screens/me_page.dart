import 'package:flutter/material.dart';
import 'package:note_story_flutter/screens/login_page.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:note_story_flutter/screens/setting_page.dart';
import 'package:note_story_flutter/tabs/me/followed.dart';
import 'package:note_story_flutter/tabs/me/profile.dart';
import 'package:note_story_flutter/tabs/me/publish.dart';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:note_story_flutter/models/user.dart';
import 'package:note_story_flutter/utils/animations.dart';

const title = "我的";
const kExpandedHeight = 200.0;

class MePage extends StatefulWidget {
  static const BottomNavigationBarItem navItem = BottomNavigationBarItem(
    icon: Icon(Icons.person),
    title: Text(title),
  );

  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> with SingleTickerProviderStateMixin {
  var counter = 0;
  var token = "";
  var tokenKey = "token";
  var key = "counter";
  var status = "init";

  ScrollController _scrollController;
  TabController _tabController;
  // GraphQLClient _client;

  double _offset = 0.0;


  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    _scrollController = ScrollController()
      ..addListener(() => setState(() {
        _offset = _scrollController.offset;
      }));
  }

  bool get _showTitle {
    return _scrollController.hasClients
        && _offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    Self loginUser = Self();
    if (loginUser.id == null) {
      return Scaffold(
        body: Container(
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      bottomToTopRoute(LoginPage())
                    );
                  },
                  child: new Text('Go login')
                ),
              ],
            )
          )
        )
      );
    }
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget> [
            SliverAppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).backgroundColor,
              expandedHeight: kExpandedHeight,
              // floating: false,
              pinned: true,
              title: _showTitle ? Text(title) : null,
              flexibleSpace: _showTitle ? null : FlexibleSpaceBar(
                title: Container(
                  child: CircleAvatar(
                    radius: 30.0,
                    foregroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      Self().avator
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
                  Self().banner,
                  fit: BoxFit.cover
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Setting())
                    );
                  },
                ),
              ],
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  isScrollable: true,
                  indicatorWeight: 3,
                  indicatorColor: Theme.of(context).backgroundColor,
                  labelPadding: EdgeInsets.only(right: 20.0, left: 20.0),
                  controller: _tabController,
                  labelColor: Colors.black87,
                  // unselectedLabelColor: Colors.grey,
                  tabs: <Widget>[
                    Profile.tab,
                    Publish.tab,
                    Followed.tab
                  ],
                )
              )
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Profile(),
            Publish(),
            Followed()
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_tabBar],
      )
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

// class MePage extends StatelessWidget {
//   static const BottomNavigationBarItem navItem = BottomNavigationBarItem(
//     icon: Icon(Icons.person),
//     title: Text('我的'),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: new AppBar(
//       //   title: new Text("我的"),
//       // ),
//       body: Container(
//         color: themeColor,
//         child: new Center(
//           child: new Text("Account Screen"),
//         )
//       ),
//     );
//   }
// }

