import 'package:bloc/bloc.dart';
import 'package:bloom/core/utils/function.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/pomodoros_repository.dart';
part 'add_pomodoro_state.dart';

class AddPomodoroCubit extends Cubit<AddPomodoroState> {
  final PomodorosRepository _pomodorosRepository;

  AddPomodoroCubit(this._pomodorosRepository)
      : super(AddPomodoroState.initial());

  void titleChanged(String value) {
    emit(state.copyWith(title: value));
  }

  void durationChanged(int value) {
    emit(state.copyWith(duration: value));
  }

  void sessionChanged(int value) {
    emit(state.copyWith(session: value));
  }

  void savePomodoro() async {
    try {} catch (e) {}
  }
}
