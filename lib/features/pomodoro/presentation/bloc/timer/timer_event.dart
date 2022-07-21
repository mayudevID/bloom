part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class SetUserData extends TimerEvent {
  const SetUserData(this.data);

  final PomodoroModel data;
}

class TimerSet extends TimerEvent {
  const TimerSet(this.data);
  final PomodoroModel data;
}

class TimerStarted extends TimerEvent {
  const TimerStarted(this.duration, this.session);
  final int duration, session;
}

class TimerPaused extends TimerEvent {
  const TimerPaused();
}

class TimerResumed extends TimerEvent {
  const TimerResumed();
}

class TimerReset extends TimerEvent {
  const TimerReset();
}

class TimerTicked extends TimerEvent {
  const TimerTicked({required this.duration});
  final int duration;

  @override
  List<Object> get props => [duration];
}
