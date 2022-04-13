import 'package:bloc/bloc.dart';
import 'package:bloom/core/utils/function.dart';
import 'package:bloom/features/pomodoro/domain/repositories/pomodoro_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/pomodoro.dart';

part 'add_pomodoro_state.dart';

class AddPomodoroCubit extends Cubit<AddPomodoroState> {
  final PomodoroRepository pomodoroRepository;
  AddPomodoroCubit(this.pomodoroRepository) : super(AddPomodoroState.initial());

  void titleChanged(String value) {
    emit(state.copyWith(title: value));
  }

  void durationChanged(int value) {
    emit(state.copyWith(duration: value));
  }

  void sessionChanged(int value) {
    emit(state.copyWith(session: value));
  }

  Future<void> addPomodoro() async {
    if (state.status == AddPomodoroStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: AddPomodoroStatus.submitting));
    try {
      Pomodoro dataPomodoro = Pomodoro(
        pomodoroId: getRandomId(),
        title: state.title,
        durationMinutes: state.duration,
        session: state.session,
      );
      await pomodoroRepository.addPomodoro(dataPomodoro);
      emit(state.copyWith(status: AddPomodoroStatus.success));
    } catch (e) {}
  }
}
