import 'package:meta/meta.dart';
import 'package:date_format/date_format.dart';
import 'package:note_story_flutter/models/user.dart';

class Story {
  Story({
    @required this.id,
    @required this.title,
    this.intro,
    this.publishTime,
    this.publisher,
    this.tags,
    this.clientURL,
  });

  String id;
  String title;
  String intro;
  String publishTime;
  String clientURL;
  List<String> tags;
  User publisher;

  static Story fromJson(Map<String, dynamic> map) {
    String publishTime = map['publishTime'] as String;
    DateTime time = DateTime.parse(publishTime);  
    User publisher;
  
    if (map['publisher'] != null) {
      publisher = User.fromJson(map['publisher']);
    }

    return Story(
          // episode: episodeFromJson(map['episode'] as String),
      id: map['id'] as String,
      title: map['title'] as String,
      intro: map['intro'] ?? '',
      clientURL: map['clientURL'] as String,
      publishTime: formatDate(time, [yyyy, '-', mm, '-', dd, ' ', hh, ':', mm]),
      publisher: publisher,
      tags: map['tags'].cast<String>()
    );
  }
}

// const String Function(Object jsonObject) displayReview = getPrettyJSONString;
