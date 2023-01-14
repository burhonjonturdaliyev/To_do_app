// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_field, unused_element, unused_local_variable, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/database_controller.dart';
import 'package:to_do_app/task.dart';

// ignore: camel_case_types
class Add_task_screen extends StatefulWidget {
  const Add_task_screen({super.key});

  @override
  State<Add_task_screen> createState() => _Add_task_screenState();
}

// ignore: camel_case_types
class _Add_task_screenState extends State<Add_task_screen> {
  final _formKey = GlobalKey<FormState>();
  String? _title = "";
  String? _priority;
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat("MMM dd, yyyy");
  final List<String> _priorities = ["Low", "Medium", "High"];

  _handleDatePicker() async {
    final date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2022),
        lastDate: DateTime(2025));
    if (date != _date) {
      setState(() {
        _date = date as DateTime;
      });
      _dateController.text = _dateFormat.format(date!);
    }
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Task task = Task(title: _title, date: _date, priority: _priority);
      database_controller.instance.insertTask(task);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
              child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: "Title"),
                      onSaved: (newValue) => _title = newValue,
                      validator: (value) => value!.trim().isEmpty
                          ? "Please,  fild the title"
                          : null,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: _dateController,
                      onTap: _handleDatePicker,
                      validator: (value) => value!.trim().isEmpty
                          ? "Please,  fild the date"
                          : null,
                      decoration: InputDecoration(
                        labelText: "Date",
                      ),
                    ),
                    DropdownButtonFormField(
                      validator: (value) => _priority == null
                          ? "Please,  select a priority"
                          : null,
                      icon: Icon(Icons.arrow_downward),
                      decoration: InputDecoration(labelText: "Priority"),
                      onChanged: (value) {
                        setState(() {
                          _priority = value!;
                        });
                      },
                      items: _priorities.map((e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          child: Text(
                            e,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      value: _priority,
                    ),
                  ],
                ),
              ),
              TextButton(onPressed: _submit, child: Text("Save"))
            ],
          )),
        ),
      ),
    );
  }
}
