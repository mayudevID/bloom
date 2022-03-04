// ignore_for_file: unused_local_variable

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloom/controllers/user_controller.dart';
import 'package:bloom/models/habit.dart';
import 'package:bloom/models/task.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class NotificationController extends GetxController {
  final userController = Get.find<UserController>();
  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    AwesomeNotifications().displayedStream.listen((notification) async {
      if (notification.channelKey == 'habit_channel') {
        int? habitIdTarget = int.tryParse(notification.body!.split(" - ")[0]);
        var habitDb = await Hive.openBox('habit_db');
        for (var i = 0; i < habitDb.length; i++) {
          HabitModel habitModel = habitDb.getAt(i);
          if (habitModel.habitId == habitIdTarget) {
            int openDaysVal =
                habitModel.openDays.where((item) => item == true).length;
            if (openDaysVal < habitModel.openDays.length) {
              List<bool> newOpenDays = habitModel.openDays;
              newOpenDays[openDaysVal] = true;
              // int checkedDaysVal =
              //     habitModel.checkedDays.where((item) => item == true).length;
              // int newMissed = ((openDaysVal + 1) - checkedDaysVal).abs();
              HabitModel newHabitModel = HabitModel(
                habitId: habitModel.habitId,
                iconImg: habitModel.iconImg,
                title: habitModel.title,
                goals: habitModel.goals,
                timeOfDay: habitModel.timeOfDay,
                durationDays: habitModel.durationDays,
                missed: habitModel.missed + 1,
                streak: habitModel.streak,
                streakLeft: habitModel.streakLeft,
                dayList: habitModel.dayList,
                checkedDays: habitModel.checkedDays,
                openDays: newOpenDays,
              );
              habitDb.putAt(i, newHabitModel);
              userController.updateData('newMissed', false);
            } else if (openDaysVal == habitModel.openDays.length) {
              userController.updateData('habitStreak', true);
            }
            break;
          }
        }
      }
    });

    AwesomeNotifications().actionStream.listen((notification) async {
      if (notification.channelKey == 'task_channel') {
        int? taskIdTarget = int.tryParse(notification.body!.split(" - ")[0]);
        var taskDb = await Hive.openBox('task_db');
        for (var i = 0; i < taskDb.length; i++) {
          TaskModel taskModel = taskDb.getAt(i);
          if (taskModel.taskId == taskIdTarget) {
            Get.toNamed(RouteName.TASKDETAIL, arguments: [taskModel, i]);
            break;
          }
        }
      } else if (notification.channelKey == 'habit_channel') {
        int? habitIdTarget = int.tryParse(notification.body!.split(" - ")[0]);
        var habitDb = await Hive.openBox('habit_db');
        for (var i = 0; i < habitDb.length; i++) {
          HabitModel habitModel = habitDb.getAt(i);
          if (habitModel.habitId == habitIdTarget) {
            var isDeleted = await Get.toNamed(
              RouteName.HABITDETAIL,
              arguments: i,
            );
            if (isDeleted) {
              Future.delayed(const Duration(milliseconds: 300), () async {
                //var habitDb = await Hive.openBox('habit_db');
                habitDb.deleteAt(i);
              });
            }
            break;
          }
        }
      }
    });
  }

  @override
  void onClose() {
    // ignore: todo
    // TODO: implement onClose
    super.onClose();
    AwesomeNotifications().displayedSink.close();
    AwesomeNotifications().actionSink.close();
  }
}
