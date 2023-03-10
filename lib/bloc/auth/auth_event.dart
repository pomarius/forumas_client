part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthReSignIn extends AuthEvent {}

class AuthSignIn extends AuthEvent {
  final String username;
  final String password;

  const AuthSignIn({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class AuthSignUp extends AuthEvent {
  final String username;
  final String password;

  const AuthSignUp({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class AuthSignOut extends AuthEvent {}

class AuthSetStatus extends AuthEvent {
  final AuthStatus authStatus;

  const AuthSetStatus({required this.authStatus});

  @override
  List<Object> get props => [authStatus];
}
