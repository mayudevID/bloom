// ignore_for_file: must_be_immutable

import 'package:bloom/controllers/user_controller.dart';
import 'package:bloom/models/task.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../theme.dart';

class TaskWidget extends StatelessWidget {
  TaskModel? taskModel;
  int index;
  final userController = Get.find<UserController>();
  TaskWidget({Key? key, required this.taskModel, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteName.TASKDETAIL, arguments: [taskModel, index]);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        height: 90,
        decoration: BoxDecoration(
          color: yellowLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 20,
                  decoration: BoxDecoration(
                    color:
                        (taskModel!.tags == 'Basic') ? greenAction : redAction,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      taskModel!.tags,
                      style: smallTextLink.copyWith(
                        fontSize: 8,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    activeColor: naturalBlack,
                    // tristate: true,
                    value: taskModel!.isChecked,
                    onChanged: (bool? value) async {
                      TaskModel newTaskModel = TaskModel(
                        taskId: taskModel!.taskId,
                        tags: taskModel!.tags,
                        dateTime: taskModel!.dateTime,
                        title: taskModel!.title,
                        isRepeat: taskModel!.isRepeat,
                        isTime: taskModel!.isRepeat,
                        description: taskModel!.description,
                        isChecked: value!,
                      );
                      var taskDb = await Hive.openBox('task_db');
                      taskDb.putAt(index, newTaskModel);
                      await userController.updateData('taskCompleted', value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              taskModel!.title,
              style: textParagraph.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Image.asset("assets/icons/calendar_unselect.png", width: 13),
                const SizedBox(width: 2),
                Text(DateFormat('EEEE').format(taskModel!.dateTime),
                    style: smallText.copyWith(fontSize: 8)),
                const SizedBox(width: 16),
                Image.asset("assets/icons/clock.png", width: 12),
                const SizedBox(width: 2),
                Text(DateFormat('jm').format(taskModel!.dateTime),
                    style: smallText.copyWith(fontSize: 8)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
