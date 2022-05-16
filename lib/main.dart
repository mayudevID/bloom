import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloom/core/routes/app_pages.dart';
import 'package:bloom/core/routes/route_generate.dart';
import 'package:bloom/features/auth/data/auth_repository.dart';
import 'package:bloom/features/auth/presentation/bloc/app/app_bloc.dart';
import 'package:bloom/features/todolist/data/repositories/local_storage_todos_api.dart';
import 'package:bloom/features/todolist/domain/todos_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/utils/theme.dart';
import 'features/habit/data/repositories/local_storage_habits_api.dart';
import 'features/habit/domain/habits_repository.dart';

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
      await Firebase.initializeApp();
      final sharedPreferences = await SharedPreferences.getInstance();
      final habitsApi = LocalStorageHabitsApi(plugin: sharedPreferences);
      final todosApi = LocalStorageTodosApi(
        plugin: sharedPreferences,
      );
      final authRepository = AuthRepository();
      final habitsRepository = HabitsRepository(habitsApi: habitsApi);
      final todosRepository = TodosRepository(todosApi: todosApi);
      runApp(
        MyApp(
          authRepository: authRepository,
          habitsRepository: habitsRepository,
          todosrepository: todosRepository,
        ),
      );
    },
    blocObserver: AppBlocObserver(),
  );
}

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

class MyApp extends StatelessWidget {
  final AuthRepository _authRepository;
  final HabitsRepository _habitsRepository;
  final TodosRepository _todosrepository;

  const MyApp({
    Key? key,
    required AuthRepository authRepository,
    required HabitsRepository habitsRepository,
    required TodosRepository todosrepository,
  })  : _authRepository = authRepository,
        _habitsRepository = habitsRepository,
        _todosrepository = todosrepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => _authRepository,
        ),
        RepositoryProvider<HabitsRepository>(
          create: (_) => _habitsRepository,
        ),
        RepositoryProvider<TodosRepository>(
          create: (_) => _todosrepository,
        ),
      ],
      child: BlocProvider<AppBloc>(
        create: (_) => AppBloc(authRepository: _authRepository),
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
      home: FlowBuilder(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
      routes: AppPages.pages,
    );
  }
}
