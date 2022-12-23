import 'editable.dart';

class Post extends Editable {
  final String id;
  final String userId;
  final String topicId;
  final int upvotes;
  final int downvotes;
  final List<String> upvotedUsers;
  final List<String> downvotedUsers;

  const Post({
    required this.id,
    required this.userId,
    required this.topicId,
    required super.name,
    required super.description,
    required this.upvotes,
    required this.downvotes,
    required this.upvotedUsers,
    required this.downvotedUsers,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      topicId: json['topicId'],
      name: json['name'],
      description: json['content'],
      upvotes: json['_count']['userUpvotedPosts'],
      downvotes: json['_count']['userDownvotedPosts'],
      upvotedUsers: List<String>.from(json['userUpvotedPosts'].map((vote) => vote['userId']).toList()),
      downvotedUsers: List<String>.from(json['userDownvotedPosts'].map((vote) => vote['userId']).toList()),
    );
  }

  Post copyWith(
    String? name,
    String? description,
  ) {
    return Post(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      downvotes: downvotes,
      topicId: topicId,
      upvotes: upvotes,
      userId: userId,
      upvotedUsers: upvotedUsers,
      downvotedUsers: downvotedUsers,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'content': description,
    };
  }

  @override
  List<Object?> get props => [id, userId, topicId, name, description, upvotes, downvotes, upvotedUsers, downvotedUsers];
}
