import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_study_companion/notes/controller/detailed_notes_controller.dart';

class DetailedNotes extends StatelessWidget {
  const DetailedNotes({super.key});

  @override
  Widget build(BuildContext context) {
    // Delete any existing controller to ensure fresh state
    try {
      Get.delete<DetailedNotesController>();
    } catch (e) {
      // Controller doesn't exist, which is fine
    }

    // Create a fresh controller
    final controller = Get.put(DetailedNotesController());
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 20;

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          child: IconButton(
            icon: FaIcon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Get.back();
            },
          ),
        ),

        actionsPadding: EdgeInsets.only(right: 16),
        actions: [
          // Delete button - only show when editing
          Obx(() {
            print('isEditing: ${controller.isEditing.value}'); // Debug print
            return controller.isEditing.value
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: IconButton(
                      icon: FaIcon(FontAwesomeIcons.trash),
                      onPressed: () {
                        controller.deleteNote(context);
                      },
                    ),
                  )
                : SizedBox.shrink();
          }),

          SizedBox(width: 12),

          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: IconButton(
              icon: FaIcon(FontAwesomeIcons.save),
              onPressed: () {
                controller.saveNote(context);
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: controller.titleController,
              autofocus:
                  !controller.isEditing.value, // Don't autofocus when editing
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
                config: const QuillEditorConfig(
                  autoFocus: false,

                  placeholder: 'Start writing your note here...',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
