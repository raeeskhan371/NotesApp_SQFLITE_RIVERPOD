import 'package:flutter/material.dart';
import 'package:notes_app_sqflite/Database/locaDataBase/db_helper.dart';

class Homescreen extends StatefulWidget {
  Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Map<String, dynamic>> Notes = [];
  DBHelper? dbRef;
  @override
  void initState() {
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    Notes = await dbRef!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Notes"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: ListView.builder(
        itemCount: Notes.length,
        itemBuilder: (context, index) {
          final note = Notes[index];
          return ListTile(
            leading: Text(note[DBHelper.Table_Coulumn_S_NO].toString()),
            title: Text(note[DBHelper.Table_Coulumn_Title]),
            subtitle: Text(note[DBHelper.Table_Coulumn_Description]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    await dbRef!.updateNote(
                      title: "Khan",
                      description: "Football",
                      id: note["${DBHelper.Table_Coulumn_S_NO}"],
                    );
                    getNotes();
                  },

                  child: Icon(Icons.edit, color: Colors.blue),
                ),
                GestureDetector(
                  onTap: () async {
                    await dbRef!.deleteNote(
                      id: note["${DBHelper.Table_Coulumn_S_NO}"],
                    );
                    getNotes();
                  },
                  child: Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await dbRef!.addNote(
            title: "Raees khan",
            description: "Home WorkOut ",
          );
          getNotes();
        },
      ),
    );
  }
}
