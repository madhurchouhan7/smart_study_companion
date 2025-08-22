import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_study_companion/todo/controller/todo_controller.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({
    super.key,
    required this.title,
    this.isDone = false,
    required this.index,
  });
  final bool isDone;
  final String title;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 1.5),
        ),
        child: Row(
          children: [
            // check box
            Checkbox(
              activeColor: Colors.grey[800],
              value: isDone,
              onChanged: (value) {
                // toggle todo
                Get.find<TodoController>().toggleTodo(index, context);
              },
            ),

            // title
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  color: isDone ? Colors.grey : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // delete button
            IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () {
                // delete todo
                Get.find<TodoController>().deleteTodo(index, context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
