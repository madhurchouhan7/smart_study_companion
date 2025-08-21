import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_study_companion/notes/controller/detailed_notes_controller.dart';

class DetailedNotes extends StatelessWidget {
  DetailedNotes({super.key});

  final controller = Get.put(DetailedNotesController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 20;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(
            () => controller.isEditing.value
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      controller.deleteNote(context);
                    },
                  )
                : SizedBox.shrink(),
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              controller.saveNote(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: controller.titleController,
              autofocus: true, // Only autofocus for new notes
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
              controller: controller.quillController,
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
                controller: controller.quillController,
                config: const QuillEditorConfig(autoFocus: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
