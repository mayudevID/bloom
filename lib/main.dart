import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloom/core/routes/app_route.dart';
import 'package:bloom/core/utils/notification_stream.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'core/routes/route_name.dart';
import 'features/authentication/data/repositories/auth_repository.dart';
import 'features/authentication/data/repositories/local_auth_repository.dart';
import 'features/authentication/presentation/bloc/app/app_bloc.dart';
import 'firebase_options.dart';
import 'package:bloom/features/todolist/data/repositories/local_storage_todos_api.dart';
import 'package:bloom/features/todolist/domain/todos_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/utils/observer.dart';
import 'core/utils/theme.dart';
import 'features/habit/data/repositories/local_storage_habits_api.dart';
import 'features/habit/domain/habits_repository.dart';
import 'features/pomodoro/data/repositories/local_storage_pomodoros_api.dart';
import 'features/pomodoro/domain/pomodoros_repository.dart';

void main() {
  return BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      AwesomeNotifications().initialize(
        'resource://drawable/res_app_icon',
        [
          NotificationChannel(
            channelKey: 'pomodoro_channel',
            channelName: 'Pomodoro notifications',
            channelDescription: 'Notification channel for pomodoro timer',
            defaultColor: yellowDark,
            importance: NotificationImportance.High,
            ledColor: Colors.white,
            vibrationPattern: mediumVibrationPattern,
            channelShowBadge: true,
            playSound: true,
            soundSource: "resource://raw/res_music",
          ),
          NotificationChannel(
            channelKey: 'task_channel',
            channelName: 'Task notifications',
            channelDescription: 'Notification channel for task reminder',
            defaultColor: yellowDark,
            importance: NotificationImportance.High,
            ledColor: Colors.white,
            vibrationPattern: mediumVibrationPattern,
            channelShowBadge: true,
            playSound: true,
            soundSource: "resource://raw/res_music",
          ),
          NotificationChannel(
            channelKey: 'habit_channel',
            channelName: 'Habits notifications',
            channelDescription: 'Notification channel for habit reminder',
            defaultColor: yellowDark,
            importance: NotificationImportance.High,
            ledColor: Colors.white,
            vibrationPattern: mediumVibrationPattern,
            channelShowBadge: true,
            playSound: true,
            soundSource: "resource://raw/res_music",
          ),
        ],
      );
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      final sharedPreferences = await SharedPreferences.getInstance();
      final authRepository = AuthRepository();
      final localUserDataRepository = LocalUserDataRepository(
        sharedPreferences: sharedPreferences,
      );
      final habitsRepository = HabitsRepository(
        habitsApi: LocalStorageHabitsApi(
          plugin: sharedPreferences,
        ),
      );
      final todosRepository = TodosRepository(
        todosApi: LocalStorageTodosApi(
          plugin: sharedPreferences,
        ),
      );
      final pomodorosRepository = PomodorosRepository(
        pomodorosApi: LocalStoragePomodorosApi(
          plugin: sharedPreferences,
        ),
      );
      runApp(
        MyApp(
          authRepository: authRepository,
          localUserDataRepository: localUserDataRepository,
          habitsRepository: habitsRepository,
          todosrepository: todosRepository,
          pomodorosRepository: pomodorosRepository,
          sharedPreferences: sharedPreferences,
        ),
      );
    },
    blocObserver: AppBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepository _authRepository;
  final HabitsRepository _habitsRepository;
  final TodosRepository _todosrepository;
  final PomodorosRepository _pomodorosRepository;
  final LocalUserDataRepository _localUserDataRepository;
  final SharedPreferences _sharedPreferences;

  const MyApp({
    Key? key,
    required AuthRepository authRepository,
    required HabitsRepository habitsRepository,
    required TodosRepository todosrepository,
    required PomodorosRepository pomodorosRepository,
    required LocalUserDataRepository localUserDataRepository,
    required SharedPreferences sharedPreferences,
  })  : _authRepository = authRepository,
        _habitsRepository = habitsRepository,
        _todosrepository = todosrepository,
        _pomodorosRepository = pomodorosRepository,
        _localUserDataRepository = localUserDataRepository,
        _sharedPreferences = sharedPreferences,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final notificationStream = Get.put(
      NotificationStream(
        _habitsRepository,
        _sharedPreferences,
      ),
      permanent: true,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => _authRepository,
        ),
        RepositoryProvider<LocalUserDataRepository>(
          create: (_) => _localUserDataRepository,
        ),
        RepositoryProvider<HabitsRepository>(
          create: (_) => _habitsRepository,
        ),
        RepositoryProvider<TodosRepository>(
          create: (_) => _todosrepository,
        ),
        RepositoryProvider<PomodorosRepository>(
          create: (_) => _pomodorosRepository,
        ),
      ],
      child: BlocProvider(
        create: (context) => AppBloc(authRepository: _authRepository),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async => false,
        child: BlocListener<AppBloc, AppState>(
          listener: (context, state) {
            if (state.status == AppStatus.unauthenticated) {
              Timer(const Duration(seconds: 1), () {
                Navigator.of(context).pushReplacementNamed(
                  RouteName.ONBOARD,
                );
              });
            } else if (state.status == AppStatus.authenticated) {
              Timer(const Duration(seconds: 1), () {
                Navigator.of(context).pushReplacementNamed(
                  RouteName.MAIN,
                );
              });
            }
          },
          child: Scaffold(
            backgroundColor: naturalWhite,
            body: Center(
              child: CircularProgressIndicator(
                color: naturalBlack,
              ),
            ),
          ),
        ),
      ),
      onGenerateRoute: AppRoute.generateRoute,
    );
  }
}
