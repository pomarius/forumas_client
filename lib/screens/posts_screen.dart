import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/post/post_bloc.dart';
import '../models/topic.dart';
import '../constants/theme/app_text_styles.dart';
import '../constants/theme/dimens.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/post_tile.dart';

class PostsScreen extends StatefulWidget {
  final Topic topic;

  const PostsScreen({super.key, required this.topic});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late final PostBloc _postBloc;
  late final AuthBloc _authBloc;

  @override
  void initState() {
    _postBloc = BlocProvider.of<PostBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _postBloc.add(
      PostLoad(
        topicId: widget.topic.id,
        userId: _authBloc.state is AuthSignedIn ? (_authBloc.state as AuthSignedIn).userId : null,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _postBloc.add(PostReset());
        return true;
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            late final double padding;

            if (constraints.maxWidth > 1000) {
              padding = Dimens.baselineGrid * 2 + (constraints.maxWidth / 2) - 500;
            } else {
              padding = Dimens.baselineGrid * 2;
            }

            return CustomScrollView(
              slivers: [
                _buildAppBar(),
                _buildDescription(padding),
                _buildItems(padding),
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    if (state is PostLoaded && state.posts.isEmpty) {
                      return const SliverToBoxAdapter(child: SizedBox());
                    }

                    return SliverToBoxAdapter(
                      child: SizedBox(height: Dimens.baselineGrid * 2 + MediaQuery.of(context).padding.bottom),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return CustomAppBar(
      title: widget.topic.name,
      delay: false,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_outlined,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildDescription(double padding) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: padding,
          vertical: Dimens.baselineGrid * 2,
        ),
        padding: const EdgeInsets.all(Dimens.baselineGrid * 2),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(Dimens.cornerRadius),
          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
        ),
        child: Text(
          widget.topic.description,
          style: AppTextStyles.description.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildItems(double padding) {
    return BlocBuilder<PostBloc, PostState>(
      buildWhen: (previous, current) => current is! PostLoading && current is! PostFailure,
      builder: (context, state) {
        if (state is PostLoaded && state.posts.isNotEmpty) {
          return SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return PostTile(topic: widget.topic, post: state.posts[index]);
                },
                childCount: state.posts.length,
              ),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 800,
                childAspectRatio: 2,
                crossAxisSpacing: Dimens.baselineGrid * 2,
                mainAxisSpacing: Dimens.baselineGrid * 2,
              ),
            ),
          );
        } else if (state is PostLoaded) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Container(
                margin: EdgeInsets.only(
                  left: padding,
                  right: padding,
                  top: Dimens.baselineGrid * 2,
                  bottom: Dimens.baselineGrid * 2 + MediaQuery.of(context).padding.bottom,
                ),
                padding: const EdgeInsets.all(Dimens.baselineGrid * 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(Dimens.cornerRadius),
                  border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/empty.png'),
                    const SizedBox(height: Dimens.baselineGrid * 4),
                    Text(
                      'No posts have been created :(',
                      style: AppTextStyles.title2.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(height: Dimens.baselineGrid * 2),
                  ],
                ),
              ),
            ),
          );
        } else if (state is PostFailure) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Container(
                margin: EdgeInsets.only(
                  left: padding,
                  right: padding,
                  top: Dimens.baselineGrid * 2,
                  bottom: Dimens.baselineGrid * 2 + MediaQuery.of(context).padding.bottom,
                ),
                padding: const EdgeInsets.all(Dimens.baselineGrid * 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(Dimens.cornerRadius),
                  border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
                ),
                child: Text(
                  state.message,
                  style: AppTextStyles.title2.copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
            ),
          );
        }

        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
