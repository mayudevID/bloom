import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/pomodoro.dart';

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
