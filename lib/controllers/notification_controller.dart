// ignore_for_file: unused_local_variable

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloom/models/task.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class NotificationController extends GetxController {
  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    AwesomeNotifications().displayedStream.listen((notification) async {
      if (notification.channelKey == 'habit_channel') {
        String? titleAll = notification.title;
        String title = titleAll!.split(" - ")[1];
        print(title);
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
