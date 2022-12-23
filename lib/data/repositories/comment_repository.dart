import '../../models/comment.dart';
import '../providers/comment_api.dart';

class CommentRepository {
  final CommentApi _commentApi;

  CommentRepository(this._commentApi);

  Future<List<Comment>> getAllComments(String postId) async {
    return await _commentApi.getAllComments(postId);
  }

  Future<Comment> createComment(String content, String postId) async {
    return await _commentApi.createComment(content, postId);
  }

  Future<Comment> updatePost(Comment comment) async {
    return await _commentApi.updateComment(comment);
  }

  Future<void> deleteComment(Comment comment) async {
    return await _commentApi.deleteComment(comment);
  }

  Future<Comment> upvote(Comment comment) async {
    return await _commentApi.upvote(comment);
  }

  Future<Comment> downvote(Comment comment) async {
    return await _commentApi.downvote(comment);
  }

  Future<Comment> unvote(Comment comment) async {
    return await _commentApi.unvote(comment);
  }
}
