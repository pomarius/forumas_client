import '../../models/post.dart';
import '../providers/post_api.dart';

class PostRepository {
  final PostApi _postApi;

  PostRepository(this._postApi);

  Future<List<Post>> getAllPosts(String topicId) async {
    return await _postApi.getAllPosts(topicId);
  }

  Future<Post> createPost(Post post, String topicId) async {
    return await _postApi.createPost(post, topicId);
  }

  Future<Post> updatePost(Post post) async {
    return await _postApi.updatePost(post);
  }

  Future<void> deletePost(Post post) async {
    return await _postApi.deletePost(post);
  }

  Future<Post> upvote(Post post) async {
    return await _postApi.upvote(post);
  }

  Future<Post> downvote(Post post) async {
    return await _postApi.downvote(post);
  }

  Future<Post> unvote(Post post) async {
    return await _postApi.unvote(post);
  }
}
