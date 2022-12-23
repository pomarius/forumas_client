import 'dart:convert';

import '../../constants/data/endpoints.dart';
import '../../models/comment.dart';
import '../api_client.dart';

class CommentApi {
  final ApiClient _apiClient;

  const CommentApi(this._apiClient);

  Future<List<Comment>> getAllComments(String topicId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final dynamic response = await _apiClient.send(
      Endpoints.getAllComments(topicId),
      HttpMethod.get,
      headers: headers,
    );

    return List<Comment>.from(response.map((comment) => Comment.fromJson(comment)).toList());
  }

  Future<Comment> createComment(String content, String postId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'content': content,
      'postId': postId,
    };

    final dynamic response = await _apiClient.send(
      Endpoints.createComment,
      HttpMethod.post,
      headers: headers,
      body: jsonEncode(body),
    );

    return Comment.fromJson(response);
  }

  Future<Comment> updateComment(Comment comment) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = comment.toJson();

    final dynamic response = await _apiClient.send(
      Endpoints.updateComment(comment.id),
      HttpMethod.patch,
      headers: headers,
      body: jsonEncode(body),
    );

    return Comment.fromJson(response);
  }

  Future<void> deleteComment(Comment comment) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    await _apiClient.send(
      Endpoints.deleteComment(comment.id),
      HttpMethod.delete,
      headers: headers,
    );
  }

  Future<Comment> upvote(Comment comment) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final dynamic response = await _apiClient.send(
      Endpoints.upvoteComment(comment.id),
      HttpMethod.post,
      headers: headers,
    );

    return Comment.fromJson(response);
  }

  Future<Comment> downvote(Comment comment) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final dynamic response = await _apiClient.send(
      Endpoints.downvoteComment(comment.id),
      HttpMethod.post,
      headers: headers,
    );

    return Comment.fromJson(response);
  }

  Future<Comment> unvote(Comment comment) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final dynamic response = await _apiClient.send(
      Endpoints.unvoteComment(comment.id),
      HttpMethod.post,
      headers: headers,
    );

    return Comment.fromJson(response);
  }
}
