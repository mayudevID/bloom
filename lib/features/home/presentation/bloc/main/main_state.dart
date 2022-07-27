part of 'main_cubit.dart';

enum MainTab { home, pomodoro, habit, todo }

enum LoadStatus { initial, load, finish, done }

class MainState extends Equatable {
  const MainState({
    this.tab = MainTab.home,
    this.status = LoadStatus.initial,
  });

  final MainTab tab;
  final LoadStatus status;

  @override
  List<Object> get props => [tab, status];
}
