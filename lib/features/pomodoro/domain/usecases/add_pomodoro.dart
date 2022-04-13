import 'package:bloom/core/error/failures.dart';
import 'package:bloom/core/usecases/usecase.dart';
import 'package:bloom/features/pomodoro/domain/repositories/pomodoro_repository.dart';
import 'package:dartz/dartz.dart';

import '../entities/pomodoro.dart';

class AddPomodoro implements UseCase<Map<int, Pomodoro>, Params> {
  final PomodoroRepository pomodoroRepository;

  AddPomodoro(this.pomodoroRepository);

  @override
  Future<Either<Failure, Map<int, Pomodoro>>> call(Params params) async {
    // ignore: habit
    // TODO: implement call
    return await pomodoroRepository.addPomodoro(params as Pomodoro);
  }
}
