part of 'comment_bloc.dart';

enum CommentLoadingStatus { create, load, update, delete, upvote, downvote }

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object?> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {
  final CommentLoadingStatus status;
  final String? id;

  const CommentLoading({required this.status, this.id});

  @override
  List<Object?> get props => [status, id];
}

class CommentLoaded extends CommentState {
  final List<Comment> comments;

  const CommentLoaded({required this.comments});

  @override
  List<Object> get props => [comments];
}

class CommentFailure extends CommentState {
  final String message;

  const CommentFailure({required this.message});

  @override
  List<Object> get props => [message];
}
