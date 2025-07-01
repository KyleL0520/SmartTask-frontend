// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  id: json['_id'] as String,
  user: json['user'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  category:
      json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
  deadlinesDate: json['deadlinesDate'] as String,
  deadlinesTime: json['deadlinesTime'] as String,
  priority: json['priority'] as String?,
  reminderDate: json['reminderDate'] as String?,
  reminderTime: json['reminderTime'] as String?,
  status: json['status'] as String,
  groupTask:
      json['groupTask'] == null
          ? null
          : GroupTask.fromJson(json['groupTask'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  '_id': instance.id,
  'user': instance.user,
  'title': instance.title,
  'description': instance.description,
  'category': instance.category?.toJson(),
  'deadlinesDate': instance.deadlinesDate,
  'deadlinesTime': instance.deadlinesTime,
  'priority': instance.priority,
  'reminderDate': instance.reminderDate,
  'reminderTime': instance.reminderTime,
  'status': instance.status,
  'groupTask': instance.groupTask?.toJson(),
  'createdAt': instance.createdAt.toIso8601String(),
};
