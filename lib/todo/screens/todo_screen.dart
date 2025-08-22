import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_study_companion/todo/config/quptes.dart';
import 'package:smart_study_companion/todo/controller/todo_controller.dart';
import 'package:smart_study_companion/todo/widgets/todo_tile.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 20;

    String getRandomQuote() {
      final randomIndex = Random().nextInt(Quotes.quotes.length);
      return Quotes.quotes[randomIndex];
    }

    final TodoController todoController = Get.put(TodoController());
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Your To Do',
                style: GoogleFonts.inter(
                  fontSize: fontSize * 1.75,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // text form field for todo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // text form field for todo
              SizedBox(
                width: screenWidth * 0.7,
                child: TextFormField(
                  onSaved: (newValue) {
                    todoController.addTodo(
                      todoController.titleController.text,
                      context,
                    );
                  },
                  controller: todoController.titleController,
                  style: GoogleFonts.inter(),
                  decoration: InputDecoration(
                    labelText: 'Add a new task',
                    labelStyle: GoogleFonts.inter(),
                    border: null,
                  ),
                ),
              ),

              // create button
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[800],
                ),
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.plus, color: Colors.white),
                  onPressed: () {
                    // add todo
                    todoController.addTodo(
                      todoController.titleController.text,
                      context,
                    );
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // to-do list
          Expanded(
            child: Obx(() {
              if (todoController.todos.isEmpty) {
                return Center(
                  child: Text('No tasks available', style: GoogleFonts.inter()),
                );
              }
              return ListView.builder(
                itemCount: todoController.todos.length,
                itemBuilder: (context, index) {
                  return TodoTile(
                    index: index,
                    title: todoController.todos[index].title,
                    isDone: todoController.todos[index].isDone,
                  );
                },
              );
            }),
          ),

          SizedBox(height: 20),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // remaining todo
              Obx(
                () => Text(
                  'Your remaining tasks : ${todoController.remainingTodos}',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),

              SizedBox(height: 15),
              // motivating quote
              Text(
                getRandomQuote(),
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
