import 'package:flutter_riverpod/legacy.dart';
import 'package:notes_app_sqflite/Database/locaDataBase/db_helper.dart';
import 'package:notes_app_sqflite/model/note_model.dart';

final noteProvider = StateNotifierProvider<NotesNotifier, List<NoteModel>>((
  ref,
) {
  return NotesNotifier();
});

class NotesNotifier extends StateNotifier<List<NoteModel>> {
  NotesNotifier() : super([]);

  final db = DbHelper.getinstance;

  Future<void> loadNotes() async {
    final notes = await db.fetchingNotes();
    state = notes;
  }

  Future<void> addNotes({
    required String title,
    required String description,
  }) async {
    await db.addNote(title: title, description: description);
    await loadNotes();
  }

  Future<List<NoteModel>> getAllnotes() async {
    await loadNotes();
    return await db.fetchingNotes();
  }

  Future<void> UpdateNotes({
    required String title,
    required String description,
    required int id,
  }) async {
    db.updateNotes(title: title, description: description, id: id);
    await loadNotes();
  }

  Future<void> deleteNotes({required int id}) async {
    await db.deleteNote(id);
  }
}
