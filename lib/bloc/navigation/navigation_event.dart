part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class NavigationIndex extends NavigationEvent {
  final int index;

  const NavigationIndex(this.index);

  @override
  List<Object> get props => [index];
}

class NavigationLevel extends NavigationEvent {
  final int level;

  const NavigationLevel(this.level);

  @override
  List<Object> get props => [level];
}
