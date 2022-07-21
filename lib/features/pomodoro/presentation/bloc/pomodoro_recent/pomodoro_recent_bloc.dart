import 'package:bloc/bloc.dart';
import 'package:bloom/features/pomodoro/data/models/pomodoro_model.dart';
import 'package:bloom/features/pomodoro/domain/pomodoros_repository.dart';
import 'package:equatable/equatable.dart';

part 'pomodoro_recent_event.dart';
part 'pomodoro_recent_state.dart';

class PomodoroRecentBloc
    extends Bloc<PomodoroRecentEvent, PomodoroRecentState> {
  PomodoroRecentBloc({required PomodorosRepository pomodorosRepository})
      : _pomodoroRepository = pomodorosRepository,
        super(PomodoroRecentState()) {
    on<PomodoroRecentSubscriptionRequested>(_onSubscriptionRequested);
    on<PomodoroRecentSaved>(_onRecentSaved);
  }

  final PomodorosRepository _pomodoroRepository;

  Future<void> _onSubscriptionRequested(
    PomodoroRecentSubscriptionRequested event,
    Emitter<PomodoroRecentState> emit,
  ) async {
    emit(state.copyWith(status: () => PomodoroRecentStatus.loading));

    await emit.forEach<PomodoroModel>(
      _pomodoroRepository.getRecentList(),
      onData: (pomodoro) => state.copyWith(
        status: () => PomodoroRecentStatus.success,
        pomodoro: () => pomodoro,
      ),
      onError: (_, __) => state.copyWith(
        status: () => PomodoroRecentStatus.failure,
      ),
    );
  }

  Future<void> _onRecentSaved(
    PomodoroRecentSaved event,
    Emitter<PomodoroRecentState> emit,
  ) async {
    await _pomodoroRepository.saveRecentList(event.pomodoroModel);
  }
}
