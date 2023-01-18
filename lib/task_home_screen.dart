// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unused_field

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/add_task_screen.dart';
import 'package:to_do_app/database_controller.dart';
import 'package:to_do_app/task.dart';

// ignore: camel_case_types
class Task_Home_screen extends StatefulWidget {
  const Task_Home_screen({super.key});

  @override
  State<Task_Home_screen> createState() => _Task_Home_screenState();
}

// ignore: camel_case_types
class _Task_Home_screenState extends State<Task_Home_screen> {
  final DateFormat _dateFormat = DateFormat("MMM dd, yyyy");
  late Future<List<Task>?> _taskList;

  Widget _builditems(Task task) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.amber),
        child: ListTile(
          title: Text(task.title!),
          subtitle: Text(_dateFormat.format(task.date)),
          trailing: Checkbox(
            value: task.status == 0 ? false : true,
            onChanged: (value) {},
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = database_controller.instance.getTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Add_task_screen()));
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
      body: Container(
        child: FutureBuilder(
          future: _taskList,
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  // ignore: unnecessary_null_comparison
                  if (index == null) {
                    return Container(
                      child: Text(
                        "My tasks",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    );
                  } else {
                    return _builditems(snapshot.data![index + 1]);
                  }
                });
          },
        ),
      ),
    );
  }
}
