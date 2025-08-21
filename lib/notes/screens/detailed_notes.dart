import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_study_companion/notes/controller/notes_controller.dart';
import 'package:smart_study_companion/notes/model/note.dart';

class DetailedNotes extends StatefulWidget {
  const DetailedNotes({super.key});

  @override
  State<DetailedNotes> createState() => _DetailedNotesState();
}

class _DetailedNotesState extends State<DetailedNotes> {
  QuillController _controller = QuillController.basic();
  final TextEditingController _titleController = TextEditingController();

  bool isEditing = false;
  Note? existingNote;
  int? noteIndex;

  void _saveNote() {
    final title = _titleController.text.trim();
    // Save as Quill Delta JSON for proper rich text support
    final contentJson = _controller.document.toPlainText();

    // Don't save if both title and content are empty
    if (title.isEmpty && _controller.document.toPlainText().trim().isEmpty) {
      return;
    }

    final NotesController notesController = Get.find<NotesController>();

    if (isEditing && noteIndex != null) {
      // Update existing note
      final updatedNote = Note(
        title: title.isEmpty ? "Untitled Note" : title,
        contentJson: contentJson,
        dateCreated: existingNote!.dateCreated, // Keep original creation date
        dateModified: DateTime.now(), // Update modification date
      );

      notesController.updateNote(noteIndex!, updatedNote);
    } else {
      // Create new note
      final note = Note(
        title: title.isEmpty ? "Untitled Note" : title,
        contentJson: contentJson,
        dateCreated: DateTime.now(),
        dateModified: DateTime.now(),
      );

      notesController.addNote(note);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note Created successfully'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  // Stores the JSON Quill Delta
  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();

    // Check if we're editing an existing note
    final arguments = Get.arguments;
    if (arguments != null && arguments['isEditing'] == true) {
      isEditing = true;
      existingNote = arguments['note'] as Note;
      noteIndex = arguments['index'] as int;

      // Pre-populate the fields
      _titleController.text = existingNote!.title ?? '';

      // Handle content - if it's JSON delta, parse it; otherwise treat as plain text
      try {
        final content = existingNote!.contentJson;
        if (content.startsWith('[') || content.startsWith('{')) {
          // It's JSON delta
          final deltaJson = jsonDecode(content) as List;
          final delta = Delta.fromJson(deltaJson);
          _controller = QuillController(
            document: Document.fromDelta(delta),
            selection: const TextSelection.collapsed(offset: 0),
          );
        } else {
          // It's plain text
          _controller.document.insert(0, content);
        }
      } catch (e) {
        // If parsing fails, treat as plain text
        _controller.document.insert(0, existingNote!.contentJson);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 20;

    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 16),
        leadingWidth: 70,
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          child: IconButton(
            icon: FaIcon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          // Delete button (only show when editing)
          if (isEditing)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: IconButton(
                icon: FaIcon(FontAwesomeIcons.trash),
                onPressed: () {
                  if (noteIndex != null) {
                    Get.find<NotesController>().deleteNote(noteIndex!);
                    // show a floating snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Note deleted successfully'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ),

          if (isEditing) SizedBox(width: 16),

          // save
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: IconButton(
              icon: FaIcon(FontAwesomeIcons.save),
              onPressed: () {
                _saveNote();
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // title for note
              TextFormField(
                controller: _titleController,
                autofocus: !isEditing, // Only autofocus for new notes
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                maxLines: null,
                style: GoogleFonts.inter(
                  fontSize: fontSize * 1.5,
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter Note Title',
                  hintStyle: GoogleFonts.inter(
                    fontSize: fontSize * 1.5,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w700,
                  ),
                  maintainHintSize: true,
                  border: InputBorder.none,
                ),
              ),

              QuillSimpleToolbar(
                controller: _controller,
                config: const QuillSimpleToolbarConfig(
                  showAlignmentButtons: false,
                  showBackgroundColorButton: false,
                  showCodeBlock: false,
                  showHeaderStyle: false,
                  showIndent: false,
                  showListNumbers: false,
                  showLink: false,
                  showSubscript: false,
                  showSuperscript: false,
                  showUndo: false,
                  showRedo: false,
                  showSearchButton: false,
                  showFontFamily: false,
                  showColorButton: false,
                  showStrikeThrough: false,
                  showDividers: false,
                  showQuote: false,
                  showInlineCode: false,
                  showClearFormat: false,
                ),
              ),
              Expanded(
                child: QuillEditor.basic(
                  focusNode: FocusNode(),
                  controller: _controller,
                  config: const QuillEditorConfig(
                    autoFocus: false,
                    placeholder: 'Start writing your note here...',
                    expands: true,
                    scrollPhysics: BouncingScrollPhysics(),
                    scrollable: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
