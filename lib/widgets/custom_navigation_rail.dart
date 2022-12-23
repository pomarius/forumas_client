import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../constants/theme/dimens.dart';
import '../screens/create_screen.dart';

class CustomNavigationRail extends StatefulWidget {
  final bool showLabels;

  const CustomNavigationRail({Key? key, this.showLabels = false}) : super(key: key);

  @override
  State<CustomNavigationRail> createState() => _CustomNavigationRailState();
}

class _CustomNavigationRailState extends State<CustomNavigationRail> {
  late final NavigationBloc _naviagtionBloc;
  late final AuthBloc _authBloc;

  @override
  void initState() {
    _naviagtionBloc = BlocProvider.of<NavigationBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(right: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2))),
      ),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: Dimens.baselineGrid * 2,
                  left: Dimens.baselineGrid * 2,
                  right: Dimens.baselineGrid * 2,
                ),
                child: _buildItem(
                  Icon(state.index == 0 ? Icons.home : Icons.home_outlined, size: 28),
                  'Home',
                  0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: Dimens.baselineGrid * 2,
                  left: Dimens.baselineGrid * 2,
                  right: Dimens.baselineGrid * 2,
                ),
                child: _buildItem(
                  Icon(state.index == 1 ? Icons.person : Icons.person_outlined, size: 28),
                  'Profile',
                  1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Dimens.baselineGrid * 2),
                child: _buildAddButton(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddButton() {
    return OpenContainer(
      tappable: false,
      clipBehavior: Clip.antiAlias,
      closedColor: Theme.of(context).colorScheme.primary,
      transitionType: ContainerTransitionType.fadeThrough,
      closedElevation: 0,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(Dimens.baselineGrid)),
      ),
      closedBuilder: (context, action) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onAddTap(action),
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: widget.showLabels
                  ? const EdgeInsets.only(
                      top: Dimens.baselineGrid * 2,
                      bottom: Dimens.baselineGrid * 2,
                      left: Dimens.baselineGrid * 6.5,
                      right: Dimens.baselineGrid * 6.5,
                    )
                  : const EdgeInsets.all(Dimens.baselineGrid * 2),
              child: Icon(
                Icons.add_outlined,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 28,
              ),
            ),
          ),
        );
      },
      openBuilder: (context, action) {
        return CreateScreen(
          createMode: _naviagtionBloc.state.level == 0 ? CreateMode.topic : CreateMode.post,
        );
      },
    );
  }

  Widget _buildItem(Icon icon, String label, int index) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.cornerRadius)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _naviagtionBloc.add(NavigationIndex(index)),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimens.baselineGrid * 2),
                child: icon,
              ),
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
                child: widget.showLabels
                    ? Padding(
                        padding: const EdgeInsets.only(right: Dimens.baselineGrid * 2),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAddTap(void Function() action) {
    if (_authBloc.state is AuthSignedIn) {
      action.call();
    } else {
      _naviagtionBloc.add(const NavigationIndex(1));
    }
  }
}
