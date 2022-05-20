import 'package:bloom/core/routes/route_name.dart';
import 'package:bloom/features/habit/data/models/habit_model.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/create_account_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/verification_page.dart';
import '../../features/habit/presentation/pages/add_habit_page.dart';
import '../../features/habit/presentation/pages/habit_detail_page.dart';
import '../../features/pomodoro/data/models/pomodoro_model.dart';
import '../../features/pomodoro/presentation/pages/timer_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/todolist/data/models/task_model.dart';
import '../../features/todolist/presentation/pages/add_task_page.dart';
import '../../features/todolist/presentation/pages/task_detail_page.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case RouteName.LOGIN:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case RouteName.REGISTER:
        return MaterialPageRoute(builder: (_) => const CreateAccountPage());
      case RouteName.FORGETPASS:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      case RouteName.VERIFICATION:
        return MaterialPageRoute(builder: (_) => const VerificationPage());
      case RouteName.ADDHABIT:
        return MaterialPageRoute(builder: (_) => const AddHabitsPage());
      case RouteName.HABITDETAIL:
        return MaterialPageRoute(
          builder: (_) => HabitsDetailPage(
            initHabitModel: args as HabitModel,
          ),
        );
      case RouteName.TIMER:
        return MaterialPageRoute(
          builder: (_) => TimerPage(
            initPomodoroModel: args as PomodoroModel,
          ),
        );
      case RouteName.ADDTASK:
        return MaterialPageRoute(builder: (_) => const AddTaskPage());
      case RouteName.TASKDETAIL:
        return MaterialPageRoute(
          builder: (_) => TaskDetailPage(
            initTaskModel: args as TaskModel,
          ),
        );
      case RouteName.SETTINGS:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      //case RouteName.PROFILE:
      //  return MaterialPageRoute(builder: (_) => ProfilePage());
      //case RouteName.EDITPROFILE:
      //  return MaterialPageRoute(builder: (_) => EditProfilePage());
      //case RouteName.TASKHISTORY:
      //  return MaterialPageRoute(builder: (_) => TaskHistoryPage());
      //case RouteName.STATISTICS:
      //  return MaterialPageRoute(builder: (_) => StatisticsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

// class AppPages {
//   static final pages = {
//     RouteName.LOGIN: (context) => const LoginPage(),
//     RouteName.REGISTER: (context) => const CreateAccountPage(),
//     RouteName.FORGETPASS: (context) => ForgotPasswordPage(),
//     RouteName.VERIFICATION: (context) => VerificationPage(),
//     RouteName.TIMER: (context) => TimerPage(),
//     //RouteName.PROFILE: (context) => ProfilePage(),
//     RouteName.ADDTASK: (context) => AddTaskPage(),
//     RouteName.ADDHABIT: (context) => AddHabitsPage(),
//     RouteName.TASKDETAIL: (context) => TaskDetailPage(),
//     RouteName.SETTINGS: (context) => SettingsPage(),
//     RouteName.HABITDETAIL: (context) => HabitsDetailPage(),
//     //RouteName.TASKHISTORY: (context) => const TaskHistoryPage(),
//     //RouteName.STATISTICS: (context) => StatisticsPage(),
//     //RouteName.EDITPROFILE: (context) => EditProfilePage(),
//   };
// }
