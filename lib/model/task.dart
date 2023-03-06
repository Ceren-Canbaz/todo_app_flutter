import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  final DateTime createdDate;

  @HiveField(3)
  bool isCompleted;

  Task(
      {required this.id,
      required this.name,
      required this.createdDate,
      required this.isCompleted});

  factory Task.create({
    required String name,
    required DateTime createdDate,
  }) {
    return Task(
        id: const Uuid().v1(),
        name: name,
        createdDate: createdDate,
        isCompleted: false);
  }
}
