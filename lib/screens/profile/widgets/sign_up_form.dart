import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth/auth_bloc.dart';
import '../../../constants/theme/app_text_styles.dart';
import '../../../constants/theme/dimens.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_button.dart';
import '../../../widgets/app_text_field.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  late final AuthBloc _authBloc;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

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
            _buildConfirmTextField(),
            _buildSignUpButton(),
            _buildSignInButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.baselineGrid * 2),
      child: Text(
        'Create an account',
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
      padding: const EdgeInsets.only(bottom: Dimens.baselineGrid * 2),
      child: AppTextField(
        controller: _passwordController,
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outlined),
        obscureText: true,
      ),
    );
  }

  Widget _buildConfirmTextField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.baselineGrid * 4),
      child: AppTextField(
        controller: _confirmController,
        labelText: 'Confirm password',
        prefixIcon: const Icon(Icons.lock_outlined),
        obscureText: true,
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.baselineGrid * 2),
      child: AppButton(
        onTap: _onSignUpTap,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading && state.authLoadingStatus == AuthLoadingStatus.signUp) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const Text('Sign up');
          },
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return AppTextButton(
      onTap: _onSignInTap,
      text: 'Already have an account?',
    );
  }

  void _onSignUpTap() {
    if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty && _authBloc.state is! AuthLoading) {
      if (_passwordController.text != _confirmController.text) {
        _showMyDialog('Passwords do not match');
        return;
      }

      _authBloc.add(AuthSignUp(username: _usernameController.text, password: _passwordController.text));
    }
  }

  void _onSignInTap() {
    _authBloc.add(const AuthSetStatus(authStatus: AuthStatus.signIn));
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
