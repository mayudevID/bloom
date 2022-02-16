import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloom/controllers/auth_controller.dart';
import 'package:bloom/models/task.dart';
import 'package:bloom/routes/app_pages.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:bloom/theme.dart';
import 'package:bloom/widgets/loading_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'controllers/notification_controller.dart';
import 'controllers/user_controller.dart';
import 'models/habit.dart';
import 'models/pomodoro.dart';
import 'models/timeofday_adapter.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDirectory.path)
    ..registerAdapter(PomodoroModelAdapter())
    ..registerAdapter(UserModelAdapter())
    ..registerAdapter(TaskModelAdapter())
    ..registerAdapter(HabitModelAdapter())
    ..registerAdapter(TimeOfDayAdapter());
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
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
        channelName: 'Habit notifications',
        channelDescription: 'Notification channel for habit reminder',
        defaultColor: yellowDark,
        importance: NotificationImportance.High,
        ledColor: Colors.white,
        vibrationPattern: mediumVibrationPattern,
        channelShowBadge: true,
      ),
      NotificationChannel(
        channelKey: 'service_channel',
        channelName: 'Service notifications',
        channelDescription: 'Notification channel for service',
        defaultColor: yellowDark,
        importance: NotificationImportance.High,
      )
    ],
    debug: true,
  );
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final userController = Get.put(
    UserController(),
    permanent: true,
  );
  final authController = Get.put(
    AuthController(),
    permanent: true,
  );
  final notificationController = Get.put(
    NotificationController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authController.streamAuthStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          print(snapshot.data);
          return GetMaterialApp(
            title: 'Bloom',
            theme: ThemeData(
              primarySwatch: primaryBlack,
            ),
            initialRoute:
                snapshot.data != null ? RouteName.MAIN : RouteName.ONBOARD,
            //initialRoute: RouteName.VERIFICATION,
            debugShowCheckedModeBanner: false,
            getPages: AppPages.pages,
          );
        } else {
          return const LoadingView();
        }
      },
    );
  }
}
