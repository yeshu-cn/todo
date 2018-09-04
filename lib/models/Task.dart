import 'package:meta/meta.dart';

class Task {
  static final tblTask = "Task";
  static final dbId = "id";
  static final dbTitle = "title";
  static final dbStatus = "status";

  String title;
  int id;
  TaskStatus tasksStatus;

  Task.create({@required this.title}) {
    this.tasksStatus = TaskStatus.PENDING;
  }

  bool operator ==(o) => o is Task && o.id == id;

  //Named constructor
  Task.update(
      {@required this.id,
      @required this.title,
      this.tasksStatus = TaskStatus.PENDING});

  //Initializer list
  Task.fromMap(Map<String, dynamic> map)
      : this.update(
          id: map[dbId],
          title: map[dbTitle],
          tasksStatus: TaskStatus.values[map[dbStatus]],
        );
}

enum TaskStatus {
  PENDING,
  COMPLETE,
}
