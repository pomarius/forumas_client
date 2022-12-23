import 'editable.dart';
import 'user.dart';

class Topic extends Editable {
  final String id;
  final List<User> moderators;
  final List<User> blocked;

  const Topic({
    required this.id,
    required super.name,
    required super.description,
    required this.moderators,
    required this.blocked,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      moderators: List<User>.from(json['moderators'].map((moderator) => User.fromJson(moderator['user'])).toList()),
      blocked: List<User>.from(json['blocked'].map((blocked) => User.fromJson(blocked['user'])).toList()),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }

  Topic copyWith(
    String? name,
    String? description,
  ) {
    return Topic(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      moderators: moderators,
      blocked: blocked,
    );
  }

  @override
  List<Object?> get props => [id, name, description, moderators, blocked];
}
