import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskState createState() => new _AddTaskState();
}

class _AddTaskState extends State<AddTaskScreen> {
  String text = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Add a new task')),
        body: new TextField(
          autofocus: true,
          onSubmitted: (val) {
            Navigator.pop(context, val);
          },
          onChanged: (val) {
            text = val;
          },
          decoration: new InputDecoration(
              hintText: 'Enter something to do...',
              contentPadding: const EdgeInsets.all(16.0)),
        ),
      floatingActionButton: new FloatingActionButton(
          onPressed: (){
            Navigator.pop(context, text);
          },
          tooltip: 'Add',
          child: new Icon(Icons.done),),
    );
  }
}



