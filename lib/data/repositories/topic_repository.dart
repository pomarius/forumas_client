import '../../models/editable.dart';
import '../../models/topic.dart';
import '../providers/topic_api.dart';

class TopicRepository {
  final TopicApi _topicApi;

  TopicRepository(this._topicApi);

  Future<Topic> createTopic(Editable editable) async {
    return await _topicApi.createTopic(editable);
  }

  Future<List<Topic>> getAllTopics() async {
    return await _topicApi.getAllTopics();
  }

  Future<Topic> updateTopic(Topic topic) async {
    return await _topicApi.updateTopic(topic);
  }

  Future<void> deleteTopic(Topic topic) async {
    return await _topicApi.deleteTopic(topic);
  }

  Future<Topic> addModerator(Topic topic, String username) async {
    return await _topicApi.addModerator(topic, username);
  }

  Future<Topic> blockUser(Topic topic, String username) async {
    return await _topicApi.blockUser(topic, username);
  }
}
