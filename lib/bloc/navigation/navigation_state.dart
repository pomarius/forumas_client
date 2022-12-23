part of 'navigation_bloc.dart';

class NavigationState extends Equatable {
  final int index;
  final int level;

  const NavigationState(this.index, this.level);

  @override
  List<Object> get props => [index, level];
}
