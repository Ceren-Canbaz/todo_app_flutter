import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/widget/search_delegate.dart';
import 'package:todo_app/widget/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage localStorage;
  @override
  void initState() {
    super.initState();
    localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    getAllTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              _showButtomAddTaskSheet();
            },
            child: const Text(
              'title',
              style: TextStyle(color: Colors.black),
            ).tr(),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _showSearchPage();
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  _showButtomAddTaskSheet();
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
                        localStorage.deleteTask(task: currentTask);
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
                    const Text('empty_task_list',
                            style: TextStyle(color: Colors.black, fontSize: 18))
                        .tr(),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _showButtomAddTaskSheet();
                      },
                    )
                  ],
                ),
              ));
  }

  void _showButtomAddTaskSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ListTile(
              title: TextField(
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(hintText: 'add_task'.tr()),
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                  DatePicker.showTimePicker(
                    context,
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      // ignore: no_leading_underscores_for_local_identifiers
                      var _newTask =
                          Task.create(name: value, createdDate: time);
                      await localStorage.addTask(task: _newTask);
                      getAllTask();

                      setState(() {});
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  void getAllTask() async {
    _allTasks = await localStorage.getAllTask();
    setState(() {});
  }

  void _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTasks: _allTasks));
  }
}
