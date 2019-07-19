import 'package:flutter/material.dart';

import 'package:note_story_flutter/models/story.dart';

class StoryCard extends StatelessWidget {

  StoryCard({Key key, @required this.story, this.tapFun}):super(key: key);
  final Story story;
  final Function tapFun;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          // height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8.0, 0, 5.0),
                child: Text(
                  story.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)
                ),
              ),
              Text(
                story.intro,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5.0, 0, 0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 13.0,
                      backgroundImage: NetworkImage(
                        story.publisher.avator
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.0, 0, 5.0, 0),
                      child: Text(story.publisher.nickname ?? story.publisher.email),
                    ),
                    Text(story.publishTime),
                    ...story.tags.map((item) => Container(
                      margin: EdgeInsets.fromLTRB(3, 0, 0, 0),
                      padding: EdgeInsets.fromLTRB(2, 1, 2, 1),
                      color: Theme.of(context).backgroundColor,
                      // decoration: new BoxDecoration(
                      //   // color: Colors.green,
                      //   borderRadius: new BorderRadius.all(const Radius.circular(2.0))
                      // ),
                      child: Text(
                        item,
                        style: TextStyle(
                          // backgroundColor: ,
                          color: Colors.white,
                          fontSize: 12.0
                        )
                      )
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: tapFun ?? tapFun,
      ),
      elevation: 0,
    );
  }
}

class UserStoryCard extends StatelessWidget {

  UserStoryCard({Key key, @required this.story, this.tapFun}):super(key: key);
  final Story story;
  final Function tapFun;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          // height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8.0, 0, 5.0),
                child: Text(
                  story.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)
                ),
              ),
              Text(
                story.intro,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5.0, 0, 0),
                child: Row(
                  children: <Widget>[
                    Text(story.publishTime),
                    ...story.tags.map((item) => Container(
                      margin: EdgeInsets.fromLTRB(3, 0, 0, 0),
                      padding: EdgeInsets.fromLTRB(2, 1, 2, 1),
                      color: Theme.of(context).backgroundColor,
                      // decoration: new BoxDecoration(
                      //   // color: Colors.green,
                      //   borderRadius: new BorderRadius.all(const Radius.circular(2.0))
                      // ),
                      child: Text(
                        item,
                        style: TextStyle(
                          // backgroundColor: ,
                          color: Colors.white,
                          fontSize: 12.0
                        )
                      )
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: tapFun ?? tapFun,
      ),
      elevation: 0,
    );
  }
}