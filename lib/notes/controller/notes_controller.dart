import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:smart_study_companion/notes/model/note.dart';

class NotesController extends GetxController {
  // Observable list to hold notes
  var notes = <Note>[].obs;
  var isLoading = true.obs;

  // creating a Hive box to store notes
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

  // add note
  Future<void> addNote(Note note) async {
    try {
      await notesBox.add(note);
      fetchNotes();
    } catch (e) {
      print('Error adding note: $e');
    }
  }

  // update note
  Future<void> updateNote(int index, Note updatedNote) async {
    try {
      await notesBox.putAt(index, updatedNote);
      fetchNotes();
    } catch (e) {
      print('Error updating note: $e');
    }
  }

  // delete note
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
