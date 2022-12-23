import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenDb {
  final FlutterSecureStorage _storage;

  TokenDb(this._storage);

  Future<String?> readRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: 'refresh_token');
  }
}
