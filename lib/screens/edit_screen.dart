import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/post/post_bloc.dart';
import '../bloc/topic/topic_bloc.dart';
import '../models/editable.dart';
import '../models/post.dart';
import '../models/topic.dart';
import '../constants/theme/dimens.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/custom_app_bar.dart';

class EditScreen extends StatefulWidget {
  final Editable editable;

  const EditScreen({super.key, required this.editable});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late final TopicBloc _topicBloc;
  late final PostBloc _postBloc;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _topicBloc = BlocProvider.of<TopicBloc>(context);
    _postBloc = BlocProvider.of<PostBloc>(context);

    _titleController.text = widget.editable.name;
    _descriptionController.text = widget.editable.description;
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
                  _buildTitleField(),
                  _buildDescriptionField(),
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
      title: widget.editable is Topic ? 'Edit topic' : 'Edit post',
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

  Widget _buildTitleField() {
    return AppTextField(
      controller: _titleController,
      labelText: 'Title',
      prefixIcon: const Icon(Icons.title_outlined),
      expands: true,
    );
  }

  Widget _buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.only(top: Dimens.baselineGrid * 2),
      child: AppTextField(
        controller: _descriptionController,
        labelText: 'Description',
        prefixIcon: const Icon(Icons.description_outlined),
        expands: true,
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(
        top: Dimens.baselineGrid * 3,
      ),
      child: widget.editable is Topic ? _buildTopicButton() : _buildPostButton(),
    );
  }

  Widget _buildTopicButton() {
    return AppButton(
      onTap: () {
        if (_topicBloc.state is! TopicLoading &&
            _titleController.text.isNotEmpty &&
            _descriptionController.text.isNotEmpty) {
          _topicBloc.add(
            TopicUpdate(
              topic: (widget.editable as Topic).copyWith(_titleController.text, _descriptionController.text),
            ),
          );
        }
      },
      child: BlocConsumer<TopicBloc, TopicState>(
        listenWhen: (previous, current) =>
            previous is TopicLoading &&
            previous.status == TopicLoadingStatus.update &&
            previous.id == (widget.editable as Topic).id,
        listener: (context, state) {
          if (state is TopicLoaded) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is TopicLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const Text('Save changes');
        },
      ),
    );
  }

  Widget _buildPostButton() {
    return AppButton(
      onTap: () {
        if (_postBloc.state is! PostLoading &&
            _titleController.text.isNotEmpty &&
            _descriptionController.text.isNotEmpty) {
          _postBloc.add(
            PostUpdate(
              post: (widget.editable as Post).copyWith(_titleController.text, _descriptionController.text),
            ),
          );
        }
      },
      child: BlocConsumer<PostBloc, PostState>(
        listenWhen: (previous, current) =>
            previous is PostLoading &&
            previous.status == PostLoadingStatus.update &&
            previous.id == (widget.editable as Post).id,
        listener: (context, state) {
          if (state is PostLoaded) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is PostLoading) {
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
