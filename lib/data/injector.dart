import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'api_client.dart';
import 'providers/auth_api.dart';
import 'providers/comment_api.dart';
import 'providers/post_api.dart';
import 'providers/token_db.dart';
import 'providers/topic_api.dart';
import 'repositories/auth_repository.dart';
import 'repositories/comment_repository.dart';
import 'repositories/post_repository.dart';
import 'repositories/topic_repository.dart';

class Injector {
  static GetIt getIt = GetIt.instance;

  static Future<void> setupInjector() async {
    const FlutterSecureStorage storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );

    final ApiClient apiClient = ApiClient(TokenDb(storage));

    getIt.registerSingleton<AuthRepository>(AuthRepository(AuthApi(apiClient)));
    getIt.registerSingleton<TopicRepository>(TopicRepository(TopicApi(apiClient)));
    getIt.registerSingleton<PostRepository>(PostRepository(PostApi(apiClient)));
    getIt.registerSingleton<CommentRepository>(CommentRepository(CommentApi(apiClient)));
  }
}
