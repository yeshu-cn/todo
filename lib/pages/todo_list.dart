import 'package:flutter/material.dart';
import 'package:todo/db/AppDatabase.dart';
import 'package:todo/models/Task.dart';
import 'package:todo/utils/app_util.dart';

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

  void _pushAddTodoScreen() async {
//    // Push this page onto the stack
//    Navigator.of(context).push(
//        // MaterialPageRoute will automatically animate the screen entry, as well
//        // as adding a back button to close it
//        new MaterialPageRoute(builder: (context) => new AddTaskScreen()));
    	var taskTitle = await Navigator.of(context).pushNamed('/addTask');
    	if (null != taskTitle) {
				_addTask(taskTitle);
			}
  }

  Widget _buildTodoItem(String todoText, int index) {
    return new ListTile(
        title: new Text(todoText), onTap: () => _promptRemoveTodoItem(index));
  }

  // Build the whole list of todo items
  Widget _buildTodoList() {
    return new ListView.separated(
      itemCount: _taskList.length,
      separatorBuilder: (BuildContext context, int index) => new Divider(),
      itemBuilder: (context, index) {
        return _buildTodoItem(_taskList[index].title, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Todo List')),
      body: _taskList.isEmpty ? emptyView("No task") : _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: 'Add task',
        child: new Icon(Icons.add),
      ),
    );
  }

  void _removeTodoItem(int index) async {
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
