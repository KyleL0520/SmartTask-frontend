import 'package:frontend/src/models/category.dart';
import 'package:frontend/src/models/group_task.dart';
import 'package:frontend/src/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable(explicitToJson: true)
class Task {
  @JsonKey(name: '_id')
  final String id;
  final User user;
  String title;
  String description;
  Category? category;
  String deadlinesDate;
  String deadlinesTime;
  String? priority;
  String? reminderDate;
  String? reminderTime;
  String status;
  bool isExpired;
  bool isApproved;
  bool? isReminderSent;
  GroupTask? groupTask;

  Task({
    required this.id,
    required this.user,
    required this.title,
    required this.description,
    this.category,
    required this.deadlinesDate,
    required this.deadlinesTime,
    this.priority,
    this.reminderDate,
    this.reminderTime,
    this.status = 'Pending',
    this.isExpired = false,
    this.isApproved = false,
    this.isReminderSent = false,
    this.groupTask,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
