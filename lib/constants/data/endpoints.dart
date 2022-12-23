class Endpoints {
  const Endpoints._();

  static const String host = 'localhost:3000';

  static const String signIn = 'api/auth/login';
  static const String signUp = 'api/auth/register';
  static const String refreshToken = 'api/auth/refreshToken';
  static const String getUserId = 'api/auth/getUserId';

  static const String createTopic = 'api/topic/create';
  static const String getAllTopics = 'api/topic/read';
  static String getTopic(String id) => 'api/topic/read/$id';
  static String updateTopic(String id) => 'api/topic/update/$id';
  static String deleteTopic(String id) => 'api/topic/delete/$id';
  static String addTopicModerator(String id) => 'api/topic/moderator/$id';
  static String blockTopicUser(String id) => 'api/topic/block/$id';

  static const String createPost = 'api/post/create';
  static String getAllPosts(String topicId) => 'api/post/read/$topicId';
  static String updatePost(String id) => 'api/post/update/$id';
  static String deletePost(String id) => 'api/post/delete/$id';
  static String upvotePost(String id) => 'api/post/upvote/$id';
  static String downvotePost(String id) => 'api/post/downvote/$id';
  static String unvotePost(String id) => 'api/post/unvote/$id';

  static const String createComment = 'api/comment/create';
  static String getAllComments(String postId) => 'api/comment/read/$postId';
  static String getComment(String topicId, String postId, String id) => 'api/comment/read/$id/$postId/$topicId';
  static String updateComment(String id) => 'api/comment/update/$id';
  static String deleteComment(String id) => 'api/comment/delete/$id';
  static String upvoteComment(String id) => 'api/comment/upvote/$id';
  static String downvoteComment(String id) => 'api/comment/downvote/$id';
  static String unvoteComment(String id) => 'api/comment/unvote/$id';
}
