import 'dart:async';
import 'dart:io';
import 'package:keepr/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // this instance is singleton
  static Database _database;

  String noteTable = 'note_table';
  String colID = 'id';
  String colTitle = 'title';
  String colDesc = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    // factory is the constructor which can return shit.
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDB();
    }
    return _database;
  }

  Future<Database> initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'database.db';

    var notesDB = await openDatabase(path, version: 1, onCreate: _createDB);
    return notesDB;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $noteTable($colID INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,'
        '$colDesc TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  // Ab likhege queries and CRUD
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var res = db.query(noteTable, orderBy: '$colPriority ASC');
    return res;
  }

  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = List<Note>();

    for(int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }

  // Add note
  Future<int> addNote(Note note) async {
    Database db = await this.database;
    var res = db.insert(noteTable, note.toMap());
    return res;
  }

  // Update Note
  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var res = db.update(noteTable, note.toMap(), where: '$colID = ?', whereArgs: [note.id]);
    return res;
  }

  // Delete Note
  Future<int> deleteNote(Note note) async {
    Database db = await this.database;
    var res = db.delete(noteTable, where: '$colID = ?', whereArgs: [note.id]);
    return res;
  }

  // Get Count
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> allNotes = await db.query(noteTable);
    return Sqflite.firstIntValue(allNotes);
  }

}