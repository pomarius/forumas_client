import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';

import '../../constants/theme/app_text_styles.dart';
import '../../constants/theme/dimens.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import 'widgets/sign_in_form.dart';
import 'widgets/sign_up_form.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return const CustomAppBar(title: 'Profile');
  }

  Widget _buildBody() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: BlocConsumer<AuthBloc, AuthState>(
        buildWhen: (previous, current) => current is! AuthLoading && current is! AuthFailure,
        listener: (context, state) {
          if (state is AuthFailure) {
            _showMyDialog(state.message);
          }
        },
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              late final Animation<Offset> position;

              if (child.key == const ValueKey('sign_in')) {
                position = Tween(begin: const Offset(-1, 0), end: Offset.zero).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                );
              } else {
                position = Tween(begin: const Offset(1, 0), end: Offset.zero).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                );
              }

              return SlideTransition(
                position: position,
                child: child,
              );
            },
            child: _buildPage(state),
          );
        },
      ),
    );
  }

  Widget _buildPage(AuthState state) {
    if (state is AuthSignedOut && state.authStatus == AuthStatus.signIn) {
      return const SignInForm(key: ValueKey('sign_in'));
    } else if (state is AuthSignedOut && state.authStatus == AuthStatus.signUp) {
      return const SignUpForm(key: ValueKey('sign_up'));
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        margin: EdgeInsets.only(
          left: Dimens.baselineGrid * 2,
          right: Dimens.baselineGrid * 2,
          top: Dimens.baselineGrid * 2,
          bottom: MediaQuery.of(context).padding.bottom + Dimens.baselineGrid * 2,
        ),
        padding: const EdgeInsets.all(Dimens.baselineGrid * 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(Dimens.cornerRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildSignOutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Dimens.baselineGrid * 4),
          child: Text(
            state is AuthSignedIn ? 'Hello ${state.username}' : 'Hello Surname!',
            style: AppTextStyles.header.copyWith(color: Theme.of(context).colorScheme.onSurface),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  Widget _buildSignOutButton() {
    return AppButton(
      backgroundColor: Theme.of(context).colorScheme.error,
      foregroundColor: Theme.of(context).colorScheme.onError,
      onTap: _onSignOutTap,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading && state.authLoadingStatus == AuthLoadingStatus.signOut) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const Text('Sign out');
        },
      ),
    );
  }

  void _onSignOutTap() {
    if (_authBloc.state is! AuthLoading) {
      _authBloc.add(AuthSignOut());
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
