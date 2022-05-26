import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloom/core/routes/app_route.dart';
import 'package:bloom/features/habit/data/repositories/local_storage_habits_idle.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/routes/route_name.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/data/repositories/local_auth_repository.dart';
import 'features/habit/data/models/habit_model.dart';
import 'features/habit/presentation/bloc/habit_overview/habits_overview_bloc.dart';
import 'features/todolist/data/models/task_model.dart';
import 'features/todolist/data/repositories/local_storage_todos_idle.dart';
import 'features/todolist/presentation/bloc/todos_overview/todos_overview_bloc.dart';
import 'firebase_options.dart';
import 'package:bloom/features/auth/presentation/bloc/app/app_bloc.dart';
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
          ),
        ],
        debug: true,
      );
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      final sharedPreferences = await SharedPreferences.getInstance();
      final authRepository = AuthRepository();
      final localAuthRepository = LocalUserDataRepository(
        sharedPreferences: sharedPreferences,
      );
      final habitsRepository = HabitsRepository(
        habitsApi: LocalStorageHabitsApi(plugin: sharedPreferences),
      );
      final todosRepository = TodosRepository(
        todosApi: LocalStorageTodosApi(plugin: sharedPreferences),
      );
      final pomodorosRepository = PomodorosRepository(
        pomodorosApi: LocalStoragePomodorosApi(plugin: sharedPreferences),
      );
      runApp(
        MyApp(
          authRepository: authRepository,
          localAuthRepository: localAuthRepository,
          habitsRepository: habitsRepository,
          todosrepository: todosRepository,
          pomodorosRepository: pomodorosRepository,
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

  const MyApp({
    Key? key,
    required AuthRepository authRepository,
    required HabitsRepository habitsRepository,
    required TodosRepository todosrepository,
    required PomodorosRepository pomodorosRepository,
    required LocalUserDataRepository localAuthRepository,
  })  : _authRepository = authRepository,
        _habitsRepository = habitsRepository,
        _todosrepository = todosrepository,
        _pomodorosRepository = pomodorosRepository,
        _localUserDataRepository = localAuthRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
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

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  void initState() {
    super.initState();

    AwesomeNotifications().displayedStream.listen((notification) async {
      if (notification.channelKey == 'habit_channel') {
        int? habitIdTarget = int.tryParse(notification.body!.split(" - ")[0]);
        final prefs = await SharedPreferences.getInstance();
        LocalStorageHabitsIdle(prefs).getSave(habitIdTarget);
      }
    });

    AwesomeNotifications().actionStream.listen((notification) async {
      if (notification.channelKey == 'task_channel') {
        int? taskIdTarget = int.tryParse(notification.body!.split(" - ")[0]);
        final prefs = await SharedPreferences.getInstance();
        TaskModel? taskModel =
            LocalStorageTodosIdle(prefs).getData(taskIdTarget);
        dynamic isDeleted = Navigator.of(context).pushNamed(
          RouteName.TASKDETAIL,
          arguments: taskModel,
        );
        if (isDeleted as bool) {
          Future.delayed(
            const Duration(milliseconds: 200),
            () async {
              AwesomeNotifications().cancel(taskModel!.taskId);
              context.read<TodosOverviewBloc>().add(
                    TodosOverviewTodoDeleted(
                      taskModel,
                    ),
                  );
            },
          );
        }
      } else if (notification.channelKey == 'habit_channel') {
        int? habitIdTarget = int.tryParse(notification.body!.split(" - ")[0]);
        final prefs = await SharedPreferences.getInstance();
        HabitModel? habitModel =
            LocalStorageHabitsIdle(prefs).getData(habitIdTarget);
        dynamic isDeleted = Navigator.of(context).pushNamed(
          RouteName.HABITDETAIL,
          arguments: habitModel,
        );
        if (isDeleted as bool) {
          Future.delayed(
            const Duration(milliseconds: 200),
            () async {
              for (var i = 0; i < habitModel!.dayList.length; i++) {
                AwesomeNotifications().cancel(
                  habitModel.habitId * habitModel.dayList[i],
                );
              }
              context.read<HabitsOverviewBloc>().add(
                    HabitsOverviewHabitDeleted(
                      habitModel,
                    ),
                  );
            },
          );
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    AwesomeNotifications().displayedSink.close();
    AwesomeNotifications().actionSink.close();
  }

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
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteName.ONBOARD,
                  (Route<dynamic> route) => false,
                );
              });
            } else if (state.status == AppStatus.authenticated) {
              Timer(const Duration(seconds: 1), () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteName.MAIN,
                  (Route<dynamic> route) => false,
                );
              });
            }
          },
          child: Scaffold(
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
