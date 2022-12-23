import '../providers/auth_api.dart';

class AuthRepository {
  final AuthApi _authApi;

  AuthRepository(this._authApi);

  Future<void> reSignIn() async {
    return await _authApi.refreshToken();
  }

  Future<void> signIn(String username, String password) async {
    return await _authApi.signIn(username, password);
  }

  Future<void> signUp(String username, String password) async {
    return await _authApi.signUp(username, password);
  }

  Future<List<String>> getUserId() async {
    return await _authApi.getUserId();
  }

  Future<void> signOut() async {
    return await _authApi.signOut();
  }
}
