import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/comment/comment_bloc.dart';
import '../constants/theme/app_text_styles.dart';
import '../constants/theme/dimens.dart';
import '../models/post.dart';
import '../models/topic.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/comment_tile.dart';
import '../widgets/custom_app_bar.dart';

class CommentsScreen extends StatefulWidget {
  final Post post;
  final Topic topic;

  const CommentsScreen({super.key, required this.post, required this.topic});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late final CommentBloc _commentBloc;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    _commentBloc = BlocProvider.of<CommentBloc>(context);
    _commentBloc.add(CommentLoad(postId: widget.post.id));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _buildCommentField(padding),
              _buildItems(padding),
              BlocBuilder<CommentBloc, CommentState>(
                builder: (context, state) {
                  if (state is CommentLoaded && state.comments.isEmpty || state is CommentFailure) {
                    return const SliverToBoxAdapter(child: SizedBox());
                  }

                  return SliverToBoxAdapter(
                    child: SizedBox(height: MediaQuery.of(context).padding.bottom + Dimens.baselineGrid * 2),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return CustomAppBar(
      title: widget.post.name,
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
          widget.post.description,
          style: AppTextStyles.description.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCommentField(double padding) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(
          bottom: Dimens.baselineGrid * 2,
          left: padding,
          right: padding,
        ),
        padding: const EdgeInsets.all(Dimens.baselineGrid * 2),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(Dimens.cornerRadius),
          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            AppTextField(
              controller: _commentController,
              labelText: 'Comment',
              prefixIcon: const Icon(Icons.chat_bubble_outline),
              expands: true,
            ),
            Padding(
              padding: const EdgeInsets.only(top: Dimens.baselineGrid * 3),
              child: AppButton(
                onTap: _onCommentTap,
                child: BlocBuilder<CommentBloc, CommentState>(
                  builder: (context, state) {
                    if (state is CommentLoading &&
                        state.status == CommentLoadingStatus.create &&
                        state.id == widget.post.id) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return const Text('Comment');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItems(double padding) {
    return BlocBuilder<CommentBloc, CommentState>(
      buildWhen: (previous, current) => current is! CommentLoading,
      builder: (context, state) {
        if (state is CommentLoaded && state.comments.isNotEmpty) {
          return SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return CommentTile(
                    index: index,
                    lastIndex: state.comments.length - 1,
                    comment: state.comments[index],
                    topic: widget.topic,
                  );
                },
                childCount: state.comments.length,
              ),
            ),
          );
        } else if (state is CommentLoaded) {
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
                      'No comments have been created :(',
                      style: AppTextStyles.title2.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(height: Dimens.baselineGrid * 2),
                  ],
                ),
              ),
            ),
          );
        } else if (state is CommentFailure) {
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

  void _onCommentTap() {
    if (_commentBloc.state is! CommentLoading && _commentController.text.isNotEmpty) {
      _commentBloc.add(CommentCreate(postId: widget.post.id, content: _commentController.text));
    }
  }
}
