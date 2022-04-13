import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../domain/entities/pomodoro.dart';
import 'ticker.dart';
import 'package:equatable/equatable.dart';
part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  //static const int _duration = 60;
  //static const int _session = 1;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const LoadingState(0, 0, false, false)) {
    on<TimerSet>(_onSet);
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    //on<TimerReset>(_onReset);
    on<TimerTicked>(_onTicked);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onSet(TimerSet event, Emitter<TimerState> emit) {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(
      TimerInitial(
        event.data.durationMinutes,
        event.data.session,
        false,
        false,
      ),
    );
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
          : const TimerRunComplete(0, 0, false, true),
    );
  }
}
