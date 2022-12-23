import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/topic/topic_bloc.dart';
import '../models/topic.dart';
import '../constants/theme/app_text_styles.dart';
import '../constants/theme/dimens.dart';
import '../screens/blocked_screen.dart';
import '../screens/edit_screen.dart';
import '../screens/moderators_screen.dart';
import '../screens/posts_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../utils/misc_utils.dart';
import 'animated_indexed_stack.dart';
import 'app_button.dart';

class TopicTile extends StatefulWidget {
  final Topic topic;

  const TopicTile({super.key, required this.topic});

  @override
  State<TopicTile> createState() => _TopicTileState();
}

class _TopicTileState extends State<TopicTile> {
  late final NavigationBloc _navigationBloc;
  late final TopicBloc _topicBloc;

  @override
  void initState() {
    _navigationBloc = BlocProvider.of<NavigationBloc>(context);
    _topicBloc = BlocProvider.of<TopicBloc>(context);
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
      onClosed: (data) => _navigationBloc.add(const NavigationLevel(0)),
      closedBuilder: (context, action) => _buildTile(action),
      openBuilder: (context, action) {
        return BlocBuilder<NavigationBloc, NavigationState>(
          buildWhen: (previous, current) => current.level == 1,
          builder: (context, state) {
            return AnimatedIndexedStack(
              index: state.index,
              children: [
                PostsScreen(topic: widget.topic),
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
                        MaterialPageRoute(builder: (context) => EditScreen(editable: widget.topic)),
                      );
                      break;
                    case 1:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ModeratorsScreen(topic: widget.topic)),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BlockedScreen(topic: widget.topic)),
                      );
                      break;
                    case 3:
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
                          Icon(Icons.person_outlined),
                          SizedBox(width: Dimens.baselineGrid * 2),
                          Text('Manage moderators'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: const [
                          Icon(Icons.block_outlined),
                          SizedBox(width: Dimens.baselineGrid * 2),
                          Text('Block user'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 3,
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

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.baselineGrid * 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.topic.name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          BlocBuilder<TopicBloc, TopicState>(
            builder: (context, state) {
              if (state is TopicLoading && state.id == widget.topic.id) {
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
                widget.topic.description,
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
                _topicBloc.add(TopicDelete(topic: widget.topic));
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

  void _onTap(VoidCallback action) {
    if (_topicBloc.state is TopicLoading && (_topicBloc.state as TopicLoading).id == widget.topic.id) {
      return;
    }

    _navigationBloc.add(const NavigationLevel(1));
    action.call();
  }
}
