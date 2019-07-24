import 'dart:async';
// import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';

import 'package:note_story_flutter/models/story.dart';

class DBHelper{
  static Database _db;
  static final DBHelper _instance = new DBHelper.internal();
 
  factory DBHelper() => _instance;

  DBHelper.internal();

  Future<Database> get db async {
    if(_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    // io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = join(documentsDirectory.path, "notestory.db");
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "notestory.db");
    print(path);
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    String table = LocalStory.table;
    await db.execute(
      """
      CREATE TABLE IF NOT EXISTS $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        intro TEXT,
        content TEXT,
        createTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        __v INTEGER DEFAULT $version
      )
      """
    );
    // print("Created tables");
  }
}