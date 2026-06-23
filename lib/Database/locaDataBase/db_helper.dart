import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();

  static final String Table_Note = "Note";
  static final String Table_Coulumn_S_NO = "S_NO";
  static final String Table_Coulumn_Title = "Title";
  static final String Table_Coulumn_Description = "Description";
  // OpenDatabase  first we check path if path exist or not
  Database? mydb;

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
    String dbpath = join(directory.path, "TaskFlow.db");
    return openDatabase(
      dbpath,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $Table_Note($Table_Coulumn_S_NO INTEGER PRIMARY KEY AUTOINCREMENT,$Table_Coulumn_Title TEXT,$Table_Coulumn_Description TEXT )",
        );
      },
      version: 1,
    );
  }

  Future<bool> addNote({
    required String title,
    required String description,
  }) async {
    var db = await getDB();
    int rowEffected = await db.insert(Table_Note, {
      Table_Coulumn_Title: title,

      Table_Coulumn_Description: description,
    });
    return rowEffected > 0;
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();

    List<Map<String, dynamic>> AllNotes = await db.query(Table_Note);

    return AllNotes;
  }

  Future<bool> updateNote({
    required String title,
    required String description,
    required int id,
  }) async {
    var db = await getDB();

    int rowEffected = await db.update(Table_Note, {
      Table_Coulumn_Title: title,
      Table_Coulumn_Description: description,
      Table_Coulumn_S_NO: id,
    }, where: "$Table_Coulumn_S_NO=$id");

    return rowEffected > 0;
  }

  Future<bool> deleteNote({required int id}) async {
    var db = await getDB();

    int rowEffected = await db.delete(
      Table_Note,
      where: "$Table_Coulumn_S_NO=$id",
    );

    return rowEffected > 0;
  }
}
