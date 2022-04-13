import 'package:bloom/core/error/failures.dart';
import 'package:bloom/core/usecases/usecase.dart';
import 'package:bloom/features/pomodoro/domain/repositories/pomodoro_repository.dart';
import 'package:dartz/dartz.dart';

import '../entities/pomodoro.dart';

class ChangeRecentPomodoro implements UseCase<Pomodoro, Params> {
  final PomodoroRepository pomodoroRepository;

  ChangeRecentPomodoro(this.pomodoroRepository);

  @override
  Future<Either<Failure, Pomodoro>> call(Params params) async {
    // ignore: habit
    // TODO: implement call
    return await pomodoroRepository.changeRecentPomodoro(params as Pomodoro);
  }
}
