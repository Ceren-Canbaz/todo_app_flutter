import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/widget/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  @override
  void initState() {
    super.initState();
    _allTasks = <Task>[];
    _allTasks.add(Task.create(name: 'deneme', createdDate: DateTime.now()));
    _allTasks.add(Task.create(name: 'deneme', createdDate: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              _showButtomAddTaskSheet(context);
            },
            child: const Text(
              'To do',
              style: TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  _showButtomAddTaskSheet(context);
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ))
          ],
        ),
        body: _allTasks.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, index) {
                  var currentTask = _allTasks[index];
                  return Dismissible(
                      key: Key(currentTask.id),
                      background: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(Icons.delete),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                      onDismissed: (direction) {
                        _allTasks.removeAt(index);
                        setState(() {});
                      },
                      child: TaskItem(
                        task: currentTask,
                      ));
                },
                itemCount: _allTasks.length,
              )
            : Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Add Task',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _showButtomAddTaskSheet(context);
                      },
                    )
                  ],
                ),
              ));
  }

  void _showButtomAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ListTile(
              title: TextField(
                decoration: InputDecoration(hintText: 'Add Task'),
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                  DatePicker.showTimePicker(
                    context,
                    showSecondsColumn: false,
                    onConfirm: (time) {
                      var _newTask =
                          Task.create(name: value, createdDate: time);
                      _allTasks.add(_newTask);
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          );
        });
  }
}