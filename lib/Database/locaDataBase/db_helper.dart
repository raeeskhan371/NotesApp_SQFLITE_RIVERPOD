import 'dart:io';

import 'package:notes_app_sqflite/model/note_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static DbHelper getinstance = DbHelper._();
  static String Tabel_Note = "Notes";
  static String Table_Column_id = "id";
  static String Table_Column_title = "title";
  static String Table_Column_description = "description";
  Database? mydb;

  // get database

  Future<Database> getDB() async {
    if (mydb != null) {
      return mydb!;
    } else {
      mydb = await openDB();
      return mydb!;
    }
  }

  Future<Database> openDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "Notes.db");

    mydb = await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
          'Create Table $Tabel_Note($Table_Column_id INTEGER PRIMARY KEY AUTOINCREMENT,$Table_Column_title TEXT,$Table_Column_description TEXT)',
        );
      },
      version: 1,
    );
    return mydb!;
  }

  Future<bool> userAddNote({
    required String title,
    required String description,
  }) async {
    var db = await getDB();
    int rowsEffected = await db.insert(
      Tabel_Note,
      NoteModel(title: title, description: description).toMap(),
    );

    return rowsEffected > 0;
  }

  Future<List<NoteModel>> userFetchingNotes() async {
    var db = await getDB();

    List<Map<String, dynamic>> result = await db.query(Tabel_Note);
    return result.map((map) {
      return NoteModel.fromMap(map);
    }).toList();
  }

  Future<bool> userUpdateNote({
    required String title,
    required String description,
    required int id,
  }) async {
    var db = await getDB();

    int rowsEffected = await db.update(
      Tabel_Note,
      {Table_Column_title: title, Table_Column_description: description},

      where: "$Table_Column_id=?",
      whereArgs: [id],
    );
    return rowsEffected > 0;
  }

  Future<bool> userDeleteNote({required int id}) async {
    var db = await getDB();
    int rowsEffected = await db.delete(
      Tabel_Note,
      where: "$Table_Column_id=?",
      whereArgs: [id],
    );
    return rowsEffected > 0;
  }
}
