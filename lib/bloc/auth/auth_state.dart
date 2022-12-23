part of 'auth_bloc.dart';

enum AuthLoadingStatus { signIn, signUp, signOut }

enum AuthStatus { signIn, signUp }

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final AuthLoadingStatus authLoadingStatus;

  const AuthLoading({required this.authLoadingStatus});

  @override
  List<Object> get props => [authLoadingStatus];
}

class AuthSignedIn extends AuthState {
  final String userId;
  final String username;

  const AuthSignedIn({required this.userId, required this.username});

  @override
  List<Object> get props => [userId, username];
}

class AuthSignedOut extends AuthState {
  final AuthStatus? authStatus;

  const AuthSignedOut({this.authStatus});

  @override
  List<Object?> get props => [authStatus];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}
