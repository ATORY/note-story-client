import 'package:meta/meta.dart';

class User {
  User({
    @required this.id,
    @required this.email,
    this.nickname,
    this.avator
  });

  String id;
  String email;
  String nickname;
  String avator;

  static User fromJson(Map<String, dynamic> map) => User(
        // episode: episodeFromJson(map['episode'] as String),
    id: map['id'] as String,
    email: map['email'] ?? '',
    nickname: map['nickname'] ?? '',
    avator: map['avator'] ?? ''
  );
}

// const String Function(Object jsonObject) displayReview = getPrettyJSONString;
