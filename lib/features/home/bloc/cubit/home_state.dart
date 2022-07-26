part of 'home_cubit.dart';

enum HomeTab { home, pomodoro, habit, todo }

enum LoadStatus { initial, open, close }

class HomeState extends Equatable {
  const HomeState({
    this.tab = HomeTab.home,
    this.status = LoadStatus.initial,
  });

  final HomeTab tab;
  final LoadStatus status;

  @override
  List<Object> get props => [tab, status];
}
