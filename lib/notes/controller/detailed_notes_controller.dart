import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:smart_study_companion/notes/controller/notes_controller.dart';
import 'package:smart_study_companion/notes/model/note.dart';

class DetailedNotesController extends GetxController {
  final titleController = TextEditingController();
  var quillController = QuillController.basic();

  var isEditing = false.obs;
  Note? existingNote;
  int? noteIndex;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    print('DetailedNotesController onInit - args: $args'); // Debug print

    if (args != null && args['isEditing'] == true) {
      isEditing.value = true;
      existingNote = args['note'] as Note;
      noteIndex = args['index'] as int;

      print(
        'Setting up editing mode - noteIndex: $noteIndex, note: ${existingNote?.title}',
      ); // Debug print

      titleController.text = existingNote!.title ?? '';

      try {
        final content = existingNote!.contentJson;
        if (content.startsWith('[') || content.startsWith('{')) {
          final deltaJson = jsonDecode(content) as List;
          final delta = Delta.fromJson(deltaJson);
          quillController = QuillController(
            document: Document.fromDelta(delta),
            selection: const TextSelection.collapsed(offset: 0),
          );
        } else {
          quillController.document.insert(0, content);
        }
      } catch (e) {
        print('Error parsing content: $e'); // Debug print
        quillController.document.insert(0, existingNote!.contentJson);
      }
    } else {
      print('Creating new note mode'); // Debug print
      isEditing.value = false;
    }

    print('Final isEditing value: ${isEditing.value}'); // Debug print
  }

  void saveNote(BuildContext context) {
    final title = titleController.text.trim();
    // Save as Quill Delta JSON to preserve rich text formatting
    final deltaJson = quillController.document.toDelta().toJson();
    final contentJson = jsonEncode(deltaJson);

    if (title.isEmpty && quillController.document.toPlainText().trim().isEmpty)
      return;

    final notesController = Get.find<NotesController>();

    if (isEditing.value && noteIndex != null) {
      final updatedNote = Note(
        title: title.isEmpty ? "Untitled Note" : title,
        contentJson: contentJson, // Save as JSON delta
        dateCreated: existingNote!.dateCreated,
        dateModified: DateTime.now(),
      );
      notesController.updateNote(noteIndex!, updatedNote);
    } else {
      final note = Note(
        title: title.isEmpty ? "Untitled Note" : title,
        contentJson: contentJson, // Save as JSON delta
        dateCreated: DateTime.now(),
        dateModified: DateTime.now(),
      );
      notesController.addNote(note);
    }

    Get.back(); // navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditing.value
              ? 'Note updated successfully ✅'
              : 'Note created successfully ✅',
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void deleteNote(BuildContext context) {
    if (noteIndex != null) {
      Get.find<NotesController>().deleteNote(noteIndex!);
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note deleted successfully 🗑️'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    quillController.dispose();
    super.onClose();
  }
}
