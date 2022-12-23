import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String userId;
  final String postId;
  final String content;
  final int upvotes;
  final int downvotes;
  final List<String> upvotedUsers;
  final List<String> downvotedUsers;

  const Comment({
    required this.id,
    required this.userId,
    required this.postId,
    required this.content,
    required this.upvotes,
    required this.downvotes,
    required this.upvotedUsers,
    required this.downvotedUsers,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['userId'],
      postId: json['postId'],
      content: json['content'],
      upvotes: json['_count']['userUpvotedComments'],
      downvotes: json['_count']['userDownvotedComments'],
      upvotedUsers: List<String>.from(json['userUpvotedComments'].map((vote) => vote['userId']).toList()),
      downvotedUsers: List<String>.from(json['userDownvotedComments'].map((vote) => vote['userId']).toList()),
    );
  }

  Comment copyWith(
    String? content,
  ) {
    return Comment(
      id: id,
      content: content ?? this.content,
      downvotes: downvotes,
      postId: postId,
      upvotes: upvotes,
      userId: userId,
      upvotedUsers: upvotedUsers,
      downvotedUsers: downvotedUsers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }

  @override
  List<Object?> get props => [id, userId, postId, content, upvotes, downvotes, upvotedUsers, downvotedUsers];
}
