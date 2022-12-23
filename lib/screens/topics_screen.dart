import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/topic/topic_bloc.dart';
import '../constants/theme/app_text_styles.dart';
import '../constants/theme/dimens.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/topic_tile.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
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
              _buildItems(padding),
              BlocBuilder<TopicBloc, TopicState>(
                builder: (context, state) {
                  if ((state is TopicLoaded && state.topics.isEmpty) || state is TopicFailure) {
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
    );
  }

  Widget _buildAppBar() {
    return const CustomAppBar(title: 'Forumas');
  }

  Widget _buildItems(double padding) {
    return BlocBuilder<TopicBloc, TopicState>(
      buildWhen: (previous, current) => current is! TopicLoading,
      builder: (context, state) {
        if (state is TopicLoaded && state.topics.isNotEmpty) {
          return SliverPadding(
            padding: EdgeInsets.only(
              top: Dimens.baselineGrid * 2,
              left: padding,
              right: padding,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return TopicTile(topic: state.topics[index]);
                },
                childCount: state.topics.length,
              ),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 800,
                childAspectRatio: 2,
                crossAxisSpacing: Dimens.baselineGrid * 2,
                mainAxisSpacing: Dimens.baselineGrid * 2,
              ),
            ),
          );
        } else if (state is TopicLoaded) {
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
                      'No topics have been created :(',
                      style: AppTextStyles.title2.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(height: Dimens.baselineGrid * 2),
                  ],
                ),
              ),
            ),
          );
        } else if (state is TopicFailure) {
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
