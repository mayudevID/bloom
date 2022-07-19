import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloom/features/authentication/data/repositories/local_auth_repository.dart';
import 'package:bloom/features/pomodoro/data/models/pomodoro_model.dart';
import '../../../../authentication/data/models/user_data.dart';
import 'ticker.dart';
import 'package:equatable/equatable.dart';
part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  final LocalUserDataRepository _localUserDataRepository;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({
    required Ticker ticker,
    required LocalUserDataRepository localUserDataRepository,
  })  : _ticker = ticker,
        _localUserDataRepository = localUserDataRepository,
        super(const LoadingState(0, 0, false, false)) {
    on<TimerSet>(_onSet);
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    //on<TimerReset>(_onReset);
    on<TimerTicked>(_onTicked);
    on<SetUserData>(_setUserData);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  Future<void> _setUserData(SetUserData event, Emitter<TimerState> emit) async {
    final currUserData = await _localUserDataRepository.getUserData().first;
    final newUserData = UserData(
      userId: currUserData.userId,
      email: currUserData.email,
      photoURL: currUserData.photoURL,
      name: currUserData.name,
      habitStreak: currUserData.habitStreak,
      taskCompleted: currUserData.taskCompleted,
      totalFocus:
          currUserData.totalFocus + (state.duration * state.session / 60),
      missed: currUserData.missed,
      completed: currUserData.completed,
      streakLeft: currUserData.streakLeft,
    );
    await _localUserDataRepository.saveUserData(newUserData);
  }

  void _onSet(TimerSet event, Emitter<TimerState> emit) async {
    emit(
      TimerInitial(
        event.data.durationMinutes * 60,
        (state.session == 0) ? 1 : state.session + 1,
        false,
        false,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 500));
    _onStarted(TimerStarted(state.duration, state.session), emit);
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(event.duration, event.session, true, false));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.duration, state.session, false, false));
    }
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration, state.session, true, false));
    }
  }

  // void _onReset(TimerReset event, Emitter<TimerState> emit) {
  //   _tickerSubscription?.cancel();
  //   emit(const TimerInitial(_duration, _session, false, false));
  // }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(
      event.duration > 0
          ? TimerRunInProgress(event.duration, state.session, true, false)
          : TimerRunComplete(0, state.session, false, true),
    );
  }
}
