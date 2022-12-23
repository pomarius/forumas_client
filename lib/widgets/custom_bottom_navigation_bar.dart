import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../constants/theme/dimens.dart';
import '../screens/create_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
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
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2))),
      ),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: Dimens.baselineGrid * 2),
                  child: _buildItem(Icon(state.index == 0 ? Icons.home : Icons.home_outlined, size: 28), 0),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.baselineGrid * 2),
                  child: _buildAddButton(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: Dimens.baselineGrid * 2),
                  child: _buildItem(Icon(state.index == 1 ? Icons.person : Icons.person_outlined, size: 28), 1),
                ),
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
            child: Padding(
              padding: const EdgeInsets.all(Dimens.baselineGrid * 2),
              child: Icon(
                Icons.add_outlined,
                color: Theme.of(context).colorScheme.onPrimary,
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

  Widget _buildItem(Icon icon, int index) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.cornerRadius)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _naviagtionBloc.add(NavigationIndex(index)),
          child: Padding(
            padding: const EdgeInsets.all(Dimens.baselineGrid * 2),
            child: icon,
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
