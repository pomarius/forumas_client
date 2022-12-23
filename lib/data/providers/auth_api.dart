import 'dart:convert';

import '../../constants/data/endpoints.dart';
import '../api_client.dart';

class AuthApi {
  final ApiClient _apiClient;

  const AuthApi(this._apiClient);

  Future<void> signIn(String username, String password) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, String> body = {
      'username': username,
      'password': password,
    };

    await _apiClient.send(
      Endpoints.signIn,
      HttpMethod.post,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<void> signUp(String username, String password) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, String> body = {
      'username': username,
      'password': password,
    };

    await _apiClient.send(
      Endpoints.signUp,
      HttpMethod.post,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<List<String>> getUserId() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final dynamic response = await _apiClient.send(
      Endpoints.getUserId,
      HttpMethod.get,
      headers: headers,
    );

    return [response['userId'], response['username']];
  }

  Future<void> signOut() async {
    _apiClient.setAccessToken(null);
    await _apiClient.setRefreshToken(null);
  }

  Future<void> refreshToken() async {
    final String? token = await _apiClient.tokenDb.readRefreshToken();

    if (token == null) {
      throw 'upsi dupsi';
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'token': token,
    };

    await _apiClient.send(
      Endpoints.refreshToken,
      HttpMethod.post,
      headers: headers,
    );
  }
}
