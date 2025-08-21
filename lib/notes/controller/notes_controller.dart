import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:smart_study_companion/notes/model/note.dart';

class NotesController extends GetxController {
  var notes = <Note>[].obs;
  var isLoading = true.obs;

  Box<Note> notesBox = Hive.box<Note>('notesBox');

  @override
  void onInit() {
    super.onInit();
    initializeBox();
  }

  Future<void> initializeBox() async {
    try {
      // Check if box is already open, if not open it
      if (Hive.isBoxOpen('notesBox')) {
        notesBox = Hive.box<Note>('notesBox');
      } else {
        notesBox = await Hive.openBox<Note>('notesBox');
      }
      fetchNotes();
      isLoading.value = false;
    } catch (e) {
      print('Error initializing notes box: $e');
      isLoading.value = false;
    }
  }

  void fetchNotes() {
    if (notesBox.isOpen) {
      notes.value = notesBox.values.toList();
    }
  }

  Future<void> addNote(Note note) async {
    try {
      await notesBox.add(note);
      print("Note added: ${note.title}");
      fetchNotes();
    } catch (e) {
      print('Error adding note: $e');
    }
  }

  Future<void> updateNote(int index, Note updatedNote) async {
    try {
      await notesBox.putAt(index, updatedNote);
      fetchNotes();
    } catch (e) {
      print('Error updating note: $e');
    }
  }

  Future<void> deleteNote(int index) async {
    try {
      if (index >= 0 && index < notesBox.length) {
        await notesBox.deleteAt(index);
        fetchNotes();
      }
    } catch (e) {
      print('Error deleting note: $e');
    }
  }
}
