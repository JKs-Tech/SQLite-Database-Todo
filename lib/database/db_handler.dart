import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sql_todo/models/db_model.dart';

class DbHandler {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationSupportDirectory();
    String path = join(documentDirectory.path, "todo.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE todo (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, des TEXT NOT NULL)");
  }

  Future<NoteModel> insert(NoteModel noteModel) async {
    var dbClient = await db;
    await dbClient!.insert("todo", noteModel.toMap());
    return noteModel;
  }

  Future<List<NoteModel>> getNoteList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> qureyResult =
        await dbClient!.query("todo");
    return qureyResult.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      "todo",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> Update(NoteModel noteModel) async {
    var dbClient = await db;
    return await dbClient!.update("todo", noteModel.toMap(),
        where: "id = ?", whereArgs: [noteModel.id]);
  }
}
