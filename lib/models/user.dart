import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;

  const User({required this.id, required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
    };
  }

  @override
  List<Object?> get props => [id, username];
}
