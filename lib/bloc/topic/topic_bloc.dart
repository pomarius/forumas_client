import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/editable.dart';
import '../../models/topic.dart';
import '../../data/repositories/topic_repository.dart';

part 'topic_event.dart';
part 'topic_state.dart';

class TopicBloc extends Bloc<TopicEvent, TopicState> {
  final TopicRepository _topicRepository;

  TopicBloc(this._topicRepository) : super(TopicInitial()) {
    on<TopicCreate>(_onTopicCreate);
    on<TopicLoad>(_onTopicLoad);
    on<TopicSort>(_onTopicSort);
    on<TopicUpdate>(_onTopicUpdate);
    on<TopicDelete>(_onTopicDelete);
    on<TopicAddModerator>(_onTopicAddModerator);
    on<TopicBlockUser>(_onTopicBlockUser);

    add(TopicLoad());
  }

  Future<void> _onTopicCreate(TopicCreate event, Emitter<TopicState> emit) async {
    if (state is TopicLoaded) {
      final List<Topic> topics = [...(state as TopicLoaded).topics];
      emit(const TopicLoading(status: TopicLoadingStatus.create));

      try {
        final Topic topic = await _topicRepository.createTopic(event.editable);
        topics.insert(0, topic);

        emit(TopicLoaded(topics: topics));
      } catch (error) {
        emit(TopicFailure(message: error.toString()));
      }
    }
  }

  Future<void> _onTopicLoad(TopicLoad event, Emitter<TopicState> emit) async {
    emit(const TopicLoading(status: TopicLoadingStatus.load));
    try {
      final List<Topic> topics = await _topicRepository.getAllTopics();
      topics.sort((a, b) => a.name.compareTo(b.name));
      emit(TopicLoaded(topics: topics));
    } catch (error) {
      emit(TopicFailure(message: error.toString()));
    }
  }

  Future<void> _onTopicSort(TopicSort event, Emitter<TopicState> emit) async {
    if (state is TopicLoaded) {
      final List<Topic> topics = [...(state as TopicLoaded).topics];

      if (event.userId != null) {
        topics.sort((a, b) {
          final List<String> aModeratorIds = a.moderators.map((e) => e.id).toList();
          final List<String> bModeratorIds = b.moderators.map((e) => e.id).toList();

          if (aModeratorIds.contains(event.userId) && !bModeratorIds.contains(event.userId)) {
            return -1;
          } else if (!aModeratorIds.contains(event.userId) && bModeratorIds.contains(event.userId)) {
            return 1;
          } else {
            return a.name.compareTo(b.name);
          }
        });
      } else {
        topics.sort((a, b) => a.name.compareTo(b.name));
      }

      emit(TopicLoaded(topics: topics));
    }
  }

  Future<void> _onTopicUpdate(TopicUpdate event, Emitter<TopicState> emit) async {
    if (state is TopicLoaded) {
      final List<Topic> topics = (state as TopicLoaded).topics;
      emit(TopicLoading(status: TopicLoadingStatus.update, id: event.topic.id));
      try {
        final Topic topic = await _topicRepository.updateTopic(event.topic);

        final List<Topic> newTopics = [];
        for (int i = 0; i < topics.length; i++) {
          if (topics[i].id == topic.id) {
            newTopics.add(topic);
          } else {
            newTopics.add(topics[i]);
          }
        }

        emit(TopicLoaded(topics: newTopics));
      } catch (error) {
        emit(TopicFailure(message: error.toString()));
      }
    }
  }

  Future<void> _onTopicDelete(TopicDelete event, Emitter<TopicState> emit) async {
    if (state is TopicLoaded) {
      final List<Topic> topics = [...(state as TopicLoaded).topics];
      emit(TopicLoading(status: TopicLoadingStatus.delete, id: event.topic.id));

      try {
        await _topicRepository.deleteTopic(event.topic);
        topics.remove(event.topic);
        emit(TopicLoaded(topics: topics));
      } catch (error) {
        emit(TopicFailure(message: error.toString()));
      }
    }
  }

  Future<void> _onTopicAddModerator(TopicAddModerator event, Emitter<TopicState> emit) async {
    if (state is TopicLoaded) {
      final List<Topic> topics = [...(state as TopicLoaded).topics];
      emit(TopicLoading(status: TopicLoadingStatus.moderator, id: event.topic.id));

      try {
        final Topic topic = await _topicRepository.addModerator(event.topic, event.username);

        final List<Topic> newTopics = [];
        for (int i = 0; i < topics.length; i++) {
          if (topics[i].id == topic.id) {
            newTopics.add(topic);
          } else {
            newTopics.add(topics[i]);
          }
        }

        emit(TopicLoaded(topics: newTopics));
      } catch (error) {
        emit(TopicFailure(message: error.toString()));
      }
    }
  }

  Future<void> _onTopicBlockUser(TopicBlockUser event, Emitter<TopicState> emit) async {
    if (state is TopicLoaded) {
      final List<Topic> topics = [...(state as TopicLoaded).topics];
      emit(TopicLoading(status: TopicLoadingStatus.block, id: event.topic.id));

      try {
        final Topic topic = await _topicRepository.blockUser(event.topic, event.username);

        final List<Topic> newTopics = [];
        for (int i = 0; i < topics.length; i++) {
          if (topics[i].id == topic.id) {
            newTopics.add(topic);
          } else {
            newTopics.add(topics[i]);
          }
        }

        emit(TopicLoaded(topics: newTopics));
      } catch (error) {
        emit(TopicFailure(message: error.toString()));
      }
    }
  }
}
