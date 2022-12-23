import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth/auth_bloc.dart';
import '../../../constants/theme/app_text_styles.dart';
import '../../../constants/theme/dimens.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_button.dart';
import '../../../widgets/app_text_field.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  late final AuthBloc _authBloc;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildForm();
  }

  Widget _buildForm() {
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
            _buildUsernameTextField(),
            _buildPasswordTextField(),
            _buildSignInButton(),
            _buildSignUpButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.baselineGrid * 2),
      child: Text(
        'Welcome back!',
        style: AppTextStyles.header.copyWith(color: Theme.of(context).colorScheme.onSurface),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildUsernameTextField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.baselineGrid * 2),
      child: AppTextField(
        controller: _usernameController,
        labelText: 'Username',
        prefixIcon: const Icon(Icons.person_outlined),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.baselineGrid * 4),
      child: AppTextField(
        controller: _passwordController,
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outlined),
        obscureText: true,
      ),
    );
  }

  Widget _buildSignInButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.baselineGrid * 2),
      child: AppButton(
        onTap: _onSignInTap,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading && state.authLoadingStatus == AuthLoadingStatus.signIn) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const Text('Sign in');
          },
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return AppTextButton(
      onTap: _onSignUpTap,
      text: 'Need an account?',
    );
  }

  void _onSignInTap() {
    if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty && _authBloc.state is! AuthLoading) {
      _authBloc.add(AuthSignIn(
        username: _usernameController.text,
        password: _passwordController.text,
      ));
    }
  }

  void _onSignUpTap() {
    _authBloc.add(const AuthSetStatus(authStatus: AuthStatus.signUp));
  }
}
