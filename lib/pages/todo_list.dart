import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/db/AppDatabase.dart';
import 'package:todo/models/Task.dart';
import 'package:todo/pages/add_task.dart';


class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<Task> _taskList = new List();


	@override
	void initState() {
		_updateTasks();
		super.initState();
	}

	void _addTask(String taskTitle) async {
  	AppDatabase appDatabase = AppDatabase.get();
  	await appDatabase.insertTask(taskTitle);
  	_updateTasks();
	}

	void _updateTasks() async {
		AppDatabase appDatabase = AppDatabase.get();
		var list = await appDatabase.getTaskList();
		setState(() {
			_taskList.clear();
			_taskList.addAll(list);
		});
	}

  void _pushAddTodoScreen() async{
//    // Push this page onto the stack
//    Navigator.of(context).push(
//        // MaterialPageRoute will automatically animate the screen entry, as well
//        // as adding a back button to close it
//        new MaterialPageRoute(builder: (context) => new AddTaskScreen()));
    final taskTitle = await Navigator.of(context).pushNamed('/addTask');
    _addTask(taskTitle);
  }

  Widget _buildTodoItem(String todoText, int index) {
    return new ListTile(
        title: new Text(todoText), onTap: () => _promptRemoveTodoItem(index));
  }

  // Build the whole list of todo items
  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todo items we have. So, we need to check the index is OK.
        if (index < _taskList.length) {
          return _buildTodoItem(_taskList[index].title, index);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Todo List')),
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: 'Add task',
        child: new Icon(Icons.add),
      ),
    );
  }

  void _removeTodoItem(int index) async{
		var appDatabase = AppDatabase.get();
		await appDatabase.deleteTask(_taskList[index].id);
    _updateTasks();
  }

  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Mark "${_taskList[index]}" as done?'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('CANCEL'),
                    onPressed: () => Navigator.of(context).pop()),
                new FlatButton(
                    child: new Text('MARK AS DONE'),
                    onPressed: () {
                      _removeTodoItem(index);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }
}
