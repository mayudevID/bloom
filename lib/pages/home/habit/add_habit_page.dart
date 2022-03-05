import 'package:bloom/controllers/add_habit_controller.dart';
import 'package:bloom/models/habit.dart';
import 'package:bloom/utils.dart';
import 'package:bloom/widgets/notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:weekday_selector/weekday_selector.dart';
import '../../../controllers/user_controller.dart';
import '../../../theme.dart';

class AddHabitPage extends StatelessWidget {
  AddHabitPage({Key? key}) : super(key: key);
  final addHabitC = Get.put(AddHabitController());
  final userController = Get.find<UserController>();

  void _saveHabit() async {
    if (addHabitC.titleController.text.trim().isNotEmpty) {
      Map<int, bool> dayMap = addHabitC.dayList.asMap();

      List<int> dayListOn = [];
      dayMap.forEach((key, value) {
        if (value == true) {
          if (key == 0) {
            dayListOn.add(7);
          } else {
            dayListOn.add(key);
          }
        }
      });

      HabitModel habitModel = HabitModel(
        habitId: getRandomId(),
        iconImg: addHabitC.iconLocation[addHabitC.currentIcon.value],
        title: addHabitC.titleController.text.trim(),
        timeOfDay: addHabitC.timeOfDayHabit.value,
        durationDays: addHabitC.durationDaysHabit.value,
        dayList: dayListOn,
        checkedDays: List.filled(addHabitC.durationDaysHabit.value, false),
        openDays: List.filled(addHabitC.durationDaysHabit.value, false),
        missed: 0,
        streak: 0,
        streakLeft: addHabitC.durationDaysHabit.value,
        goals: (addHabitC.goalsController.text.trim().isEmpty)
            ? "No Goals"
            : addHabitC.goalsController.text.trim(),
      );

      var habitDb = await Hive.openBox('habit_db');
      habitDb.add(habitModel);

      for (var i = 0; i < habitModel.dayList.length; i++) {
        createHabitNotification(habitModel, habitModel.dayList[i]);
      }

      await userController.updateData(
          'streakLeft', addHabitC.durationDaysHabit.value);

      Get.back();
      Get.snackbar(
        "Habit Added",
        "\"${addHabitC.titleController.text}\" added to My Habit",
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
        "Habit Name Empty",
        "Please input the name of habit",
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
    Future<TimeOfDay?> _getTime() async {
      final TimeOfDay? pickTime = await showTimePicker(
        context: context,
        initialTime: addHabitC.timeOfDayHabit.value,
      );
      return pickTime;
    }

    Future _getIcon() {
      return Get.defaultDialog(
        title: "Choose Icon",
        titleStyle: textParagraph.copyWith(fontSize: 17),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        content: SizedBox(
          width: 250,
          height: 250,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 70,
              childAspectRatio: 1,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: addHabitC.iconLocation.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => addHabitC.currentIcon.value = index,
                child: Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: (addHabitC.currentIcon.value == index)
                              ? yellowDark
                              : naturalBlack,
                          width: 3),
                    ),
                    child: Image.asset(
                      addHabitC.iconLocation[index],
                      scale: 2,
                    ),
                  );
                }),
              );
            },
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              width: 70,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: naturalBlack,
              ),
              child: Center(
                child: Text(
                  'Close',
                  style: buttonSmall.copyWith(
                    color: naturalWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Future _getDurationDays() {
      return Get.defaultDialog(
        title: "Duration (days)",
        titleStyle: buttonSmall,
        titlePadding: const EdgeInsets.only(
          top: 20,
          bottom: 5,
        ),
        contentPadding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        content: SizedBox(
          width: 250,
          height: 70,
          child: Center(
            child: Obx(
              () {
                return NumberPicker(
                  itemWidth: 60,
                  textStyle: textParagraph.copyWith(
                    fontWeight: FontWeight.w600,
                    color: naturalBlack,
                    fontSize: 16,
                  ),
                  selectedTextStyle: textParagraph.copyWith(
                    fontWeight: FontWeight.w600,
                    color: naturalBlack,
                    fontSize: 20,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: naturalBlack),
                  ),
                  axis: Axis.horizontal,
                  minValue: 1,
                  maxValue: 100,
                  value: addHabitC.durationDaysHabit.value,
                  onChanged: (value) {
                    addHabitC.durationDaysHabit.value = value;
                  },
                  step: 1,
                );
              },
            ),
          ),
        ),
        actions: [
          SizedBox(width: getWidth(70)),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 70,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: naturalBlack,
              ),
              child: Center(
                child: Text(
                  'Back',
                  style: buttonSmall.copyWith(
                    color: naturalWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: naturalWhite,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.07),
            Center(child: Text("New Habit", style: mainSubTitle)),
            SizedBox(height: getHeight(16)),
            Container(
              width: 74,
              height: 74,
              color: naturalWhite,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: yellowDark),
                        color: const Color(0xffFCF7D3),
                      ),
                      child: Obx(() {
                        return Image.asset(
                          addHabitC.iconLocation[addHabitC.currentIcon.value],
                          width: 32,
                          scale: 3,
                        );
                      }),
                    ),
                  ),
                  Positioned(
                    left: 54,
                    bottom: 54,
                    child: GestureDetector(
                      onTap: () => _getIcon(),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: const Color(0xffFED8B6),
                        ),
                        child: Image.asset(
                          "assets/icons/pen.png",
                          width: 12,
                          scale: 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: getHeight(32)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Habit Name", style: textParagraph),
            ),
            SizedBox(height: getHeight(4)),
            Container(
              padding: const EdgeInsets.all(5),
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: greyLight,
              ),
              child: TextFormField(
                controller: addHabitC.titleController,
                style: textForm,
                cursorColor: naturalBlack,
                decoration: InputDecoration.collapsed(
                  hintText: "Input title",
                  hintStyle: textForm.copyWith(color: greyDark),
                ),
              ),
            ),
            SizedBox(height: getHeight(16)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Goals", style: textParagraph),
            ),
            SizedBox(height: getHeight(4)),
            Container(
              padding: const EdgeInsets.all(5),
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: greyLight,
              ),
              child: TextFormField(
                controller: addHabitC.goalsController,
                style: textForm,
                maxLines: 4,
                maxLength: 1000,
                cursorColor: naturalBlack,
                decoration: InputDecoration.collapsed(
                  hintText: "Input goals",
                  hintStyle: textForm.copyWith(color: greyDark),
                ),
              ),
            ),
            SizedBox(height: getHeight(16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Duration", style: textParagraph),
                GestureDetector(
                  onTap: () => _getDurationDays(),
                  child: Container(
                    width: 88,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: greyLight,
                    ),
                    child: Center(
                      child: Obx(
                        () {
                          return Text(
                            "${addHabitC.durationDaysHabit.value} day(s)",
                            style: interBold12.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: getHeight(16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Time", style: textParagraph),
                GestureDetector(
                  onTap: () async {
                    var pickTime = await _getTime();
                    if (pickTime != null) {
                      addHabitC.setTimeOfDayHabit(pickTime);
                    }
                  },
                  child: Container(
                    width: 88,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: greyLight,
                    ),
                    child: Center(
                      child: Obx(() {
                        return Text(
                          todToString(addHabitC.timeOfDayHabit.value),
                          style: interBold12.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      }),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: getHeight(16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Frequency", style: textParagraph),
                Container(
                  width: 88,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: greyLight,
                  ),
                  child: Center(
                    child: Text(
                      "Weekly",
                      style: interBold12.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: getHeight(16)),
            Obx(() {
              return WeekdaySelector(
                onChanged: (int day) {
                  print(day);
                  final index = day % 7;
                  addHabitC.setList(index);
                  print(addHabitC.dayList);
                },
                selectedFillColor: yellowDark,
                color: naturalBlack,
                selectedColor: naturalBlack,
                fillColor: greyLight,
                firstDayOfWeek: 7,
                elevation: 0,
                selectedElevation: 0,
                values: addHabitC.dayList,
              );
            }),
            const Spacer(),
            GestureDetector(
              onTap: () {
                if (addHabitC.dayList.contains(true)) {
                  _saveHabit();
                } else {
                  Get.snackbar(
                    "Choose date first",
                    "Select one or more days to schedule",
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
            SizedBox(height: getHeight(16)),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Text("Cancel", style: textParagraph),
            ),
            SizedBox(height: getHeight(72)),
          ],
        ),
      ),
    );
  }
}
