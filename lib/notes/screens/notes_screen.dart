import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_study_companion/notes/controller/notes_controller.dart';
import 'package:smart_study_companion/notes/widgets/notes_tile.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 20;
    final notesController = Get.put<NotesController>(NotesController());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              if (notesController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (notesController.notes.isEmpty) {
                return Center(
                  child: Text(
                    'No notes yet. Tap + to create your first note!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: fontSize,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: notesController.notes.length,
                itemBuilder: (context, index) {
                  final note = notesController.notes[index];
                  return NotesTile(note: note, index: index);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
