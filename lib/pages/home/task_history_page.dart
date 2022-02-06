import 'package:bloom/models/task.dart';
import 'package:bloom/widgets/task_widget_deleted.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../theme.dart';

class TaskHistoryPage extends StatelessWidget {
  const TaskHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: naturalWhite,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.07),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Image.asset("assets/icons/arrow_back.png", width: 24),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: Get.width * 0.5 - 48 - 74.5,
                  ),
                  child: Text(
                    "Task History",
                    style: mainSubTitle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            FutureBuilder(
              future: Hive.openBox("task_history_db"),
              builder: (builder, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    var taskHistoryDb = Hive.box('task_history_db');
                    return ValueListenableBuilder(
                      valueListenable: taskHistoryDb.listenable(),
                      builder: (context, value, child) {
                        if (taskHistoryDb.isEmpty) {
                          return const SizedBox(
                            height: 70,
                            child: Center(
                              child: Text(
                                'Task history empty',
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
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: taskHistoryDb.length,
                              itemBuilder: (context, idx) {
                                TaskModel taskModel = taskHistoryDb.getAt(idx);
                                return TaskWidgetDeleted(
                                  taskModel: taskModel,
                                  index: idx,
                                );
                              },
                            ),
                          );
                        }
                      },
                    );
                  }
                } else {
                  return const SizedBox(
                    height: 120,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
