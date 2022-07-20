// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../data/models/task_model.dart';

class TaskWidgetDeleted extends StatelessWidget {
  TaskModel? taskModel;
  Function() onTap;

  TaskWidgetDeleted({
    Key? key,
    required this.taskModel,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
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
                onTap: onTap,
                child: Row(
                  children: [
                    Image.asset("assets/icons/delete.png", width: 35),
                    SizedBox(width: getWidth(15, context)),
                    Text(
                      "Delete task",
                      style: textParagraph.copyWith(fontSize: 17),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: getHeight(8, context)),
        height: 90,
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
            SizedBox(height: getHeight(4, context)),
            Text(
              taskModel!.title,
              style: textParagraph.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Image.asset("assets/icons/calendar_unselect.png", width: 13),
                SizedBox(width: getWidth(2, context)),
                Text(DateFormat('EEEE').format(taskModel!.dateTime),
                    style: smallText.copyWith(fontSize: 8)),
                SizedBox(width: getWidth(16, context)),
                Image.asset("assets/icons/clock.png", width: 12),
                SizedBox(width: getWidth(2, context)),
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
