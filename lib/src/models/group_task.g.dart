// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupTask _$GroupTaskFromJson(Map<String, dynamic> json) => GroupTask(
  id: json['_id'] as String,
  owner: User.fromJson(json['owner'] as Map<String, dynamic>),
  projectName: json['projectName'] as String,
  projectDescription: json['projectDescription'] as String,
);

Map<String, dynamic> _$GroupTaskToJson(GroupTask instance) => <String, dynamic>{
  '_id': instance.id,
  'owner': instance.owner.toJson(),
  'projectName': instance.projectName,
  'projectDescription': instance.projectDescription,
};
