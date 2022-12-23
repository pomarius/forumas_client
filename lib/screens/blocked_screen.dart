import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/topic/topic_bloc.dart';
import '../models/topic.dart';
import '../constants/theme/app_text_styles.dart';
import '../constants/theme/dimens.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/user_tile.dart';

class BlockedScreen extends StatefulWidget {
  final Topic topic;

  const BlockedScreen({super.key, required this.topic});

  @override
  State<BlockedScreen> createState() => _BlockedScreenState();
}

class _BlockedScreenState extends State<BlockedScreen> {
  late final TopicBloc _topicBloc;
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    _topicBloc = BlocProvider.of<TopicBloc>(context);
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
              _buildTitle(padding),
              _buildUsernameCard(padding),
              _buildItems(padding),
              SliverToBoxAdapter(
                child: SizedBox(height: MediaQuery.of(context).padding.bottom + Dimens.baselineGrid * 2),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return CustomAppBar(
      title: 'Block users',
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

  Widget _buildTitle(double padding) {
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
          widget.topic.name,
          style: AppTextStyles.description.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameCard(double padding) {
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
            _buildUsernameField(),
            _buildBlockButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return AppTextField(
      controller: _usernameController,
      labelText: 'Username',
      prefixIcon: const Icon(Icons.person_outlined),
      expands: true,
    );
  }

  Widget _buildBlockButton() {
    return Padding(
      padding: const EdgeInsets.only(top: Dimens.baselineGrid * 3),
      child: AppButton(
        onTap: _onBlockTAp,
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
        child: BlocConsumer<TopicBloc, TopicState>(
          listenWhen: (previous, current) =>
              previous is TopicLoading && previous.status == TopicLoadingStatus.block && previous.id == widget.topic.id,
          listener: (context, state) {
            if (state is TopicLoaded) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is TopicLoading && state.status == TopicLoadingStatus.block && state.id == widget.topic.id) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const Text('Block user');
          },
        ),
      ),
    );
  }

  Widget _buildItems(double padding) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return UserTile(
              index: index,
              lastIndex: widget.topic.blocked.length - 1,
              username: widget.topic.blocked[index].username,
            );
          },
          childCount: widget.topic.blocked.length,
        ),
      ),
    );
  }

  void _onBlockTAp() {
    if (_topicBloc.state is! TopicLoading && _usernameController.text.isNotEmpty) {
      _topicBloc.add(TopicBlockUser(topic: widget.topic, username: _usernameController.text));
    }
  }
}
