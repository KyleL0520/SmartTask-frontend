import 'package:frontend/src/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group_task.g.dart';

@JsonSerializable(explicitToJson: true)
class GroupTask {
  @JsonKey(name: '_id')
  final String id;
  final User owner;
  String projectName;
  String projectDescription;

  GroupTask({
    required this.id,
    required this.owner,
    required this.projectName,
    required this.projectDescription,
  });

  factory GroupTask.fromJson(Map<String, dynamic> json) =>
      _$GroupTaskFromJson(json);

  Map<String, dynamic> toJson() => _$GroupTaskToJson(this);
}
