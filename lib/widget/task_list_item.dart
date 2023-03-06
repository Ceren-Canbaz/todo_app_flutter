// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';

import '../model/task.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TextEditingController _controller = TextEditingController();
  late LocalStorage localStorage;
  @override
  void initState() {
    super.initState();
    localStorage = locator<LocalStorage>();
    _controller.text = widget.task.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 10)
          ]),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            localStorage.updateTask(task: widget.task);
            setState(() {});
          },
          child: Container(
            decoration: BoxDecoration(
                color: widget.task.isCompleted ? Colors.green : Colors.white,
                border: Border.all(color: Colors.grey, width: 0.8),
                shape: BoxShape.circle),
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                controller: _controller,
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction.go,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    widget.task.name = value;
                    localStorage.updateTask(task: widget.task);
                  }
                },
              ),
        subtitle: Text(widget.task.createdDate.toString()),
        trailing: Text(
          DateFormat('hh:mm a').format(widget.task.createdDate),
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
