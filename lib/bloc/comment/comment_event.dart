part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class CommentLoad extends CommentEvent {
  final String postId;

  const CommentLoad({required this.postId});

  @override
  List<Object> get props => [postId];
}

class CommentCreate extends CommentEvent {
  final String postId;
  final String content;

  const CommentCreate({required this.postId, required this.content});

  @override
  List<Object> get props => [postId, content];
}

class CommentUpdate extends CommentEvent {
  final Comment comment;

  const CommentUpdate({required this.comment});

  @override
  List<Object> get props => [comment];
}

class CommentDelete extends CommentEvent {
  final Comment comment;
  final String userId;

  const CommentDelete({required this.comment, required this.userId});

  @override
  List<Object> get props => [comment, userId];
}

class CommentUpvote extends CommentEvent {
  final Comment comment;
  final String userId;

  const CommentUpvote({required this.comment, required this.userId});

  @override
  List<Object> get props => [comment, userId];
}

class CommentDownvote extends CommentEvent {
  final Comment comment;
  final String userId;

  const CommentDownvote({required this.comment, required this.userId});

  @override
  List<Object> get props => [comment, userId];
}
