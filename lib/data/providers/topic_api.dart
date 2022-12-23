import 'dart:convert';

import '../../constants/data/endpoints.dart';
import '../../models/editable.dart';
import '../../models/topic.dart';
import '../api_client.dart';

class TopicApi {
  final ApiClient _apiClient;

  const TopicApi(this._apiClient);

  Future<Topic> createTopic(Editable editable) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = editable.toJson();

    final dynamic response = await _apiClient.send(
      Endpoints.createTopic,
      HttpMethod.post,
      headers: headers,
      body: jsonEncode(body),
    );

    return Topic.fromJson(response);
  }

  Future<List<Topic>> getAllTopics() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final dynamic response = await _apiClient.send(
      Endpoints.getAllTopics,
      HttpMethod.get,
      headers: headers,
    );

    return List<Topic>.from(response.map((topic) => Topic.fromJson(topic)).toList());
  }

  Future<Topic> updateTopic(Topic topic) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = topic.toJson();

    final dynamic response = await _apiClient.send(
      Endpoints.updateTopic(topic.id),
      HttpMethod.patch,
      headers: headers,
      body: jsonEncode(body),
    );

    return Topic.fromJson(response);
  }

  Future<void> deleteTopic(Topic topic) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    await _apiClient.send(
      Endpoints.deleteTopic(topic.id),
      HttpMethod.delete,
      headers: headers,
    );
  }

  Future<Topic> addModerator(Topic topic, String username) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'username': username,
    };

    final dynamic response = await _apiClient.send(
      Endpoints.addTopicModerator(topic.id),
      HttpMethod.post,
      headers: headers,
      body: jsonEncode(body),
    );

    return Topic.fromJson(response);
  }

  Future<Topic> blockUser(Topic topic, String username) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'username': username,
    };

    final dynamic response = await _apiClient.send(
      Endpoints.blockTopicUser(topic.id),
      HttpMethod.post,
      headers: headers,
      body: jsonEncode(body),
    );

    return Topic.fromJson(response);
  }
}
