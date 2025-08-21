import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailedNotes extends StatefulWidget {
  const DetailedNotes({super.key});

  @override
  State<DetailedNotes> createState() => _DetailedNotesState();
}

class _DetailedNotesState extends State<DetailedNotes> {
  QuillController _controller = QuillController.basic();

  // Stores the JSON Quill Delta
  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
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
          // menu bar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: IconButton(
              icon: FaIcon(FontAwesomeIcons.bars),
              onPressed: () {},
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
                autofocus: true,
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
                ),
              ),
              Expanded(
                child: QuillEditor.basic(
                  focusNode: FocusNode(),
                  controller: _controller,
                  config: const QuillEditorConfig(
                    autoFocus: false,
                    placeholder: 'Start writing your note here...',
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
