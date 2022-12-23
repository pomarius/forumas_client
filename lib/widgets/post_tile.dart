import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/comment/comment_bloc.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/post/post_bloc.dart';
import '../data/repositories/comment_repository.dart';
import '../models/post.dart';
import '../models/topic.dart';
import '../constants/theme/app_text_styles.dart';
import '../constants/theme/dimens.dart';
import '../screens/comments_screen.dart';
import '../screens/edit_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../utils/misc_utils.dart';
import 'animated_indexed_stack.dart';
import 'app_button.dart';

class PostTile extends StatefulWidget {
  final Topic topic;
  final Post post;

  const PostTile({super.key, required this.topic, required this.post});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late final NavigationBloc _navigationBloc;
  late final PostBloc _postBloc;
  late final AuthBloc _authBloc;

  @override
  void initState() {
    _navigationBloc = BlocProvider.of<NavigationBloc>(context);
    _postBloc = BlocProvider.of<PostBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      tappable: false,
      transitionType: ContainerTransitionType.fadeThrough,
      closedColor: Theme.of(context).colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      closedShape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(Dimens.cornerRadius)),
        side: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      closedElevation: 0,
      onClosed: (data) => _navigationBloc.add(const NavigationLevel(1)),
      closedBuilder: (context, action) => _buildTile(action),
      openBuilder: (context, action) {
        return BlocBuilder<NavigationBloc, NavigationState>(
          buildWhen: (previous, current) => current.level == 2,
          builder: (context, state) {
            return AnimatedIndexedStack(
              index: state.index,
              children: [
                BlocProvider(
                  create: (context) => CommentBloc(GetIt.instance.get<CommentRepository>()),
                  child: CommentsScreen(
                    post: widget.post,
                    topic: widget.topic,
                  ),
                ),
                const ProfileScreen(),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTile(VoidCallback action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onTap(action),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            Divider(color: Theme.of(context).colorScheme.outline.withOpacity(0.2), height: 0),
            _buildDescription(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final List<String> moderatorIds = widget.topic.moderators.map((e) => e.id).toList();

        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimens.baselineGrid),
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: _onUpvote,
                  child: Padding(
                    padding: const EdgeInsets.all(Dimens.baselineGrid),
                    child: BlocBuilder<PostBloc, PostState>(
                      builder: (context, state) {
                        if (state is PostLoading &&
                            state.status == PostLoadingStatus.upvote &&
                            state.id == widget.post.id) {
                          return Icon(
                            Icons.thumb_up,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          );
                        }

                        return Icon(
                          _authBloc.state is AuthSignedIn
                              ? widget.post.upvotedUsers.contains((_authBloc.state as AuthSignedIn).userId)
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined
                              : Icons.thumb_up_outlined,
                          color: _authBloc.state is AuthSignedIn
                              ? widget.post.upvotedUsers.contains((_authBloc.state as AuthSignedIn).userId)
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurface,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Text(
              (widget.post.upvotes - widget.post.downvotes).toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Dimens.baselineGrid),
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: _onDownvote,
                  child: Padding(
                    padding: const EdgeInsets.all(Dimens.baselineGrid),
                    child: BlocBuilder<PostBloc, PostState>(
                      builder: (context, state) {
                        if (state is PostLoading &&
                            state.status == PostLoadingStatus.downvote &&
                            state.id == widget.post.id) {
                          return Icon(
                            Icons.thumb_down,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          );
                        }

                        return Icon(
                          _authBloc.state is AuthSignedIn
                              ? widget.post.downvotedUsers.contains((_authBloc.state as AuthSignedIn).userId)
                                  ? Icons.thumb_down
                                  : Icons.thumb_down_outlined
                              : Icons.thumb_down_outlined,
                          color: _authBloc.state is AuthSignedIn
                              ? widget.post.downvotedUsers.contains((_authBloc.state as AuthSignedIn).userId)
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurface,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            if (state is AuthSignedIn && (moderatorIds.contains(state.userId) || state.userId == widget.post.userId))
              SizedBox.square(
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
                          MaterialPageRoute(builder: (context) => EditScreen(editable: widget.post)),
                        );
                        break;
                      case 1:
                        _showMyDialog();
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
          ],
        );
      },
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.baselineGrid * 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.post.name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state is PostLoading && state.status == PostLoadingStatus.delete && state.id == widget.post.id) {
                return const CircularProgressIndicator();
              }

              return Icon(
                Icons.chevron_right_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.baselineGrid * 2),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final Text description = Text(
                widget.post.description,
                style: AppTextStyles.description.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              );
              final int maxLines = (constraints.maxHeight / MiscUtils.getTextSize(description).height).floor();

              if (maxLines == 0) {
                return const SizedBox();
              }

              return Text(
                description.data!,
                style: description.style,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
        ),
      ),
    );
  }

  void _onTap(VoidCallback action) {
    if (_postBloc.state is PostLoading && (_postBloc.state as PostLoading).id == widget.post.id) {
      return;
    }

    _navigationBloc.add(const NavigationLevel(2));
    action.call();
  }

  void _onUpvote() {
    if (_postBloc.state is PostLoading && (_postBloc.state as PostLoading).id == widget.post.id) {
      return;
    }

    if (_authBloc.state is AuthSignedIn) {
      _postBloc.add(PostUpvote(post: widget.post, userId: (_authBloc.state as AuthSignedIn).userId));
    }
  }

  void _onDownvote() {
    if (_postBloc.state is PostLoading && (_postBloc.state as PostLoading).id == widget.post.id) {
      return;
    }

    if (_authBloc.state is AuthSignedIn) {
      _postBloc.add(PostDownvote(post: widget.post, userId: (_authBloc.state as AuthSignedIn).userId));
    }
  }

  Future<void> _showMyDialog() async {
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
                _postBloc.add(PostDelete(post: widget.post));
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
