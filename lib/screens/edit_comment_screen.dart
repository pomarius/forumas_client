import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/comment/comment_bloc.dart';
import '../bloc/post/post_bloc.dart';
import '../bloc/topic/topic_bloc.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../models/topic.dart';
import '../constants/theme/dimens.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/custom_app_bar.dart';

class EditCommentScreen extends StatefulWidget {
  final Comment comment;

  const EditCommentScreen({super.key, required this.comment});

  @override
  State<EditCommentScreen> createState() => _EditCommentScreenState();
}

class _EditCommentScreenState extends State<EditCommentScreen> {
  late final CommentBloc _commentBloc;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _commentBloc = BlocProvider.of<CommentBloc>(context);

    _textController.text = widget.comment.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(Dimens.baselineGrid * 2),
              padding: const EdgeInsets.all(Dimens.baselineGrid * 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(Dimens.cornerRadius),
                border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  _buildCommentField(),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return CustomAppBar(
      title: 'Edit comment',
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_outlined,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      delay: false,
    );
  }

  Widget _buildCommentField() {
    return AppTextField(
      controller: _textController,
      labelText: 'Comment',
      prefixIcon: const Icon(Icons.title_outlined),
      expands: true,
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(
        top: Dimens.baselineGrid * 3,
      ),
      child: _buildCommentButton(),
    );
  }

  Widget _buildCommentButton() {
    return AppButton(
      onTap: () {
        if (_commentBloc.state is! CommentLoading && _textController.text.isNotEmpty) {
          _commentBloc.add(
            CommentUpdate(
              comment: widget.comment.copyWith(_textController.text),
            ),
          );
        }
      },
      child: BlocConsumer<CommentBloc, CommentState>(
        listenWhen: (previous, current) =>
            previous is CommentLoading &&
            previous.status == CommentLoadingStatus.update &&
            previous.id == widget.comment.id,
        listener: (context, state) {
          if (state is CommentLoaded) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is CommentLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const Text('Save changes');
        },
      ),
    );
  }
}
