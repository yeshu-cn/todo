import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    if (null == taskTitle || taskTitle.isEmpty) {
      return;
    }
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
    _addTask(taskTitle);
  }

  Widget _buildTodoItem(
      String todoText, int createTime, TaskStatus status, int index) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedTime =
        formatter.format(DateTime.fromMillisecondsSinceEpoch(createTime));
    return new ListTile(
      title: new Text(todoText),
      onTap: () => _promptCompletedTodoItem(index),
      subtitle: new Text(formattedTime),
      trailing: status == TaskStatus.COMPLETE ? const Icon(Icons.done) : null,
      //leading: const Icon(Icons.check_box),
    );
  }

  // Build the whole list of todo items
  Widget _buildTodoList() {
    return new ListView.separated(
      itemCount: _taskList.length,
      separatorBuilder: (BuildContext context, int index) => new Divider(),
      itemBuilder: (context, index) {
        return _buildTodoItem(_taskList[index].title,
            _taskList[index].createTime, _taskList[index].tasksStatus, index);
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

  void _updateTaskStatus(bool completed, int index) async {
    var appDatabase = AppDatabase.get();
    Task task = _taskList[index];
    task.tasksStatus = completed ? TaskStatus.COMPLETE : TaskStatus.PENDING;
    await appDatabase.updateTask(task);
    _updateTasks();
  }

  void _promptCompletedTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Change "${_taskList[index].title}" task status'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('Not Done'),
                    onPressed: () {
                      _updateTaskStatus(false, index);
                      Navigator.of(context).pop();
                    }),
                new FlatButton(
                    child: new Text('Done'),
                    onPressed: () {
                      _updateTaskStatus(true, index);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }
}
