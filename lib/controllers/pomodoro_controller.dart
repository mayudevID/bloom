import 'package:bloom/models/pomodoro.dart';
import 'package:get/get.dart';

class PomodoroController extends GetxController {
  RxList recentList = <PomodoroModel>[].obs;

  void newRecent(PomodoroModel model) {
    if (recentList.isEmpty) {
      recentList.add(model);
    } else {
      recentList.clear();
      recentList.add(model);
    }
  }
}
