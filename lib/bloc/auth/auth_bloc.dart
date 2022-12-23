import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthReSignIn>(_onAuthReSignIn);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignOut>(_onAuthSignOut);
    on<AuthSetStatus>(_onAuthSetStatus);
  }

  Future<void> _onAuthReSignIn(AuthReSignIn event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.reSignIn();

      final List<String> user = await _authRepository.getUserId();
      emit(AuthSignedIn(userId: user[0], username: user[1]));
    } catch (error) {
      emit(const AuthSignedOut(authStatus: AuthStatus.signIn));
    }
  }

  Future<void> _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(const AuthLoading(authLoadingStatus: AuthLoadingStatus.signIn));
    try {
      await _authRepository.signIn(event.username, event.password);
      final List<String> user = await _authRepository.getUserId();
      emit(AuthSignedIn(userId: user[0], username: user[1]));
    } catch (error) {
      emit(AuthFailure(message: error.toString()));
    }
  }

  Future<void> _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(const AuthLoading(authLoadingStatus: AuthLoadingStatus.signUp));
    try {
      await _authRepository.signUp(event.username, event.password);

      final List<String> user = await _authRepository.getUserId();
      emit(AuthSignedIn(userId: user[0], username: user[1]));
    } catch (error) {
      emit(const AuthSignedOut(authStatus: AuthStatus.signUp));
    }
  }

  Future<void> _onAuthSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    emit(const AuthLoading(authLoadingStatus: AuthLoadingStatus.signOut));
    await _authRepository.signOut();
    emit(const AuthSignedOut(authStatus: AuthStatus.signIn));
  }

  Future<void> _onAuthSetStatus(AuthSetStatus event, Emitter<AuthState> emit) async {
    if (state is AuthSignedOut) {
      emit(AuthSignedOut(authStatus: event.authStatus));
    }
  }
}
