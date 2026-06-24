import 'dart:io';

import 'package:notes_app_sqflite/model/note_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static DbHelper getinstance = DbHelper._();
  static String Table_Name = "Notes";
  static String Table_Coulumn_Title = "title";
  static String Table_Coulumn_Description = "description";
  static String Table_Coulumn_S_NO = "S_NO";

  Database? myDB;

  Future<Database> getDb() async {
    if (myDB != null) {
      return myDB!;
    } else {
      myDB = await openDB();
      return myDB!;
    }
  }

  Future<Database> openDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "myNotes.db");
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
          "Create Table $Table_Name($Table_Coulumn_S_NO INTEGER PRIMARY KEY AUTOINCREMENT,$Table_Coulumn_Title TEXT,$Table_Coulumn_Description TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<bool> addNote({
    required String title,
    required String description,
  }) async {
    var db = await getDb();
    int rowsEffected = await db.insert(
      Table_Name,
      NoteModel(title: title, description: description).toMap(),
    );
    return rowsEffected > 0;
  }

  Future<List<NoteModel>> fetchingNotes() async {
    var db = await getDb();

    List<Map<String, dynamic>> result = await db.query(Table_Name);
    return result.map((map) => NoteModel.fromMap(map)).toList();
  }

  // Update Function

  Future<bool> updateNotes({
    required String title,
    required String description,
    required int id,
  }) async {
    var db = await getDb();
    int rowsEffected = await db.update(
      Table_Name,
      NoteModel(title: title, description: description).toMap(),
      where: "$Table_Coulumn_S_NO =?",
      whereArgs: [id],
    );
    return rowsEffected > 0;
  }

  // delete Fucntion
  Future<bool> deleteNote(int id) async {
    var db = await getDb();

    print(await db.query(Table_Name));
    print("Delete ID = $id");

    int rowsEffected = await db.delete(
      Table_Name,
      where: "$Table_Coulumn_S_NO = ?",
      whereArgs: [id],
    );

    print("Rows Deleted = $rowsEffected");

    return rowsEffected > 0;
  }
}
