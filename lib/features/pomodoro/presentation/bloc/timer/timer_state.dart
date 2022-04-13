part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final int duration;
  final int session;
  final bool isRunning;
  final bool isCompleted;

  const TimerState(
    this.duration,
    this.session,
    this.isRunning,
    this.isCompleted,
  );

  @override
  List<Object> get props => [duration];
}

class TimerInitial extends TimerState {
  const TimerInitial(
    int duration,
    int session,
    bool isRunning,
    bool isCompleted,
  ) : super(
          duration,
          session,
          isRunning,
          isCompleted,
        );

  @override
  String toString() => 'TimerInitial { duration: $duration }';
}

class TimerRunPause extends TimerState {
  const TimerRunPause(
    int duration,
    int session,
    bool isRunning,
    bool isCompleted,
  ) : super(
          duration,
          session,
          isRunning,
          isCompleted,
        );

  @override
  String toString() => 'TimerRunPause { duration: $duration }';
}

class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(
    int duration,
    int session,
    bool isRunning,
    bool isCompleted,
  ) : super(
          duration,
          session,
          isRunning,
          isCompleted,
        );

  @override
  String toString() => 'TimerRunInProgress { duration: $duration }';
}

class TimerRunComplete extends TimerState {
  const TimerRunComplete(
    int duration,
    int session,
    bool isRunning,
    bool isCompleted,
  ) : super(
          duration,
          session,
          isRunning,
          isCompleted,
        );
}

class LoadingState extends TimerState {
  const LoadingState(
    int duration,
    int session,
    bool isRunning,
    bool isCompleted,
  ) : super(
          duration,
          session,
          isRunning,
          isCompleted,
        );
}
