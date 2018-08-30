import 'package:flutter/material.dart';
import 'package:todo/pages/add_task.dart';
import 'package:todo/pages/todo_list.dart';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Todo List',
        home: new TodoList(),
        routes: <String, WidgetBuilder> {
        '/addTask': (BuildContext context) => AddTaskScreen(),
      });
  }
}
