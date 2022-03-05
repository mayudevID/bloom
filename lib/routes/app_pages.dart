import 'package:bloom/controllers/bindings/page_binding.dart';
import 'package:bloom/pages/home/main_page.dart';
import 'package:bloom/pages/home/profile_page.dart';
import 'package:bloom/pages/home/settings_page.dart';
import 'package:bloom/pages/home/statistics_page.dart';
import 'package:bloom/pages/home/task_history_page.dart';
import 'package:bloom/pages/start/create_account_page.dart';
import 'package:bloom/pages/start/forgot_password_page.dart';
import 'package:bloom/pages/start/login_page.dart';
import 'package:bloom/pages/start/onboarding_page.dart';
import 'package:bloom/pages/start/verification_page.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:get/get.dart';
import '../pages/home/edit_profile_page.dart';
import '../pages/home/habit/add_habit_page.dart';
import '../pages/home/habit/habit_detail_page.dart';
import '../pages/home/pomodoro/timer_page.dart';
import '../pages/home/todolist/add_task_page.dart';
import '../pages/home/todolist/task_detail_page.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: RouteName.ONBOARD,
      page: () => OnboardingPage(),
    ),
    GetPage(
      name: RouteName.LOGIN,
      page: () => LoginPage(),
    ),
    GetPage(
      name: RouteName.REGISTER,
      page: () => CreateAccountPage(),
    ),
    GetPage(
      name: RouteName.FORGETPASS,
      page: () => ForgotPasswordPage(),
    ),
    GetPage(
      name: RouteName.VERIFICATION,
      page: () => VerificationPage(),
    ),
    GetPage(
      name: RouteName.MAIN,
      page: () => MainPage(),
      binding: PageBinding(),
    ),
    GetPage(
      name: RouteName.TIMER,
      page: () => TimerPage(),
    ),
    GetPage(
      name: RouteName.PROFILE,
      page: () => ProfilePage(),
    ),
    GetPage(
      name: RouteName.ADDTASK,
      page: () => AddTaskPage(),
    ),
    GetPage(
      name: RouteName.ADDHABIT,
      page: () => AddHabitPage(),
    ),
    GetPage(
      name: RouteName.TASKDETAIL,
      page: () => TaskDetailPage(),
    ),
    GetPage(
      name: RouteName.SETTINGS,
      page: () => SettingsPage(),
    ),
    GetPage(
      name: RouteName.HABITDETAIL,
      page: () => HabitDetailPage(),
    ),
    GetPage(
      name: RouteName.TASKHISTORY,
      page: () => const TaskHistoryPage(),
    ),
    GetPage(
      name: RouteName.STATISTICS,
      page: () => StatisticsPage(),
    ),
    GetPage(
      name: RouteName.EDITPROFILE,
      page: () => EditProfilePage(),
    ),
  ];
}
