// ignore_for_file: must_be_immutable

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/route_name.dart';
import '../../../core/utils/function.dart';
import '../../../core/utils/theme.dart';
import '../data/models/task_model.dart';
import 'bloc/todos_overview/todos_overview_bloc.dart';

class TaskWidget extends StatelessWidget {
  TaskModel? taskModel;
  int index;
  TaskWidget({Key? key, required this.taskModel, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        dynamic isDeleted = Navigator.pushNamed(
          context,
          RouteName.HABITDETAIL,
          arguments: taskModel,
        );
        if (isDeleted as bool) {
          Future.delayed(
            const Duration(milliseconds: 500),
            () async {
              AwesomeNotifications().cancel(taskModel!.taskId);
              context.read<TodosOverviewBloc>().add(
                    TodosOverviewTodoDeleted(
                      taskModel!,
                    ),
                  );
            },
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: getHeight(8, context)),
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
                      context.read<TodosOverviewBloc>().add(
                            TodosOverviewTodoCompletionToggled(
                              todo: taskModel!,
                              isCompleted: value!,
                            ),
                          );
                      //EDIT USER
                    },
                  ),
                ),
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
