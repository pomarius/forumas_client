part of 'topic_bloc.dart';

abstract class TopicEvent extends Equatable {
  const TopicEvent();

  @override
  List<Object?> get props => [];
}

class TopicCreate extends TopicEvent {
  final Editable editable;

  const TopicCreate({required this.editable});

  @override
  List<Object> get props => [editable];
}

class TopicLoad extends TopicEvent {}

class TopicSort extends TopicEvent {
  final String? userId;

  const TopicSort({this.userId});

  @override
  List<Object?> get props => [userId];
}

class TopicUpdate extends TopicEvent {
  final Topic topic;

  const TopicUpdate({required this.topic});

  @override
  List<Object> get props => [topic];
}

class TopicDelete extends TopicEvent {
  final Topic topic;

  const TopicDelete({required this.topic});

  @override
  List<Object> get props => [topic];
}

class TopicAddModerator extends TopicEvent {
  final Topic topic;
  final String username;

  const TopicAddModerator({required this.topic, required this.username});

  @override
  List<Object> get props => [topic, username];
}

class TopicBlockUser extends TopicEvent {
  final Topic topic;
  final String username;

  const TopicBlockUser({required this.topic, required this.username});

  @override
  List<Object> get props => [topic, username];
}
