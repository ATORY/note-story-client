import 'package:flutter/material.dart';
import 'package:note_story_flutter/tabs/recommand.dart';
import 'package:note_story_flutter/tabs/all.dart';


const textStyle = TextStyle(
  fontSize: 12.0,
  color: Colors.white,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w600
);

class ClubPage extends StatelessWidget {
  static const BottomNavigationBarItem navItem = BottomNavigationBarItem(
    icon: Icon(Icons.home),
    title: Text('club'),
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: new AppBar(
      //   title: new Text("Club"),
      // ),
      body: new Home()
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
    TabController controller;

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  TabBar getTabBar() {
    return new TabBar(
      // indicatorPadding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
      // labelPadding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
      // indicator: UnderlineTabIndicator(
      //   borderSide: BorderSide(color: Colors.white, width: 3.0),
      //   insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, -4.0),
      // ),
      // unselectedLabelColor: Color(0xFFc9c9c9),
      // unselectedLabelStyle: textStyle.copyWith(
      //     fontSize: 20.0,
      //     color: Color(0xFFc9c9c9),
      //     fontWeight: FontWeight.w700),
      isScrollable: true,
      indicatorWeight: 3,
      indicatorColor: Colors.white,
      labelPadding: EdgeInsets.only(right: 20.0, left: 20.0),
      tabs: [
        // new Container(
        //   width: 30.0,
        //   child: new Tab(text: '推荐'),
        // ),
        new Tab(
          text: "推荐",
          // set icon to the tab
          // icon: new Icon(Icons.adb),
        ),
        new Tab(
          text: "全部",
          // icon: new Icon(Icons.adb),
        ),
      ],
      // setup the controller
      controller: controller,
    );
  }

  TabBarView getTabBarView(var tabs) {
    return new TabBarView(
      // Add tabs as widgets
      children: tabs,
      // set the controller
      controller: controller,
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // Appbar
      // appBar: new AppBar(
      //   // Title
      //   title: getTabBar(),
      //   // Set the background color of the App Bar
      //   backgroundColor: Colors.blue,
      //   // Set the bottom property of the Appbar to include a Tab Bar
      //   // bottom: getTabBar()
      // ),
      appBar: new AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(68, 186, 189, 1),
        flexibleSpace: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTabBar()
            ],
          ),
        ),
      ),
      // appBar: new PreferredSize(
      //   preferredSize: Size.fromHeight(kToolbarHeight),
      //   child: new Container(
      //     color: Colors.blue,
      //     child: new SafeArea(
      //       child: getTabBar()
      //       // Column(
      //       //   children: <Widget>[
      //       //     new Expanded(child: new Container()),
      //       //     getTabBar(),
      //       //   ],
      //       // ),
      //     ),
      //   ),
      // ),
      // Set the TabBar view as the body of the Scaffold
      body: getTabBarView(<Widget>[
        new RecommandTab(),
        new AllTab()
      ])
    );
  }
}
