import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app_sqflite/Database/locaDataBase/db_helper.dart';
import 'package:notes_app_sqflite/providers/notes_provider.dart';

class Homescreen extends ConsumerStatefulWidget {
  Homescreen({super.key});

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(notesProvider.notifier).getAllNotes();
    });
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

      body: Consumer(
        builder: (context, ref, child) {
          final notes = ref.watch(notesProvider);

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                leading: Text(note.title),
                title: Text(note.description),
                subtitle: Text("data"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        print("Button Clicked");
                        print("Note ID: ${note.id}");
                        await ref
                            .read(notesProvider.notifier)
                            .updateNotes(
                              title: "Raees Khan",
                              description: "HomeWorkout",
                              id: note.id!,
                            );
                      },

                      child: Icon(Icons.edit, color: Colors.blue),
                    ),
                    GestureDetector(
                      onTap: () async {
                        print("Button Clicked");
                        print("Note ID: ${note.id}");
                        await ref
                            .read(notesProvider.notifier)
                            .deleteNotes(id: note.id!);
                      },
                      child: Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ref
              .read(notesProvider.notifier)
              .addNotes(title: "Proffyy", description: "Playing Game");
        },
      ),
    );
  }
}
