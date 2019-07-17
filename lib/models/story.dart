import 'package:meta/meta.dart';
import 'package:date_format/date_format.dart';
import 'package:note_story_flutter/models/user.dart';

// final dateFormat = new DateFormat('yyyy-MM-dd hh:mm');

class Story {
  Story({
    @required this.id,
    @required this.title,
    this.intro,
    this.publishTime,
    this.publisher,
    this.tags,
  });

  String id;
  String title;
  String intro;
  String publishTime;
  List<String> tags;
  User publisher;

  // Review copyWith({
  //   // Episode episode,
  //   int stars,
  //   String commentary,
  // }) {
  //   return Review(
  //     // episode: episode ?? this.episode,
  //     stars: stars ?? this.stars,
  //     commentary: commentary ?? this.commentary,
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   // assert(episode != null && stars != null);

  //   return <String, dynamic>{
  //     // 'episode': episodeToJson(episode),
  //     'stars': stars,
  //     'commentary': commentary,
  //   };
  // }

  static Story fromJson(Map<String, dynamic> map) {
    String publishTime = map['publishTime'] as String;
    DateTime time = DateTime.parse(publishTime);
    
    User publisher = User.fromJson(map['publisher']);

    return Story(
          // episode: episodeFromJson(map['episode'] as String),
      id: map['id'] as String,
      title: map['title'] as String,
      intro: map['intro'] ?? '',
      publishTime: formatDate(time, [yyyy, '-', mm, '-', dd, ' ', hh, ':', mm]),
      publisher: publisher,
      tags: map['tags'].cast<String>()
    );
  }
}

// const String Function(Object jsonObject) displayReview = getPrettyJSONString;
