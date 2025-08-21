import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_study_companion/notes/screens/detailed_notes.dart';
import 'package:smart_study_companion/notes/model/note.dart';

class NotesTile extends StatelessWidget {
  const NotesTile({super.key, required this.note, required this.index});
  final Note note;
  final int index;

  @override
  Widget build(BuildContext context) {
    // get screen width
    final screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        // Handle note tap - pass the entire note object and index for editing
        Get.to(
          () => DetailedNotes(),
          arguments: {'note': note, 'index': index, 'isEditing': true},
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(16),
        ),
        width: screenWidth / 2.1,
        child: Column(
          children: [
            // title
            Text(
              note.title ?? 'Untitled',
              overflow: TextOverflow.clip,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            SizedBox(height: 8),
            // content
            Flexible(
              child: Text(
                note.contentJson.toString(),
                textAlign: TextAlign.center,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
