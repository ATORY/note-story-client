import 'package:meta/meta.dart';
import 'package:date_format/date_format.dart';
import 'package:sqflite/sqflite.dart';

import 'package:note_story_flutter/models/db_helper.dart';
import 'package:note_story_flutter/models/user.dart';


// internet story
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

class LocalStory {

  static String table = 'story';

  int id;
  String title;
  String intro;
  String content;
  DateTime createTime;
  DateTime updateTime;

  LocalStory({
    this.id,
    this.title,
    this.intro,
    this.content,
    this.createTime,
    this.updateTime
  });

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['intro'] = intro;
    map['content'] = content;
    return map;
  }

  LocalStory.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.intro = map['intro'];
    this.content = map['content'];
  }

  Future<int> save() async {
    var dbClient = await DBHelper().db;
    var result = await dbClient.insert(table, this.toMap());
    // var result = await dbClient.rawInsert(
    //   'INSERT INTO $tableNote ($columnTitle, $columnDescription) VALUES (\'${note.title}\', \'${note.description}\')'
    // );
 
    return result;
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    var dbClient = await DBHelper().db;
    var result = await dbClient.query(table, columns: ['id', 'title', 'intro']);
    // var result = await dbClient.rawQuery('SELECT * FROM $tableNote');
 
    return result.toList();
  }
 
  static Future<int> getCount() async {
    var dbClient = await DBHelper().db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $table'));
  }
 
  static Future<LocalStory> getOne(int id) async {
    var dbClient = await DBHelper().db;
    List<Map> result = await dbClient.query(
      table,
      columns: ['id', 'title', 'intro', 'content'],
      where: 'id = ?',
      whereArgs: [id]);
    // var result = await dbClient.rawQuery('SELECT * FROM $tableNote WHERE $columnId = $id');
 
    if (result.length > 0) {
      return new LocalStory.fromMap(result.first);
    }
 
    return null;
  }
 
  static Future<int> delete(int id) async {
    var dbClient = await DBHelper().db;
    return await dbClient.delete(table, where: 'id = ?', whereArgs: [id]);
    // return await dbClient.rawDelete('DELETE FROM $tableNote WHERE $columnId = $id');
  }
 
  Future<int> update() async {
    var dbClient = await DBHelper().db;
    var result = await dbClient.update(table, this.toMap(), where: "id = ?", whereArgs: [this.id]);
    // return await dbClient.rawUpdate(
    //   'UPDATE $tableNote SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}'
    // );
    await this.updateStoryTime();
    return result;
  }

  Future<int> updateStoryTime() async {
    var dbClient = await DBHelper().db;
    return await dbClient.rawUpdate(
      'UPDATE story SET updateTime=CURRENT_TIMESTAMP WHERE id = ${this.id}'
    );
  }
}
