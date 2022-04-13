import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloom/models/task.dart';
import 'package:bloom/theme.dart';
import 'package:bloom/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class TaskDetailPage extends StatelessWidget {
  TaskDetailPage({Key? key}) : super(key: key);
  final TaskModel taskModel = (Get.arguments as List)[0];
  final int index = (Get.arguments as List)[1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellowLight,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.07),
            Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Image.asset(
                    "assets/icons/arrow_back.png",
                    width: 24,
                  ),
                ),
                const Spacer(),
                Image.asset("assets/icons/share.png", width: 24),
                SizedBox(width: getWidth(16)),
                GestureDetector(
                  onTap: () async {
                    var taskDb = await Hive.openBox('task_db');
                    var taskHistoryDb = await Hive.openBox('task_history_db');
                    AwesomeNotifications().cancel(taskModel.taskId);
                    if (taskDb.length == 1) {
                      taskDb.clear();
                    } else {
                      taskDb.deleteAt(index);
                    }
                    taskHistoryDb.add(taskModel);
                    taskHistoryDb.close();
                    Get.back();
                  },
                  child: Image.asset(
                    "assets/icons/delete.png",
                    width: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight(40)),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  color: (taskModel.tags == 'Basic') ? greenAction : redAction,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    taskModel.tags,
                    style: smallTextLink.copyWith(
                      fontSize: 8,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: getHeight(8)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                taskModel.title,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: getHeight(16)),
            Row(
              children: [
                Image.asset("assets/icons/calendar_unselect.png", width: 16),
                SizedBox(width: getWidth(4)),
                Text(
                  DateFormat('EEEE, dd MMMM y').format(taskModel.dateTime),
                  style: interBold12.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight(8)),
            Row(
              children: [
                Image.asset("assets/icons/clock.png", width: 16),
                SizedBox(width: getWidth(4)),
                Text(
                  DateFormat('jm').format(taskModel.dateTime),
                  style: interBold12.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight(24)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Description",
                style: buttonSmall,
              ),
            ),
            SizedBox(height: getHeight(4)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                taskModel.description,
                style: interBold12.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
