import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/post/post_bloc.dart';
import '../bloc/topic/topic_bloc.dart';
import '../constants/theme/dimens.dart';
import '../widgets/animated_indexed_stack.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/custom_navigation_rail.dart';
import 'profile/profile_screen.dart';
import 'topics_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late final TopicBloc _topicBloc;
  late final AuthBloc _authBloc;
  late final PostBloc _postBloc;

  @override
  void initState() {
    _topicBloc = BlocProvider.of<TopicBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _postBloc = BlocProvider.of<PostBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          extendBody: true,
          bottomNavigationBar: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: child,
              );
            },
            child: constraints.maxWidth <= 800 ? const CustomBottomNavigationBar() : const SizedBox(),
          ),
          body: Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (child, animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                    child: child,
                  );
                },
                child: constraints.maxWidth > 1165
                    ? const CustomNavigationRail(showLabels: true)
                    : constraints.maxWidth > 800
                        ? const CustomNavigationRail()
                        : const SizedBox(),
              ),
              Expanded(
                child: BlocConsumer<TopicBloc, TopicState>(
                  buildWhen: (previous, current) => current is! TopicLoading,
                  listenWhen: (previous, current) =>
                      previous is TopicLoading && previous.status == TopicLoadingStatus.load,
                  listener: (context, state) {
                    _authBloc.add(AuthReSignIn());
                  },
                  builder: (context, topicState) {
                    return BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSignedIn) {
                          _topicBloc.add(TopicSort(userId: state.userId));
                          _postBloc.add(PostSort(userId: state.userId));
                        } else {
                          _topicBloc.add(const TopicSort());
                          _postBloc.add(const PostSort());
                        }
                      },
                      buildWhen: (previous, current) => current is! AuthLoading && current is! AuthFailure,
                      builder: (context, authState) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder: (child, animation) {
                            late final Animation<Offset> position;

                            if (child.key == const ValueKey('loading')) {
                              position = Tween(begin: const Offset(0, -1), end: Offset.zero).animate(
                                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                              );
                            } else {
                              position = Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
                                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                              );
                            }

                            return SlideTransition(
                              position: position,
                              child: child,
                            );
                          },
                          child: _buildPage(topicState, authState),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPage(TopicState topicState, AuthState authState) {
    if ((authState is AuthSignedIn || authState is AuthSignedOut) &&
        (topicState is TopicLoaded || topicState is TopicFailure)) {
      return Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return BlocBuilder<NavigationBloc, NavigationState>(
                buildWhen: (previous, current) => current.level == 0,
                builder: (context, state) {
                  return AnimatedIndexedStack(
                    index: state.index,
                    children: const [
                      TopicsScreen(),
                      ProfileScreen(),
                    ],
                  );
                },
              );
            },
          );
        },
      );
    }

    return Center(
      key: const ValueKey('loading'),
      child: Container(
        margin: const EdgeInsets.all(Dimens.baselineGrid * 2),
        padding: const EdgeInsets.all(Dimens.baselineGrid * 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(Dimens.cornerRadius),
        ),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
