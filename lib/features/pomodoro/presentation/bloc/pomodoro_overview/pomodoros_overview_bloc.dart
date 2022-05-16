import 'package:bloc/bloc.dart';
import 'package:bloom/features/pomodoro/data/models/pomodoro_model.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/pomodoros_repository.dart';

part 'pomodoros_overview_event.dart';
part 'pomodoros_overview_state.dart';

class PomodorosOverviewBloc
    extends Bloc<PomodorosOverviewEvent, PomodorosOverviewState> {
  PomodorosOverviewBloc({
    required PomodorosRepository pomodorosRepository,
  })  : _pomodorosRepository = pomodorosRepository,
        super(PomodorosOverviewState()) {
    on<PomodorosOverviewSubscriptionRequested>(_onSubscriptionRequested);
    //on<PomodorosOverviewPomodoroCompletionToggled>(_onPomodoroCompletionToggled);
    on<PomodorosOverviewPomodoroDeleted>(_onPomodoroDeleted);
    on<PomodorosOverviewUndoDeletionRequested>(_onUndoDeletionRequested);
    on<PomodorosOverviewFilterChanged>(_onFilterChanged);
    //on<PomodorosOverviewToggleAllRequested>(_onToggleAllRequested);
    //on<PomodorosOverviewClearCompletedRequested>(_onClearCompletedRequested);
  }

  final PomodorosRepository _pomodorosRepository;

  Future<void> _onSubscriptionRequested(
    PomodorosOverviewSubscriptionRequested event,
    Emitter<PomodorosOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => PomodorosOverviewStatus.loading));

    await emit.forEach<List<PomodoroModel>>(
      _pomodorosRepository.getPomodoros(),
      onData: (pomodoros) => state.copyWith(
        status: () => PomodorosOverviewStatus.success,
        pomodoros: () => pomodoros,
      ),
      onError: (_, __) => state.copyWith(
        status: () => PomodorosOverviewStatus.failure,
      ),
    );
  }

  // Future<void> _onPomodoroCompletionToggled(
  //   PomodorosOverviewPomodoroCompletionToggled event,
  //   Emitter<PomodorosOverviewState> emit,
  // ) async {
  //   final newPomodoro = event.pomodoro.copyWith(isCompleted: event.isCompleted);
  //   await _pomodorosRepository.savePomodoro(newPomodoro);
  // }

  Future<void> _onPomodoroDeleted(
    PomodorosOverviewPomodoroDeleted event,
    Emitter<PomodorosOverviewState> emit,
  ) async {
    emit(state.copyWith(lastDeletedPomodoro: () => event.pomodoro));
    await _pomodorosRepository
        .deletePomodoro(event.pomodoro.pomodoroId.toString());
  }

  Future<void> _onUndoDeletionRequested(
    PomodorosOverviewUndoDeletionRequested event,
    Emitter<PomodorosOverviewState> emit,
  ) async {
    assert(
      state.lastDeletedPomodoro != null,
      'Last deleted pomodoro can not be null.',
    );

    final pomodoro = state.lastDeletedPomodoro!;
    emit(state.copyWith(lastDeletedPomodoro: () => null));
    await _pomodorosRepository.savePomodoro(pomodoro);
  }

  void _onFilterChanged(
    PomodorosOverviewFilterChanged event,
    Emitter<PomodorosOverviewState> emit,
  ) {
    emit(state.copyWith(filter: () => event.filter));
  }

  // Future<void> _onToggleAllRequested(
  //   PomodorosOverviewToggleAllRequested event,
  //   Emitter<PomodorosOverviewState> emit,
  // ) async {
  //   final areAllCompleted = state.pomodoros.every((pomodoro) => pomodoro.isCompleted);
  //   await _pomodorosRepository.completeAll(isCompleted: !areAllCompleted);
  // }

  // Future<void> _onClearCompletedRequested(
  //   PomodorosOverviewClearCompletedRequested event,
  //   Emitter<PomodorosOverviewState> emit,
  // ) async {
  //   await _pomodorosRepository.clearCompleted();
  // }
}
