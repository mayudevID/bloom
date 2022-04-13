import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pomodoro.dart';
import '../repositories/pomodoro_repository.dart';

class DeletePomodoro implements UseCase<Map<int, Pomodoro>, Params> {
  final PomodoroRepository pomodoroRepository;

  DeletePomodoro(this.pomodoroRepository);

  @override
  Future<Either<Failure, Map<int, Pomodoro>>> call(Params params) async {
    return await pomodoroRepository.deletePomodoro(params as int);
  }
}
