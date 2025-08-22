import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:smart_study_companion/todo/model/todo.dart';

class TodoController extends GetxController {
  // This controller will manage the state of the todo list
  var todos = <Todo>[].obs;
  final titleController = TextEditingController();
  Box<Todo> todoBox = Hive.box<Todo>('todosBox');

  @override
  void onInit() {
    super.onInit();
    initializeBox();
  }

  int get remainingTodos {
    return todos.where((todo) => !todo.isDone).length;
  }

  Future<void> initializeBox() async {
    try {
      // Check if box is already open, if not open it
      if (Hive.isBoxOpen('todosBox')) {
        todoBox = Hive.box<Todo>('todosBox');
      } else {
        todoBox = await Hive.openBox<Todo>('todosBox');
      }
      fetchTodo();
    } catch (e) {
      print('Error initializing notes box: $e');
    }
  }

  void fetchTodo() {
    if (todoBox.isOpen) {
      todos.value = todoBox.values.toList();
    }
  }

  void addTodo(String title, BuildContext context) {
    if (title.isNotEmpty) {
      todos.add(Todo(title: title));
      todoBox.add(Todo(title: title));
      titleController.clear(); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task added successfully ✅'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );// Clear the text field after adding
    }
  }

  void toggleTodo(int index, BuildContext context) {
    if (index >= 0 && index < todos.length) {
      todos[index].isDone = !todos[index].isDone;
      todoBox.putAt(index, todos[index]);
      todos.refresh();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task Completed ✅'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      ); // Refresh the observable list
    }
  }

  void deleteTodo(int index, BuildContext context) {
    if (index >= 0 && index < todos.length) {
      todos.removeAt(index);
      todoBox.deleteAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task deleted successfully 🗑️'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
