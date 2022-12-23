part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class PostReset extends PostEvent {}

class PostSort extends PostEvent {
  final String? userId;

  const PostSort({this.userId});

  @override
  List<Object?> get props => [userId];
}

class PostLoad extends PostEvent {
  final String topicId;
  final String? userId;

  const PostLoad({required this.topicId, this.userId});

  @override
  List<Object?> get props => [topicId, userId];
}

class PostCreate extends PostEvent {
  final Post post;
  final String topicId;

  const PostCreate({required this.post, required this.topicId});

  @override
  List<Object> get props => [post, topicId];
}

class PostUpdate extends PostEvent {
  final Post post;

  const PostUpdate({required this.post});

  @override
  List<Object> get props => [post];
}

class PostDelete extends PostEvent {
  final Post post;

  const PostDelete({required this.post});

  @override
  List<Object> get props => [post];
}

class PostUpvote extends PostEvent {
  final Post post;
  final String userId;

  const PostUpvote({required this.post, required this.userId});

  @override
  List<Object> get props => [post, userId];
}

class PostDownvote extends PostEvent {
  final Post post;
  final String userId;

  const PostDownvote({required this.post, required this.userId});

  @override
  List<Object> get props => [post, userId];
}
