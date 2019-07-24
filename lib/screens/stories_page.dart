import 'package:flutter/material.dart';
import 'package:note_story_flutter/models/story.dart';

class StoriesPage extends StatefulWidget {
  @override
  _StoriesPageState createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  List<LocalStory> _stories = [];

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  void _loadStories() async {
    List<Map<String, dynamic>> stories = await LocalStory.getAll();
    setState(() {
      _stories = stories.map((item) => LocalStory.fromMap(item)).toList();  
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(_stories.length);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text('故事'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: _stories.length,
          itemBuilder: (context, index) {
            return Column(
              // textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Divider(
                //   height: 1,
                //   color: Colors.white,
                // ),
                _Card(story: _stories[index], tapFun: () {
                  print('tap');
                  Navigator.pop(context, _stories[index].id);
                }),
                Divider(height: 1),
              ],
            );
            
          },
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final LocalStory story;
  final Function tapFun;

  _Card({Key key, @required this.story, this.tapFun}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              story.title,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              story.intro,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15),
            ),
          ]
        )
      ),
      onTap: tapFun ?? tapFun,
    );
  }
}