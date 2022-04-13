import 'package:bloc/bloc.dart';
import 'package:bloom/features/pomodoro/domain/usecases/delete_pomodoro.dart';
import 'package:bloom/features/pomodoro/domain/usecases/get_pomodoro.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/pomodoro.dart';

part 'pomodoro_event.dart';
part 'pomodoro_state.dart';

class PomodoroBloc extends Bloc<PomodoroEvent, PomodoroState> {
  final GetPomodoro getPomodoro;
  final DeletePomodoro deletePomodoro;

  PomodoroBloc(this.getPomodoro, this.deletePomodoro)
      : super(PomodoroInitial()) {
    on<DisplayPomodoroEvent>((event, emit) async {
      emit(DisplayPomodoroLoading());
      final failureOrData = await getPomodoro(NoParams());
      failureOrData.fold(
        (failure) =>
            emit(const DisplayPomodoroError(message: "Error Catch Data")),
        (data) => emit(DisplayPomodoroLoaded(pomodoro: data)),
      );
    });

    on<DeletePomodoroEvent>((event, emit) async {
      emit(DisplayPomodoroLoading());
      final failureOrData = await deletePomodoro(Params(object: event.index));
      failureOrData.fold(
        (failure) =>
            emit(const DisplayPomodoroError(message: "Error Delete Data")),
        (data) => emit(DisplayPomodoroLoaded(pomodoro: data)),
      );
    });
  }
}
