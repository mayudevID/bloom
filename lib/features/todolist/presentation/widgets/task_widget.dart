// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/routes/route_name.dart';
import '../../../../core/utils/notifications.dart';
import '../../../../core/utils/theme.dart';
import '../../data/models/task_model.dart';
import '../bloc/todos_overview/todos_overview_bloc.dart';

class TaskWidget extends StatelessWidget {
  //int index;
  TaskWidget({Key? key, required this.taskModel}) : super(key: key);
  TaskModel? taskModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final dynamic isDeleted = await Navigator.of(context).pushNamed(
          RouteName.TASKDETAIL,
          arguments: taskModel,
        );
        if (isDeleted as bool) {
          Future.delayed(
            const Duration(milliseconds: 50),
            () async {
              await cancelTaskNotification(taskModel!.taskId);
              if (!context.mounted) return;
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
                      context.read<TodosOverviewBloc>().add(
                            TodosOverviewTodoCompletionToggled(
                              todo: taskModel!,
                              isCompleted: value!,
                            ),
                          );
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
                Text(
                  DateFormat('EEEE').format(taskModel!.dateTime),
                  style: smallText.copyWith(fontSize: 8),
                ),
                const SizedBox(width: 16),
                Image.asset("assets/icons/clock.png", width: 12),
                const SizedBox(width: 2),
                Text(
                  DateFormat('jm').format(taskModel!.dateTime),
                  style: smallText.copyWith(fontSize: 8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
