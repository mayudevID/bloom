import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloom/core/routes/app_pages.dart';
import 'package:bloom/core/routes/route_generate.dart';
import 'package:bloom/features/auth/data/auth_repository.dart';
import 'package:bloom/features/auth/presentation/bloc/app/app_bloc.dart';
import 'package:bloom/features/habit/data/repositories/habitss_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/utils/theme.dart';
import 'features/habit/data/datasources/local_storage_habits_api.dart';
import 'features/habit/domain/repositories/habit_repository.dart';
import 'injection_container.dart' as di;

void main() {
  return BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await di.init();
      final habitsApi = LocalStorageHabitssApi(
        plugin: di.sl<SharedPreferences>(),
      );
      final habitsRepository = HabitssRepository(habitsApi: habitsApi);
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
      final authRepository = AuthRepository();
      runApp(
        MyApp(
          authRepository: authRepository,
          habitsRepository: habitsRepository,
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  final AuthRepository _authRepository;
  final HabitssRepository _habitsRepository;

  const MyApp({
    Key? key,
    required AuthRepository authRepository,
    required HabitssRepository habitsRepository,
  })  : _authRepository = authRepository,
        _habitsRepository = habitsRepository,
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
      ],
      child: BlocProvider<AppBloc>(
        create: (_) => di.sl<AppBloc>(),
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
