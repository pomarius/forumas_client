part of 'post_bloc.dart';

enum PostLoadingStatus { create, load, update, delete, upvote, downvote }

abstract class PostState extends Equatable {
  final String? topicId;

  const PostState({this.topicId});

  @override
  List<Object?> get props => [topicId];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {
  final PostLoadingStatus status;
  final String? id;

  const PostLoading({required super.topicId, required this.status, this.id});

  @override
  List<Object?> get props => [topicId, status, id];
}

class PostLoaded extends PostState {
  final List<Post> posts;

  const PostLoaded({required super.topicId, required this.posts});

  @override
  List<Object?> get props => [topicId, posts];
}

class PostFailure extends PostState {
  final String message;

  const PostFailure({required super.topicId, required this.message});

  @override
  List<Object?> get props => [topicId, message];
}
