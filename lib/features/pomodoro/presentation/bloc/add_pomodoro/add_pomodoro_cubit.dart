import 'package:bloc/bloc.dart';
import 'package:bloom/core/utils/function.dart';
import 'package:bloom/features/pomodoro/data/models/pomodoro_model.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/pomodoros_repository.dart';
part 'add_pomodoro_state.dart';

class AddPomodoroCubit extends Cubit<AddPomodoroState> {
  final PomodorosRepository _pomodorosRepository;

  AddPomodoroCubit(this._pomodorosRepository)
      : super(AddPomodoroState.initial());

  void titleChanged(String value) {
    emit(state.copyWith(title: value, status: AddPomodoroStatus.initial));
  }

  void durationChanged(int value) {
    emit(state.copyWith(duration: value, status: AddPomodoroStatus.initial));
  }

  void sessionChanged(int value) {
    emit(state.copyWith(session: value, status: AddPomodoroStatus.initial));
  }

  void savePomodoro() async {
    if (state.status == AddPomodoroStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: AddPomodoroStatus.initial));
    emit(state.copyWith(status: AddPomodoroStatus.submitting));
    try {
      PomodoroModel pomodoro = PomodoroModel(
        pomodoroId: getRandomId(),
        title: state.title,
        durationMinutes: state.duration,
        session: state.session,
      );

      await _pomodorosRepository.savePomodoro(pomodoro);
      emit(state.copyWith(status: AddPomodoroStatus.success));
    } catch (e) {
      throw Exception();
    }
  }
}
