import 'package:bloom/core/routes/route_name.dart';
import '../../features/auth/presentation/pages/create_account_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/verification_page.dart';

class AppPages {
  static final pages = {
    RouteName.LOGIN: (context) => const LoginPage(),
    RouteName.REGISTER: (context) => const CreateAccountPage(),
    RouteName.FORGETPASS: (context) => ForgotPasswordPage(),
    RouteName.VERIFICATION: (context) => VerificationPage(),
    // RouteName.TIMER: (context) => TimerPage(),
    // RouteName.PROFILE: (context) => ProfilePage(),
    // RouteName.ADDTASK: (context) => AddTaskPage(),
    // RouteName.ADDHABIT: (context) => AddHabitsPage(),
    // RouteName.TASKDETAIL: (context) => TaskDetailPage(),
    // RouteName.SETTINGS: (context) => SettingsPage(),
    // RouteName.HABITDETAIL: (context) => HabitsDetailPage(),
    // RouteName.TASKHISTORY: (context) => const TaskHistoryPage(),
    // RouteName.STATISTICS: (context) => StatisticsPage(),
    // RouteName.EDITPROFILE: (context) => EditProfilePage(),
  };
}
