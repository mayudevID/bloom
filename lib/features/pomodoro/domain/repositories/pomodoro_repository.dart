import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/pomodoro.dart';

abstract class PomodoroRepository {
  Future<Either<Failure, Map<int, Pomodoro>>> getPomodoro();
  Future<Either<Failure, Map<int, Pomodoro>>> addPomodoro(Pomodoro pomodoro);
  Future<Either<Failure, Map<int, Pomodoro>>> deletePomodoro(int index);
  Future<Either<Failure, Pomodoro>> changeRecentPomodoro(Pomodoro pomodoro);
}
