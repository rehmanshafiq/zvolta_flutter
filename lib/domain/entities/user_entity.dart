import 'package:equatable/equatable.dart';

/// Pure domain entity — no JSON or framework dependencies.
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.username,
  });

  final int id;
  final String name;
  final String email;
  final String? username;

  @override
  List<Object?> get props => [id, name, email, username];
}
