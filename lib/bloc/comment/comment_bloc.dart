import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/comment_repository.dart';
import '../../models/comment.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository _commentRepository;

  CommentBloc(this._commentRepository) : super(CommentInitial()) {
    on<CommentLoad>(_onCommentLoad);
    on<CommentCreate>(_onCommentCreate);
    on<CommentUpdate>(_onCommentUpdate);
    on<CommentDelete>(_onCommentDelete);
    on<CommentUpvote>(_onCommentUpvote);
    on<CommentDownvote>(_onCommentDownvote);
  }

  Future<void> _onCommentLoad(CommentLoad event, Emitter<CommentState> emit) async {
    emit(const CommentLoading(status: CommentLoadingStatus.load));

    try {
      final List<Comment> comments = await _commentRepository.getAllComments(event.postId);
      emit(CommentLoaded(comments: comments));
    } catch (error) {
      emit(CommentFailure(message: error.toString()));
    }
  }

  Future<void> _onCommentCreate(CommentCreate event, Emitter<CommentState> emit) async {
    if (state is CommentLoaded) {
      final List<Comment> comments = [...(state as CommentLoaded).comments];
      emit(CommentLoading(status: CommentLoadingStatus.create, id: event.postId));

      try {
        final Comment comment = await _commentRepository.createComment(event.content, event.postId);
        comments.add(comment);
        emit(CommentLoaded(comments: comments));
      } catch (error) {
        emit(CommentFailure(message: error.toString()));
      }
    }
  }

  Future<void> _onCommentUpdate(CommentUpdate event, Emitter<CommentState> emit) async {
    if (state is CommentLoaded) {
      final List<Comment> comments = [...(state as CommentLoaded).comments];
      emit(CommentLoading(status: CommentLoadingStatus.update, id: event.comment.id));

      try {
        final Comment comment = await _commentRepository.updatePost(event.comment);

        final List<Comment> newComments = [];
        for (int i = 0; i < comments.length; i++) {
          if (comments[i].id == comment.id) {
            newComments.add(comment);
          } else {
            newComments.add(comments[i]);
          }
        }

        emit(CommentLoaded(comments: newComments));
      } catch (error) {
        emit(CommentFailure(message: error.toString()));
      }
    }
  }

  Future<void> _onCommentDelete(CommentDelete event, Emitter<CommentState> emit) async {
    if (state is CommentLoaded) {
      final List<Comment> comments = [...(state as CommentLoaded).comments];
      emit(CommentLoading(status: CommentLoadingStatus.delete, id: event.comment.id));

      try {
        await _commentRepository.deleteComment(event.comment);
        comments.remove(event.comment);
        emit(CommentLoaded(comments: comments));
      } catch (error) {
        emit(CommentFailure(message: error.toString()));
      }
    }
  }

  Future<void> _onCommentUpvote(CommentUpvote event, Emitter<CommentState> emit) async {
    if (state is CommentLoaded) {
      final List<Comment> comments = [...(state as CommentLoaded).comments];
      emit(CommentLoading(status: CommentLoadingStatus.upvote, id: event.comment.id));

      try {
        late final Comment comment;

        if (event.comment.upvotedUsers.contains(event.userId)) {
          comment = await _commentRepository.unvote(event.comment);
        } else {
          comment = await _commentRepository.upvote(event.comment);
        }

        final List<Comment> newComments = [];
        for (int i = 0; i < comments.length; i++) {
          if (comments[i].id == comment.id) {
            newComments.add(comment);
          } else {
            newComments.add(comments[i]);
          }
        }

        emit(CommentLoaded(comments: newComments));
      } catch (error) {
        emit(CommentFailure(message: error.toString()));
      }
    }
  }

  Future<void> _onCommentDownvote(CommentDownvote event, Emitter<CommentState> emit) async {
    if (state is CommentLoaded) {
      final List<Comment> comments = [...(state as CommentLoaded).comments];
      emit(CommentLoading(status: CommentLoadingStatus.upvote, id: event.comment.id));

      try {
        late final Comment comment;

        if (event.comment.downvotedUsers.contains(event.userId)) {
          comment = await _commentRepository.unvote(event.comment);
        } else {
          comment = await _commentRepository.downvote(event.comment);
        }

        final List<Comment> newComments = [];
        for (int i = 0; i < comments.length; i++) {
          if (comments[i].id == comment.id) {
            newComments.add(comment);
          } else {
            newComments.add(comments[i]);
          }
        }

        emit(CommentLoaded(comments: newComments));
      } catch (error) {
        emit(CommentFailure(message: error.toString()));
      }
    }
  }
}
