import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 20;

    return Column(
      children: [
        // title : My Notes
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'My Notes',
              style: GoogleFonts.inter(
                fontSize: fontSize * 1.75,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        // fiter notes on the basis of tags

        // A collection of all your notes
      ],
    );
  }
}
