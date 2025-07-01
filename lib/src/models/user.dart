import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  @JsonKey(name: '_id')
  final String uid;
  String username;
  final String email;
  String avatarPhoto;

  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.avatarPhoto,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
