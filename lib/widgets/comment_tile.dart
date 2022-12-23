import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/comment/comment_bloc.dart';
import '../constants/theme/app_text_styles.dart';
import '../constants/theme/dimens.dart';
import '../models/comment.dart';
import '../models/topic.dart';
import '../screens/edit_comment_screen.dart';
import 'app_button.dart';

class CommentTile extends StatefulWidget {
  final int index;
  final int lastIndex;
  final Comment comment;
  final Topic topic;

  const CommentTile({
    super.key,
    required this.index,
    required this.lastIndex,
    required this.comment,
    required this.topic,
  });

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  late final AuthBloc _authBloc;
  late final CommentBloc _commentBloc;

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _commentBloc = BlocProvider.of<CommentBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: Dimens.baselineGrid * 2,
        left: Dimens.baselineGrid * 2,
        right: Dimens.baselineGrid * 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: widget.index == 0 && widget.index == widget.lastIndex
            ? BorderRadius.circular(Dimens.cornerRadius)
            : widget.index == 0
                ? const BorderRadius.only(
                    topLeft: Radius.circular(Dimens.cornerRadius),
                    topRight: Radius.circular(Dimens.cornerRadius),
                  )
                : widget.index == widget.lastIndex
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(Dimens.cornerRadius),
                        bottomRight: Radius.circular(Dimens.cornerRadius),
                      )
                    : null,
        border: widget.index == 0
            ? Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2))
            : Border(
                top: widget.index != 0
                    ? BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2))
                    : BorderSide.none,
                bottom: widget.index == widget.lastIndex
                    ? BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2))
                    : BorderSide.none,
                left: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
                right: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.comment.content,
            style: AppTextStyles.description.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          Row(
            children: [
              _buildUpvoteButton(),
              Text(
                (widget.comment.upvotes - widget.comment.downvotes).toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildDownvoteButton(),
              const Spacer(),
              _buildMenuButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpvoteButton() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.baselineGrid),
      child: Material(
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: _onUpvote,
          child: Padding(
            padding: const EdgeInsets.all(Dimens.baselineGrid),
            child: BlocBuilder<CommentBloc, CommentState>(
              builder: (context, state) {
                if (state is CommentLoading &&
                    state.status == CommentLoadingStatus.downvote &&
                    state.id == widget.comment.id) {
                  return Icon(
                    Icons.thumb_up,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  );
                }

                return Icon(
                  _authBloc.state is AuthSignedIn
                      ? widget.comment.upvotedUsers.contains((_authBloc.state as AuthSignedIn).userId)
                          ? Icons.thumb_up
                          : Icons.thumb_up_outlined
                      : Icons.thumb_up_outlined,
                  color: _authBloc.state is AuthSignedIn
                      ? widget.comment.upvotedUsers.contains((_authBloc.state as AuthSignedIn).userId)
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onSurface,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDownvoteButton() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.baselineGrid),
      child: Material(
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: _onDownvote,
          child: Padding(
            padding: const EdgeInsets.all(Dimens.baselineGrid),
            child: BlocBuilder<CommentBloc, CommentState>(
              builder: (context, state) {
                if (state is CommentLoading &&
                    state.status == CommentLoadingStatus.downvote &&
                    state.id == widget.comment.id) {
                  return Icon(
                    Icons.thumb_down,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  );
                }

                return Icon(
                  _authBloc.state is AuthSignedIn
                      ? widget.comment.downvotedUsers.contains((_authBloc.state as AuthSignedIn).userId)
                          ? Icons.thumb_down
                          : Icons.thumb_down_outlined
                      : Icons.thumb_down_outlined,
                  color: _authBloc.state is AuthSignedIn
                      ? widget.comment.downvotedUsers.contains((_authBloc.state as AuthSignedIn).userId)
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onSurface,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final List<String> moderatorIds = widget.topic.moderators.map((e) => e.id).toList();

        if (state is AuthSignedIn && moderatorIds.contains(state.userId)) {
          return Align(
            alignment: Alignment.centerRight,
            child: SizedBox.square(
              dimension: 48,
              child: PopupMenuButton<int>(
                tooltip: '',
                icon: Icon(Icons.more_vert_outlined, color: Theme.of(context).colorScheme.onSurface),
                color: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(Dimens.cornerRadius)),
                  side: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
                ),
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: _commentBloc,
                            child: EditCommentScreen(comment: widget.comment),
                          ),
                        ),
                      );
                      break;
                    case 1:
                      _showMyDialog(state.userId);
                      break;
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 0,
                      child: Row(
                        children: const [
                          Icon(Icons.edit_outlined),
                          SizedBox(width: Dimens.baselineGrid * 2),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: const [
                          Icon(Icons.delete_outlined),
                          SizedBox(width: Dimens.baselineGrid * 2),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  void _onUpvote() {
    if (_commentBloc.state is CommentLoading && (_commentBloc.state as CommentLoading).id == widget.comment.id) {
      return;
    }

    if (_authBloc.state is AuthSignedIn) {
      _commentBloc.add(CommentUpvote(comment: widget.comment, userId: (_authBloc.state as AuthSignedIn).userId));
    }
  }

  void _onDownvote() {
    if (_commentBloc.state is CommentLoading && (_commentBloc.state as CommentLoading).id == widget.comment.id) {
      return;
    }

    if (_authBloc.state is AuthSignedIn) {
      _commentBloc.add(CommentDownvote(comment: widget.comment, userId: (_authBloc.state as AuthSignedIn).userId));
    }
  }

  Future<void> _showMyDialog(String userId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimens.cornerRadius))),
          title: const Text('Are you sure?', style: AppTextStyles.header),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This action cannot be undone.', style: AppTextStyles.description.copyWith(fontSize: 16)),
              ],
            ),
          ),
          actions: <Widget>[
            AppButton(
              onTap: () {
                _commentBloc.add(CommentDelete(comment: widget.comment, userId: userId));
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
            const SizedBox(height: Dimens.baselineGrid),
            AppButton(
              onTap: () => Navigator.pop(context),
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
