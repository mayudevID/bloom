// ignore_for_file: must_be_immutable

import 'package:bloom/controllers/user_controller.dart';
import 'package:bloom/models/task.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../theme.dart';
import '../utils.dart';

class TaskWidgetDeleted extends StatelessWidget {
  TaskModel? taskModel;
  int index;
  final userController = Get.find<UserController>();
  TaskWidgetDeleted({Key? key, required this.taskModel, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Get.bottomSheet(
          Container(
            padding: const EdgeInsets.all(24),
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: naturalWhite,
            ),
            child: GestureDetector(
              onTap: () async {
                var taskHistoryDb = await Hive.openBox('task_history_db');
                if (taskHistoryDb.length == 1) {
                  taskHistoryDb.clear();
                } else {
                  taskHistoryDb.deleteAt(index);
                }
                Get.back();
              },
              child: Row(
                children: [
                  Image.asset("assets/icons/delete.png", width: 35),
                  SizedBox(width: getWidth(15)),
                  Text(
                    "Delete task",
                    style: textParagraph.copyWith(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        height: getHeight(90),
        decoration: BoxDecoration(
          color: greyLight,
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
                    color: greyDark,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      taskModel!.tags,
                      style: smallTextLink.copyWith(
                        fontSize: 8,
                        color: naturalWhite,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            SizedBox(height: getHeight(4)),
            Text(
              taskModel!.title,
              style: textParagraph.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Image.asset("assets/icons/calendar_unselect.png", width: 13),
                SizedBox(width: getWidth(2)),
                Text(DateFormat('EEEE').format(taskModel!.dateTime),
                    style: smallText.copyWith(fontSize: 8)),
                SizedBox(width: getWidth(16)),
                Image.asset("assets/icons/clock.png", width: 12),
                SizedBox(width: getWidth(2)),
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
