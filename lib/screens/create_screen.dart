import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/post/post_bloc.dart';
import '../bloc/topic/topic_bloc.dart';
import '../constants/theme/app_text_styles.dart';
import '../models/editable.dart';
import '../constants/theme/dimens.dart';
import '../models/post.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/custom_app_bar.dart';

enum CreateMode { topic, post }

class CreateScreen extends StatefulWidget {
  final CreateMode createMode;

  const CreateScreen({super.key, required this.createMode});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  late final TopicBloc _topicBloc;
  late final PostBloc _postBloc;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _topicBloc = BlocProvider.of<TopicBloc>(context);
    _postBloc = BlocProvider.of<PostBloc>(context);

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
                  _buildCreateButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return CustomAppBar(
          title: state.level == 0 ? 'Create topic' : 'Create post',
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          delay: false,
        );
      },
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

  Widget _buildCreateButton() {
    return Padding(
      padding: const EdgeInsets.only(
        top: Dimens.baselineGrid * 3,
      ),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return state.level == 0 ? _buildTopicButton() : _buildPostButton();
        },
      ),
    );
  }

  Widget _buildTopicButton() {
    return AppButton(
      onTap: _onCreateTapTopic,
      child: BlocConsumer<TopicBloc, TopicState>(
        listenWhen: (previous, current) => previous is TopicLoading && previous.status == TopicLoadingStatus.create,
        listener: (context, state) {
          if (state is TopicLoaded) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is TopicLoading && state.status == TopicLoadingStatus.create) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const Text('Create topic');
        },
      ),
    );
  }

  Widget _buildPostButton() {
    return AppButton(
      onTap: _onCreateTapPost,
      child: BlocConsumer<PostBloc, PostState>(
        listenWhen: (previous, current) => previous is PostLoading && previous.status == PostLoadingStatus.create,
        listener: (context, state) {
          if (state is PostLoaded) {
            Navigator.pop(context);
          } else if (state is PostFailure) {
            _showMyDialog(state.message);
          }
        },
        builder: (context, state) {
          if (state is PostLoading && state.status == PostLoadingStatus.create) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const Text('Create post');
        },
      ),
    );
  }

  void _onCreateTapTopic() {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _topicBloc.state is! TopicLoading) {
      _topicBloc.add(
        TopicCreate(
          editable: Editable(
            name: _titleController.text,
            description: _descriptionController.text,
          ),
        ),
      );
    }
  }

  void _onCreateTapPost() {
    if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty && _postBloc.state is! PostLoading) {
      _postBloc.add(
        PostCreate(
          post: Post(
            name: _titleController.text,
            description: _descriptionController.text,
            downvotes: 0,
            id: '',
            topicId: '',
            upvotes: 0,
            userId: '',
            downvotedUsers: const [],
            upvotedUsers: const [],
          ),
          topicId: _postBloc.state.topicId!,
        ),
      );
    }
  }

  Future<void> _showMyDialog(String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimens.cornerRadius))),
          title: const Text('Something went wrong', style: AppTextStyles.header),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message, style: AppTextStyles.description.copyWith(fontSize: 16)),
              ],
            ),
          ),
          actions: <Widget>[
            AppButton(
              onTap: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
