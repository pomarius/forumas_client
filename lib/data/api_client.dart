import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';

import '../constants/data/endpoints.dart';
import 'api_exception.dart';
import 'providers/token_db.dart';

enum HttpMethod { get, post, patch, delete }

class ApiClient {
  final Client _httpClient = Client();
  final TokenDb tokenDb;
  String? _accessToken;

  ApiClient(this.tokenDb);

  void setAccessToken(String? token) {
    _accessToken = token;
  }

  Future<void> setRefreshToken(String? token) async {
    token == null ? await tokenDb.deleteRefreshToken() : await tokenDb.saveRefreshToken(token);
  }

  Future<dynamic> send(
    String path,
    HttpMethod method, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      final Uri uri = Uri.http(Endpoints.host, path, params);

      if (_accessToken != null && headers != null) {
        headers.addAll({'token': _accessToken!});
      } else if (_accessToken != null) {
        headers = {'token': _accessToken!};
      }

      late Response response;

      switch (method) {
        case HttpMethod.get:
          response = await _httpClient.get(uri, headers: headers);
          break;
        case HttpMethod.post:
          response = await _httpClient.post(uri, headers: headers, body: body);
          break;
        case HttpMethod.patch:
          response = await _httpClient.patch(uri, headers: headers, body: body);
          break;
        case HttpMethod.delete:
          response = await _httpClient.delete(uri, headers: headers, body: body);
          break;
      }

      if (response.statusCode == 401 && (response.body == 'Token expired' || response.body == 'Invalid token')) {
        setAccessToken(null);
        final String? refreshToken = await tokenDb.readRefreshToken();

        if (refreshToken != null) {
          try {
            await _response(await _httpClient.post(
              Uri.http(Endpoints.host, Endpoints.refreshToken),
              headers: {'token': refreshToken},
            ));

            headers?.remove('token');
            headers?.addAll({'token': _accessToken!});

            switch (method) {
              case HttpMethod.get:
                response = await _httpClient.get(uri, headers: headers);
                break;
              case HttpMethod.post:
                response = await _httpClient.post(uri, headers: headers, body: body);
                break;
              case HttpMethod.patch:
                response = await _httpClient.patch(uri, headers: headers, body: body);
                break;
              case HttpMethod.delete:
                response = await _httpClient.delete(uri, headers: headers, body: body);
                break;
            }

            return await _response(response);
          } catch (error) {
            await setRefreshToken(null);
            rethrow;
          }
        }
      }

      return await _response(response);
    } on SocketException {
      throw ApiException('Patikrinkite interneto ryšį');
    }
  }

  Future<dynamic> _response(dynamic response) async {
    if (response.statusCode >= 300) {
      throw ApiException(response.body, response.statusCode);
    }

    if (response.bodyBytes.isNotEmpty) {
      final dynamic decodedJson = json.decode(utf8.decode(response.bodyBytes));
      log(decodedJson.toString());

      if (decodedJson is Map && decodedJson.containsKey('accessToken')) {
        setAccessToken(decodedJson['accessToken']);
      }

      if (decodedJson is Map && decodedJson.containsKey('refreshToken')) {
        await setRefreshToken(decodedJson['refreshToken']);
      }

      return decodedJson;
    }

    return null;
  }
}
