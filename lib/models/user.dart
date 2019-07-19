import 'package:meta/meta.dart';

class Self {
  static Self _instance;
  factory Self({
    String token,
    String id,
    String email,
    String nickname,
    String avator,
    String banner
  }) {
    _instance ??= Self._internalConstructor(
      token,
      id,
      email,
      nickname,
      avator,
      banner
    );
    return _instance;
  }
  Self._internalConstructor(
    this.token,
    this.id,
    this.email,
    this.nickname,
    this.avator,
    this.banner
  );

  String token;
  String id;
  String email;
  String nickname;
  String avator;
  String banner;
}

class User {
  User({
    @required this.id,
    @required this.email,
    this.nickname,
    this.avator,
    this.banner
  });

  String id;
  String email;
  String nickname;
  String avator;
  String banner;

  static User fromJson(Map<String, dynamic> map) => User(
        // episode: episodeFromJson(map['episode'] as String),
    id: map['id'] as String,
    email: map['email'] ?? '',
    nickname: map['nickname'] ?? '',
    avator: map['avator'] ?? '',
    banner: map['banner'] ?? ''
  );
}

// const String Function(Object jsonObject) displayReview = getPrettyJSONString;
