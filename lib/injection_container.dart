import 'package:bloom/features/habit/presentation/bloc/habit_bloc.dart';
import 'package:bloom/features/home/data/datasources/habit_home_data_source.dart';
import 'package:bloom/features/home/data/datasources/task_home_data_source.dart';
import 'package:bloom/features/home/data/repositories/habit_home_repository_impl.dart';
import 'package:bloom/features/home/domain/repositories/habit_home_repository.dart';
import 'package:bloom/features/home/domain/repositories/task_home_repository.dart';
import 'package:bloom/features/home/domain/usecases/delete_home_habit.dart';
import 'package:bloom/features/home/domain/usecases/delete_home_task.dart';
import 'package:bloom/features/home/domain/usecases/get_home_habits.dart';
import 'package:bloom/features/pomodoro/data/repositories/pomodoro_repository_impl.dart';
import 'package:bloom/features/pomodoro/domain/usecases/add_pomodoro.dart';
import 'package:bloom/features/pomodoro/domain/usecases/change_recent_pomodoro.dart';
import 'package:bloom/features/pomodoro/domain/usecases/delete_pomodoro.dart';
import 'package:bloom/features/pomodoro/domain/usecases/get_pomodoro.dart';
import 'package:bloom/features/pomodoro/presentation/bloc/add_pomodoro/add_pomodoro_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/presentation/bloc/app/app_bloc.dart';
import 'features/auth/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'features/auth/presentation/bloc/login/login_cubit.dart';
import 'features/auth/presentation/bloc/onboard/onboard_bloc.dart';
import 'features/auth/presentation/bloc/signup/signup_cubit.dart';
import 'features/home/data/repositories/task_home_repository_impl.dart';
import 'features/home/domain/usecases/get_home_tasks.dart';
import 'features/home/presentation/bloc/habit/habit_home_bloc.dart';
import 'features/home/presentation/bloc/task/task_home_bloc.dart';
import 'features/pomodoro/data/datasources/pomodoro_data_source.dart';
import 'features/pomodoro/domain/repositories/pomodoro_repository.dart';
import 'features/pomodoro/presentation/bloc/pomodoro_recent/pomodoro_recent_bloc.dart';
import 'features/pomodoro/presentation/bloc/pomodoro_scroll/pomodoro_bloc.dart';
import 'features/pomodoro/presentation/bloc/timer/ticker.dart';
import 'features/pomodoro/presentation/bloc/timer/timer_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! FEATURES
  // Bloc
  sl.registerFactory(() => AppBloc(authRepository: sl()));
  sl.registerFactory(() => ForgotPasswordCubit(sl()));
  sl.registerFactory(() => LoginCubit(sl()));
  sl.registerFactory(() => OnboardBloc());
  sl.registerFactory(() => SignupCubit(sl()));
  sl.registerFactory(() => HabitsHomeBloc(sl(), sl()));
  sl.registerFactory(() => TaskHomeBloc(sl(), sl()));
  sl.registerFactory(() => AddPomodoroCubit(sl()));
  sl.registerFactory(() => PomodoroRecentBloc());
  sl.registerFactory(() => PomodoroBloc(sl(), sl()));
  sl.registerFactory(() => TimerBloc(ticker: sl()));
  sl.registerFactory(() => HabitsBloc(sl()));

  // UseCase
  sl.registerLazySingleton(() => DeleteHomeHabits(sl()));
  sl.registerLazySingleton(() => DeleteHomeTask(sl()));
  sl.registerLazySingleton(() => GetHomeHabitss(sl()));
  sl.registerLazySingleton(() => GetHomeTasks(sl()));
  sl.registerLazySingleton(() => AddPomodoro(sl()));
  sl.registerLazySingleton(() => ChangeRecentPomodoro(sl()));
  sl.registerLazySingleton(() => DeletePomodoro(sl()));
  sl.registerLazySingleton(() => GetPomodoro(sl()));

  // Repository
  sl.registerFactory<HabitsHomeRepository>(
    () => HabitsHomeRepositoryImpl(
      habitHomeDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<TaskHomeRepository>(
    () => TaskHomeRepositoryImpl(
      taskHomeDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<PomodoroRepository>(
    () => PomodoroRepositoryImpl(
      pomodoroDataSource: sl(),
    ),
  );

  // DataSource
  sl.registerLazySingleton<HabitsHomeDataSource>(
    () => HabitsHomeDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );
  sl.registerLazySingleton<TaskHomeDataSource>(
    () => TaskHomeDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );
  sl.registerLazySingleton<PomodoroDataSource>(
    () => PomodoroDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  //! CORE

  //! EXTERNAL
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => const Ticker());
}
