import 'package:bloom/controllers/mainpage_controller.dart';
import 'package:get/get.dart';
import '../habit_tracker_controller.dart';
import '../home_controller.dart';
import '../add_pomodoro_controller.dart';
import '../todolist_controller.dart';

class PageBinding implements Bindings {
  @override
  void dependencies() {
    // ignore: todo
    // TODO: implement dependencies
    //Get.lazyPut<MainPageController>(() => MainPageController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<AddPomodoroController>(() => AddPomodoroController());
    Get.lazyPut<ToDoListController>(() => ToDoListController());
    Get.lazyPut<HabitTrackerController>(() => HabitTrackerController());
  }
}
