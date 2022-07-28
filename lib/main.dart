import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'core/routes/app_route.dart';
import 'core/routes/route_name.dart';
import 'core/utils/notification_stream.dart';
import 'features/authentication/data/repositories/auth_repository.dart';
import 'features/authentication/data/repositories/local_auth_repository.dart';
import 'features/authentication/presentation/bloc/app/app_bloc.dart';
import 'features/home/data/load_backup_storage_api.dart';
import 'features/home/domain/load_backup_repository.dart';
import 'features/settings/data/save_backup_storage_api.dart';
import 'features/settings/domian/save_backup_repository.dart';
import 'features/todolist/data/repositories/todo/local_storage_todos_api.dart';
import 'features/todolist/data/repositories/todo_history/local_storage_history_todos_api.dart';
import 'features/todolist/domain/todos_history_repository.dart';
import 'features/todolist/domain/todos_repository.dart';
import 'firebase_options.dart';
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
      final firebaseFirestore = FirebaseFirestore.instance;
      final firebaseAuth = FirebaseAuth.instance;
      final authRepository = AuthRepository(
        firestore: firebaseFirestore,
        firebaseAuth: firebaseAuth,
      );
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
      final todosHistoryRepository = TodosHistoryRepository(
        todosApi: LocalStorageHistoryTodosApi(
          plugin: sharedPreferences,
        ),
      );
      final pomodorosRepository = PomodorosRepository(
        pomodorosApi: LocalStoragePomodorosApi(
          plugin: sharedPreferences,
        ),
      );
      final saveBackupRepository = SaveBackupRepository(
        saveBackupApi: SaveBackupStorageApi(
          plugin: sharedPreferences,
          firebaseFirestore: firebaseFirestore,
          firebaseAuth: firebaseAuth,
        ),
      );
      final loadBackupRepository = LoadBackupRepository(
        loadBackupApi: LoadBackupStorageApi(
          firebaseFirestore: firebaseFirestore,
          firebaseAuth: firebaseAuth,
        ),
      );
      runApp(
        MyApp(
          authRepository: authRepository,
          localUserDataRepository: localUserDataRepository,
          habitsRepository: habitsRepository,
          todosRepository: todosRepository,
          todosHistoryRepository: todosHistoryRepository,
          pomodorosRepository: pomodorosRepository,
          saveBackupRepository: saveBackupRepository,
          loadBackupRepository: loadBackupRepository,
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
  final TodosRepository _todosRepository;
  final TodosHistoryRepository _todosHistoryRepository;
  final PomodorosRepository _pomodorosRepository;
  final LocalUserDataRepository _localUserDataRepository;
  final SaveBackupRepository _saveBackupRepository;
  final LoadBackupRepository _loadBackupRepository;
  final SharedPreferences _sharedPreferences;

  const MyApp({
    Key? key,
    required AuthRepository authRepository,
    required HabitsRepository habitsRepository,
    required TodosRepository todosRepository,
    required TodosHistoryRepository todosHistoryRepository,
    required PomodorosRepository pomodorosRepository,
    required LocalUserDataRepository localUserDataRepository,
    required SaveBackupRepository saveBackupRepository,
    required LoadBackupRepository loadBackupRepository,
    required SharedPreferences sharedPreferences,
  })  : _authRepository = authRepository,
        _habitsRepository = habitsRepository,
        _todosRepository = todosRepository,
        _todosHistoryRepository = todosHistoryRepository,
        _pomodorosRepository = pomodorosRepository,
        _localUserDataRepository = localUserDataRepository,
        _saveBackupRepository = saveBackupRepository,
        _loadBackupRepository = loadBackupRepository,
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
          create: (_) => _todosRepository,
        ),
        RepositoryProvider<TodosHistoryRepository>(
          create: (_) => _todosHistoryRepository,
        ),
        RepositoryProvider<PomodorosRepository>(
          create: (_) => _pomodorosRepository,
        ),
        RepositoryProvider<SaveBackupRepository>(
          create: (_) => _saveBackupRepository,
        ),
        RepositoryProvider<LoadBackupRepository>(
          create: (_) => _loadBackupRepository,
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
      home: BlocListener<AppBloc, AppState>(
        listener: (context, state) {
          Navigator.of(context).pushReplacementNamed(
            (state.status == AppStatus.unauthenticated)
                ? RouteName.ONBOARD
                : RouteName.MAIN,
            arguments: (state.status == AppStatus.authenticated) ? false : null,
          );
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
      onGenerateRoute: AppRoute.generateRoute,
    );
  }
}
