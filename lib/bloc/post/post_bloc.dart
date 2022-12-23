import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/post_repository.dart';
import '../../models/post.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;

  PostBloc(this._postRepository) : super(PostInitial()) {
    on<PostReset>(_onPostReset);
    on<PostSort>(_onPostSort);
    on<PostCreate>(_onPostCreate);
    on<PostLoad>(_onPostLoad);
    on<PostUpdate>(_onPostUpdate);
    on<PostDelete>(_onPostDelete);
    on<PostUpvote>(_onPostUpvote);
    on<PostDownvote>(_onPostDownvote);
  }

  Future<void> _onPostReset(PostReset event, Emitter<PostState> emit) async {
    emit(PostInitial());
  }

  Future<void> _onPostCreate(PostCreate event, Emitter<PostState> emit) async {
    if (state is PostLoaded) {
      final List<Post> posts = [...(state as PostLoaded).posts];
      emit(PostLoading(topicId: event.topicId, status: PostLoadingStatus.create));

      try {
        final Post post = await _postRepository.createPost(event.post, event.topicId);
        posts.insert(0, post);

        emit(PostLoaded(posts: posts, topicId: event.topicId));
      } catch (error) {
        emit(PostFailure(topicId: event.topicId, message: error.toString()));
      }
    }
  }

  Future<void> _onPostSort(PostSort event, Emitter<PostState> emit) async {
    if (state is PostLoaded) {
      final List<Post> posts = [...(state as PostLoaded).posts];

      if (event.userId != null) {
        posts.sort((a, b) {
          if (a.userId == event.userId && b.userId != event.userId) {
            return -1;
          } else if (a.userId != event.userId && b.userId == event.userId) {
            return 1;
          } else {
            return a.name.compareTo(b.name);
          }
        });
      } else {
        posts.sort((a, b) => a.name.compareTo(b.name));
      }

      emit(PostLoaded(topicId: state.topicId, posts: posts));
    }
  }

  Future<void> _onPostLoad(PostLoad event, Emitter<PostState> emit) async {
    emit(PostLoading(topicId: event.topicId, status: PostLoadingStatus.load));
    try {
      final List<Post> posts = await _postRepository.getAllPosts(event.topicId);

      if (event.userId != null) {
        posts.sort((a, b) {
          if (a.userId == event.userId && b.userId != event.userId) {
            return -1;
          } else if (a.userId != event.userId && b.userId == event.userId) {
            return 1;
          } else {
            return a.name.compareTo(b.name);
          }
        });
      } else {
        posts.sort((a, b) => a.name.compareTo(b.name));
      }

      emit(PostLoaded(posts: posts, topicId: event.topicId));
    } catch (error) {
      emit(PostFailure(topicId: event.topicId, message: error.toString()));
    }
  }

  Future<void> _onPostUpdate(PostUpdate event, Emitter<PostState> emit) async {
    if (state is PostLoaded) {
      final List<Post> posts = (state as PostLoaded).posts;
      emit(PostLoading(topicId: state.topicId, status: PostLoadingStatus.update, id: event.post.id));
      try {
        final Post post = await _postRepository.updatePost(event.post);

        final List<Post> newPosts = [];
        for (int i = 0; i < posts.length; i++) {
          if (posts[i].id == post.id) {
            newPosts.add(post);
          } else {
            newPosts.add(posts[i]);
          }
        }

        emit(PostLoaded(topicId: state.topicId, posts: newPosts));
      } catch (error) {
        emit(PostFailure(topicId: state.topicId, message: error.toString()));
      }
    }
  }

  Future<void> _onPostDelete(PostDelete event, Emitter<PostState> emit) async {
    if (state is PostLoaded) {
      final List<Post> posts = [...(state as PostLoaded).posts];
      emit(PostLoading(topicId: state.topicId, status: PostLoadingStatus.delete, id: event.post.id));

      try {
        await _postRepository.deletePost(event.post);
        posts.remove(event.post);
        emit(PostLoaded(topicId: state.topicId, posts: posts));
      } catch (error) {
        emit(PostFailure(topicId: state.topicId, message: error.toString()));
      }
    }
  }

  Future<void> _onPostUpvote(PostUpvote event, Emitter<PostState> emit) async {
    if (state is PostLoaded) {
      final List<Post> posts = [...(state as PostLoaded).posts];
      emit(PostLoading(topicId: state.topicId, status: PostLoadingStatus.upvote, id: event.post.id));

      try {
        late final Post post;

        if (event.post.upvotedUsers.contains(event.userId)) {
          post = await _postRepository.unvote(event.post);
        } else {
          post = await _postRepository.upvote(event.post);
        }

        final List<Post> newPosts = [];
        for (int i = 0; i < posts.length; i++) {
          if (posts[i].id == post.id) {
            newPosts.add(post);
          } else {
            newPosts.add(posts[i]);
          }
        }

        emit(PostLoaded(topicId: state.topicId, posts: newPosts));
      } catch (error) {
        emit(PostFailure(topicId: state.topicId, message: error.toString()));
      }
    }
  }

  Future<void> _onPostDownvote(PostDownvote event, Emitter<PostState> emit) async {
    if (state is PostLoaded) {
      final List<Post> posts = [...(state as PostLoaded).posts];
      emit(PostLoading(topicId: state.topicId, status: PostLoadingStatus.upvote, id: event.post.id));

      try {
        late final Post post;

        if (event.post.downvotedUsers.contains(event.userId)) {
          post = await _postRepository.unvote(event.post);
        } else {
          post = await _postRepository.downvote(event.post);
        }

        final List<Post> newPosts = [];
        for (int i = 0; i < posts.length; i++) {
          if (posts[i].id == post.id) {
            newPosts.add(post);
          } else {
            newPosts.add(posts[i]);
          }
        }

        emit(PostLoaded(topicId: state.topicId, posts: newPosts));
      } catch (error) {
        emit(PostFailure(topicId: state.topicId, message: error.toString()));
      }
    }
  }
}
