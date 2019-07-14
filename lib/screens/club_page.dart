import 'package:flutter/material.dart';
import 'package:note_story_flutter/tabs/recommand.dart';
import 'package:note_story_flutter/tabs/all.dart';


class ClubPage extends StatelessWidget {
  static const BottomNavigationBarItem navItem = BottomNavigationBarItem(
    icon: Icon(Icons.home),
    title: Text('Home'),
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
      tabs: <Tab>[
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
        appBar: new AppBar(
          // Title
          title: getTabBar(),
          // Set the background color of the App Bar
          backgroundColor: Colors.blue,
          // Set the bottom property of the Appbar to include a Tab Bar
          // bottom: getTabBar()
        ),
        // Set the TabBar view as the body of the Scaffold
        body: getTabBarView(<Widget>[
          new RecommandTab(),
          new AllTab()
        ]));
  }
}
