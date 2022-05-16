import 'package:bloc/bloc.dart';
import 'package:bloom/features/pomodoro/data/models/pomodoro_model.dart';
import 'package:equatable/equatable.dart';

part 'pomodoro_recent_event.dart';
part 'pomodoro_recent_state.dart';

class PomodoroRecentBloc
    extends Bloc<PomodoroRecentEvent, PomodoroRecentState> {
  PomodoroRecentBloc() : super(PomodoroRecentInitial()) {
    on<PomodoroRecentEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
