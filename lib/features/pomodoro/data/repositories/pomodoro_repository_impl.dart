import 'package:bloom/features/pomodoro/data/models/pomodoro_model.dart';
import 'package:bloom/features/pomodoro/domain/entities/pomodoro.dart';
import 'package:bloom/core/error/failures.dart';
import 'package:bloom/features/pomodoro/domain/repositories/pomodoro_repository.dart';
import 'package:dartz/dartz.dart';

import '../datasources/pomodoro_data_source.dart';

typedef _GetOrDeletePomodoro = Future<Map<int, Pomodoro>> Function();

class PomodoroRepositoryImpl implements PomodoroRepository {
  final PomodoroDataSource pomodoroDataSource;

  PomodoroRepositoryImpl({required this.pomodoroDataSource});

  @override
  Future<Either<Failure, Map<int, Pomodoro>>> deletePomodoro(int index) {
    // ignore: habit
    // TODO: implement deletePomodoro
    return _getData(() {
      return pomodoroDataSource.deletePomodoro(index);
    });
  }

  @override
  Future<Either<Failure, Map<int, Pomodoro>>> getPomodoro() {
    // ignore: habit
    // TODO: implement getPomodoro
    return _getData(() {
      return pomodoroDataSource.getPomodoro();
    });
  }

  @override
  Future<Either<Failure, Map<int, Pomodoro>>> addPomodoro(Pomodoro pomodoro) {
    // ignore: habit
    // TODO: implement addPomodoro
    return _getData(() {
      return pomodoroDataSource.addPomodoro(pomodoro as PomodoroModel);
    });
  }

  Future<Either<Failure, Map<int, Pomodoro>>> _getData(
      _GetOrDeletePomodoro getOrDeletePomodoro) async {
    try {
      Map<int, Pomodoro> dataPomodoro = await getOrDeletePomodoro();
      return Right(dataPomodoro);
    } catch (e) {
      return Left(OtherFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Pomodoro>> changeRecentPomodoro(
      Pomodoro pomodoro) async {
    // ignore: habit
    // TODO: implement changeRecentPomodoro
    try {
      Pomodoro dataPomodoro = await pomodoroDataSource
          .changeRecentPomodoro(pomodoro as PomodoroModel);
      return Right(dataPomodoro);
    } catch (e) {
      return Left(OtherFailure(errorMessage: e.toString()));
    }
  }
}
