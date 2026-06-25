import 'package:notes_app_sqflite/Database/locaDataBase/db_helper.dart';
import 'package:notes_app_sqflite/model/note_model.dart';
import 'package:riverpod/legacy.dart';

final notesProvider = StateNotifierProvider<NotesNotifier, List<NoteModel>>((
  ref,
) {
  return NotesNotifier();
});

class NotesNotifier extends StateNotifier<List<NoteModel>> {
  var db = DbHelper.getinstance;
  NotesNotifier() : super([]);

  Future<void> getAllNotes() async {
    List<NoteModel> notes = await db.userFetchingNotes();
    state = notes;
  }

  Future<void> addNotes({
    required String title,
    required String description,
  }) async {
    await db.userAddNote(title: title, description: description);
    await getAllNotes();
  }

  Future<void> updateNotes({
    required String title,
    required String description,
    required int id,
  }) async {
    await db.userUpdateNote(title: title, description: description, id: id);

    await getAllNotes();
  }

  Future<void> deleteNotes({required int id}) async {
    await db.userDeleteNote(id: id);
    await getAllNotes();
  }
}
