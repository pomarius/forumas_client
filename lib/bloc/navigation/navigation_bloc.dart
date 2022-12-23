import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState(0, 0)) {
    on<NavigationIndex>(_onNavigationIndex);
    on<NavigationLevel>(_onNavigationLevel);
  }

  Future<void> _onNavigationIndex(NavigationIndex event, Emitter<NavigationState> emit) async {
    emit(NavigationState(event.index, state.level));
  }

  Future<void> _onNavigationLevel(NavigationLevel event, Emitter<NavigationState> emit) async {
    emit(NavigationState(state.index, event.level));
  }
}
