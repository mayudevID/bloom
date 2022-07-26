import 'package:bloc/bloc.dart';
import 'package:bloom/features/habit/domain/habits_repository.dart';
import 'package:bloom/features/pomodoro/domain/pomodoros_repository.dart';
import 'package:bloom/features/todolist/domain/todos_repository.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required PomodorosRepository pomodorosRepository,
    required TodosRepository todosRepository,
    required HabitsRepository habitsRepository,
  })  : _pomodorosRepository = pomodorosRepository,
        _todosRepository = todosRepository,
        _habitsRepository = habitsRepository,
        super(const HomeState());

  final PomodorosRepository _pomodorosRepository;
  final TodosRepository _todosRepository;
  final HabitsRepository _habitsRepository;

  void setTab(HomeTab tab) {
    emit(HomeState(tab: tab, status: LoadStatus.done));
  }

  Future<void> getDataBackup(bool isGetData) async {
    if (isGetData == false) {
      emit(const HomeState(status: LoadStatus.finish));
      return;
    }
    emit(const HomeState(status: LoadStatus.load));

    await Future.delayed(const Duration(seconds: 3));

    emit(const HomeState(status: LoadStatus.finish));
  }

  void finishToDone() {
    emit(const HomeState(status: LoadStatus.done));
  }
}
