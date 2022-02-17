import 'package:bloom/controllers/add_task_controller.dart';
import 'package:bloom/models/task.dart';
import 'package:bloom/theme.dart';
import 'package:bloom/utils.dart';
import 'package:bloom/widgets/notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AddTaskPage extends StatelessWidget {
  AddTaskPage({Key? key}) : super(key: key);
  final addTaskC = Get.put(AddTaskController(Get.arguments));

  void _saveTask() async {
    if (addTaskC.titleController.text.trim().isNotEmpty) {
      TaskModel taskModel = TaskModel(
        taskId: getRandomId(),
        tags: addTaskC.tags.value,
        dateTime: addTaskC.dateChoose.value,
        title: addTaskC.titleController.text.trim(),
        description: (addTaskC.descController.text.trim().isEmpty)
            ? "No Description"
            : addTaskC.descController.text.trim(),
        isRepeat: false,
        isTime: addTaskC.isTime.value,
        isChecked: false,
      );

      var taskDb = await Hive.openBox('task_db');
      taskDb.add(taskModel);
      taskDb.close();

      if (addTaskC.isTime.value && addTaskC.isChoose.value) {
        createTaskNotification(taskModel);
      }

      Get.back();
      Get.snackbar(
        "Timer Added",
        "\"${addTaskC.titleController.text}\" added to My Task",
        colorText: naturalWhite,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(
          bottom: 80,
          left: 30,
          right: 30,
        ),
        backgroundColor: naturalBlack,
        animationDuration: const Duration(milliseconds: 100),
        forwardAnimationCurve: Curves.fastOutSlowIn,
        reverseAnimationCurve: Curves.fastOutSlowIn,
      );
    } else {
      Get.snackbar(
        "Title Empty",
        "Please input the title of task",
        colorText: naturalWhite,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(
          bottom: 80,
          left: 30,
          right: 30,
        ),
        backgroundColor: naturalBlack,
        animationDuration: const Duration(milliseconds: 100),
        forwardAnimationCurve: Curves.fastOutSlowIn,
        reverseAnimationCurve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    void pickTime() async {
      final TimeOfDay? pickTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickTime != null) {
        String time = pickTime.format(context) + ":00";
        addTaskC.setDateTime(time);
        addTaskC.isChoose.value = true;
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: naturalWhite,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.07),
            Text("New Task", style: mainSubTitle),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Title", style: textParagraph),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(5),
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: greyLight,
              ),
              child: TextFormField(
                controller: addTaskC.titleController,
                style: textForm,
                cursorColor: naturalBlack,
                decoration: InputDecoration.collapsed(
                  hintText: "Input title",
                  hintStyle: textForm.copyWith(color: greyDark),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Description", style: textParagraph),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(5),
              height: 96,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: greyLight,
              ),
              child: TextFormField(
                controller: addTaskC.descController,
                style: textForm,
                maxLines: 5,
                maxLength: 1000,
                cursorColor: naturalBlack,
                decoration: InputDecoration.collapsed(
                  hintText: "Input description",
                  hintStyle: textForm.copyWith(color: greyDark),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Time", style: textParagraph),
                SizedBox(
                  width: 34,
                  height: 20,
                  child: Obx(() {
                    return Switch(
                      inactiveTrackColor: greyLight,
                      inactiveThumbColor: greyDark,
                      activeColor: naturalBlack,
                      value: addTaskC.isTime.value,
                      onChanged: (val) {
                        addTaskC.isTime.value = val;
                        if (!addTaskC.isTime.value) {
                          addTaskC.isChoose.value = val;
                        }
                      },
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() {
              if (addTaskC.isTime.value) {
                if (addTaskC.isChoose.value) {
                  return GestureDetector(
                    onTap: () {
                      pickTime();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: greyLight,
                          ),
                          child: Center(
                            child: Text(
                              DateFormat('E, dd MMM y')
                                  .format(addTaskC.dateChoose.value),
                              style: smallText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 120,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: greyLight,
                          ),
                          child: Center(
                            child: Text(
                              DateFormat('jm')
                                  .format(addTaskC.dateChoose.value),
                              style: smallText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      pickTime();
                    },
                    child: Container(
                      width: 278,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: greyLight,
                      ),
                      child: Center(child: Text("Pick time", style: smallText)),
                    ),
                  );
                }
              } else {
                return Container();
              }
            }),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Repeat", style: textParagraph),
                Container(
                  width: 122,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: greyLight,
                  ),
                  child: Center(
                    child: Text(
                      "None",
                      style: interBold12.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tags", style: textParagraph),
                Container(
                  width: 122,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: greyLight,
                  ),
                  child: Center(
                    child: Obx(() {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(10),
                          icon: const Visibility(
                            visible: false,
                            child: Icon(Icons.arrow_downward),
                          ),
                          value: addTaskC.tags.value,
                          items: ['Basic', 'Important'].map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: interBold12.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            addTaskC.tags.value = newVal as String;
                          },
                        ),
                      );
                    }),
                  ),
                )
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                _saveTask();
              },
              child: Container(
                width: 202,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: naturalBlack,
                ),
                child: Center(
                  child: Text(
                    "Save",
                    style: buttonSmall.copyWith(
                      color: naturalWhite,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Text("Cancel", style: textParagraph),
            ),
            const SizedBox(height: 72),
          ],
        ),
      ),
    );
  }
}
