// ignore_for_file: must_be_immutable

import 'package:bloom/controllers/todolist_controller.dart';
import 'package:bloom/models/task.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:bloom/widgets/calendar_widget/calendar_widget.dart';
import 'package:bloom/widgets/task_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../theme.dart';
import '../../utils.dart';

class ToDoListPage extends StatelessWidget {
  ToDoListPage({Key? key}) : super(key: key);
  final toDoListController = Get.find<ToDoListController>();
  DateTime dateNow = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: naturalWhite,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Get.height * 0.07),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text("To-Do List", style: mainSubTitle),
          ),
          const SizedBox(height: 24),
          CalendarWidget(
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year, 1, 1),
            lastDate: DateTime(DateTime.now().year, 12, 31),
            onDateSelected: (date) {
              print(date);
              toDoListController
                  .setDate(date ?? toDoListController.dateSelector);
            },
            leftMargin: (Get.width / 2) - 20,
          ),
          const SizedBox(height: 32),
          Container(
            margin: const EdgeInsets.only(left: 24),
            child: Text(
              "My Task",
              style: textParagraph.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: FutureBuilder(
              future: Hive.openBox('task_db'),
              builder: (builder, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    var taskDb = Hive.box('task_db');
                    return ValueListenableBuilder(
                      valueListenable: taskDb.listenable(),
                      builder: (context, value, child) {
                        if (taskDb.isEmpty) {
                          return const SizedBox(
                            height: 70,
                            child: Center(
                              child: Text(
                                'Task empty for this date',
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return GetBuilder<ToDoListController>(
                            builder: (_) {
                              Map<int, TaskModel?> dataTask = taskByDateChooser(
                                  taskDb, toDoListController.dateSelector);
                              if (dataTask.isEmpty) {
                                return const SizedBox(
                                  height: 70,
                                  child: Center(
                                    child: Text(
                                      'Task empty for this date',
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: dataTask.length,
                                    itemBuilder: (context, idx) {
                                      return TaskWidget(
                                        taskModel:
                                            dataTask.values.elementAt(idx),
                                        index: dataTask.keys.elementAt(idx),
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          );
                        }
                      },
                    );
                  }
                } else {
                  return const SizedBox(
                    height: 70,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 40),
          GetBuilder<ToDoListController>(
            builder: (_) {
              if (dateNow.isBefore(toDoListController.dateSelector) ||
                  dateNow.isAtSameMomentAs(toDoListController.dateSelector)) {
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteName.ADDTASK,
                          arguments: toDoListController.dateSelector);
                    },
                    child: Container(
                      height: 40,
                      width: 203,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: naturalBlack,
                      ),
                      child: Center(
                        child: Text(
                          "Add new task",
                          style: buttonSmall.copyWith(
                            color: naturalWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
