import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pomodoro.dart';
import '../repositories/pomodoro_repository.dart';

class GetPomodoro implements UseCase<Map<int, Pomodoro>, NoParams> {
  final PomodoroRepository pomodoroRepository;

  GetPomodoro(this.pomodoroRepository);

  @override
  Future<Either<Failure, Map<int, Pomodoro>>> call(NoParams params) async {
    return await pomodoroRepository.getPomodoro();
  }
}
