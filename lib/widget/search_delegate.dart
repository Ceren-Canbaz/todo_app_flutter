import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/widget/task_list_item.dart';

import '../model/task.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTasks;

  CustomSearchDelegate({required this.allTasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 24,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filtredList = allTasks
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filtredList.length > 0
        ? ListView.builder(
            itemBuilder: (context, index) {
              var currentTask = filtredList[index];
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
                  onDismissed: (direction) async {
                    filtredList.removeAt(index);
                    await locator<LocalStorage>()
                        .deleteTask(task: filtredList[index]);
                  },
                  child: TaskItem(
                    task: currentTask,
                  ));
            },
            itemCount: filtredList.length,
          )
        : Center(
            child: const Text('no_match').tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Container();
  }
}
