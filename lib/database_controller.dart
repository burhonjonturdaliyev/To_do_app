// ignore: camel_case_types
// ignore_for_file: unused_field, unused_local_variable, body_might_complete_normally_nullable
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/task.dart';

// ignore: camel_case_types
class database_controller {
  static final database_controller instance = database_controller.instance;

  static Database? _db;

  database_controller._instance();
  String taskTable = "task_table";
  String colId = "id";
  String colTitle = "title";
  String colDate = 'date';
  String colPriority = "priority";
  String colStatus = "status";

  Future<Database?> get db async => _db ??= await _initdb();
  Future<Database> _initdb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}todo_list.db";
    final todoListdb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListdb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $taskTable($colId INTEGER PRIMARY KEY AUTOINCREAMENT, $colTitle TEXT, $colDate TEXT, $colPriority TEXT, $colStatus INTEGER");
  }

  Future<List<Map<String, dynamic>>?> getTaskMapList() async {
    Database? db = await this.db;
    final List<Map<String, Object?>>? result = await db?.query(taskTable);
    return result;
  }

  Future<List<Task>?> getTaskList() async {
    final List<Map<String, dynamic>>? taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList?.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });
    return taskList;
  }

  Future<int?> insertTask(Task task) async {
    Database? db = await this.db;
    final int? result = await db?.insert(taskTable, task.toMap());
    return result;
  }
}
