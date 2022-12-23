part of 'topic_bloc.dart';

enum TopicLoadingStatus { create, load, update, delete, moderator, block }

abstract class TopicState extends Equatable {
  const TopicState();

  @override
  List<Object?> get props => [];
}

class TopicInitial extends TopicState {}

class TopicLoading extends TopicState {
  final TopicLoadingStatus status;
  final String? id;

  const TopicLoading({required this.status, this.id});

  @override
  List<Object?> get props => [status, id];
}

class TopicLoaded extends TopicState {
  final List<Topic> topics;

  const TopicLoaded({required this.topics});

  @override
  List<Object> get props => [topics];
}

class TopicFailure extends TopicState {
  final String message;

  const TopicFailure({required this.message});

  @override
  List<Object> get props => [message];
}
