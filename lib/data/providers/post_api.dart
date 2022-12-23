import 'dart:convert';

import '../../constants/data/endpoints.dart';
import '../../models/post.dart';
import '../api_client.dart';

class PostApi {
  final ApiClient _apiClient;

  const PostApi(this._apiClient);

  Future<List<Post>> getAllPosts(String topicId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final dynamic response = await _apiClient.send(
      Endpoints.getAllPosts(topicId),
      HttpMethod.get,
      headers: headers,
    );

    return List<Post>.from(response.map((post) => Post.fromJson(post)).toList());
  }

  Future<Post> createPost(Post post, String topicId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = post.toJson()..addAll({'topicId': topicId});

    final dynamic response = await _apiClient.send(
      Endpoints.createPost,
      HttpMethod.post,
      headers: headers,
      body: jsonEncode(body),
    );

    return Post.fromJson(response);
  }

  Future<Post> updatePost(Post post) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = post.toJson();

    final dynamic response = await _apiClient.send(
      Endpoints.updatePost(post.id),
      HttpMethod.patch,
      headers: headers,
      body: jsonEncode(body),
    );

    return Post.fromJson(response);
  }

  Future<void> deletePost(Post post) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    await _apiClient.send(
      Endpoints.deletePost(post.id),
      HttpMethod.delete,
      headers: headers,
    );
  }

  Future<Post> upvote(Post post) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final dynamic response = await _apiClient.send(
      Endpoints.upvotePost(post.id),
      HttpMethod.post,
      headers: headers,
    );

    return Post.fromJson(response);
  }

  Future<Post> downvote(Post post) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final dynamic response = await _apiClient.send(
      Endpoints.downvotePost(post.id),
      HttpMethod.post,
      headers: headers,
    );

    return Post.fromJson(response);
  }

  Future<Post> unvote(Post post) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final dynamic response = await _apiClient.send(
      Endpoints.unvotePost(post.id),
      HttpMethod.post,
      headers: headers,
    );

    return Post.fromJson(response);
  }
}
