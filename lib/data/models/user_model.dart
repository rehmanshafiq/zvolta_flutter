import 'package:zvolta_flutter/domain/entities/user_entity.dart';

/// Data transfer object for user API responses.
/// Converts to [UserEntity] for the domain layer.
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.username,
  });

  final int id;
  final String name;
  final String email;
  final String? username;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'username': username,
      };

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      username: username,
    );
  }
}
