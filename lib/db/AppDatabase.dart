import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/Task.dart';

class AppDatabase {
  static final AppDatabase _appDatabase = new AppDatabase._internal();

  AppDatabase._internal();

  static AppDatabase get() {
    return _appDatabase;
  }

  Database _database;
  bool didInit = false;

  Future<Database> _getDb() async {
    if (!didInit) {
      await _init();
    }

    return _database;
  }

  Future _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "todo.db");
    _database = await openDatabase(path, version: 2,
        onCreate: (Database db, int version) async {
      await _createTaskTable(db);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      await db.execute("DROP TABLE ${Task.tblTask}");
      await _createTaskTable(db);
    });

    didInit = true;
  }

  Future _createTaskTable(Database db) {
    return db.execute("CREATE TABLE ${Task.tblTask} ("
        "${Task.dbId} INTEGER PRIMARY KEY AUTOINCREMENT, "
        "${Task.dbCreateTime} INTEGER, "
        "${Task.dbTitle} TEXT, "
        "${Task.dbStatus} LONG );");
  }

  Future<List<Task>> getTaskList() async {
    var db = await _getDb();
    //select * from task where status = taskStatus;
    //$variableName (or ${expression})
    var result = await db.rawQuery("SELECT * FROM ${Task.tblTask}");
    return bindData(result);
  }

  List<Task> bindData(List<Map<String, dynamic>> result) {
    List<Task> tasks = new List();
    for (Map<String, dynamic> item in result) {
      tasks.add(Task.fromMap(item));
    }

    return tasks;
  }

  Future updateTask(Task task) async {
    var db = await _getDb();
    return db.rawUpdate(
        "UPDATE ${Task.tblTask} SET ${Task.dbTitle} = ?, ${Task.dbStatus} = ? , ${Task.dbCreateTime} = ? WHERE ${Task.dbId} = ?",
        [task.title, task.tasksStatus.index, task.createTime, task.id]);
  }

  Future deleteTask(int taskId) async {
    var db = await _getDb();
    return db.transaction((txn) async {
      await txn.rawDelete(
          "DELETE FROM ${Task.tblTask} WHERE ${Task.dbId} = $taskId;");
    });
  }

  Future insertTask(String title) async {
    var db = await _getDb();
    int createTime = new DateTime.now().millisecondsSinceEpoch;
    return db.rawInsert(
        'INSERT INTO ${Task.tblTask} (${Task.dbTitle}, ${Task.dbStatus}, ${Task.dbCreateTime}) VALUES ("$title", ${TaskStatus.PENDING.index}, $createTime);');
  }
}
