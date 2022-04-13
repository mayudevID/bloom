import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:weekday_selector/weekday_selector.dart';

class AddHabitsPage extends StatelessWidget {
  const AddHabitsPage({Key? key}) : super(key: key);
  //final addHabitsC = Get.put(AddHabitsController());
  //final userController = Get.find<UserController>();

  void _saveHabits() async {
    if (addHabitsC.titleController.text.trim().isNotEmpty) {
      Map<int, bool> dayMap = addHabitsC.dayList.asMap();

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

      HabitsModel habitModel = HabitsModel(
        habitId: getRandomId(),
        iconImg: addHabitsC.iconLocation[addHabitsC.currentIcon.value],
        title: addHabitsC.titleController.text.trim(),
        timeOfDay: addHabitsC.timeOfDayHabits.value,
        durationDays: addHabitsC.durationDaysHabits.value,
        dayList: dayListOn,
        checkedDays: List.filled(addHabitsC.durationDaysHabits.value, false),
        openDays: List.filled(addHabitsC.durationDaysHabits.value, false),
        missed: 0,
        streak: 0,
        streakLeft: addHabitsC.durationDaysHabits.value,
        goals: (addHabitsC.goalsController.text.trim().isEmpty)
            ? "No Goals"
            : addHabitsC.goalsController.text.trim(),
      );

      var habitDb = await Hive.openBox('habit_db');
      habitDb.add(habitModel);

      for (var i = 0; i < habitModel.dayList.length; i++) {
        createHabitsNotification(habitModel, habitModel.dayList[i]);
      }

      await userController.updateData(
          'streakLeft', addHabitsC.durationDaysHabits.value);

      Get.back();
      Get.snackbar(
        "Habits Added",
        "\"${addHabitsC.titleController.text}\" added to My Habits",
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
        "Habits Name Empty",
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
        initialTime: addHabitsC.timeOfDayHabits.value,
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
            itemCount: addHabitsC.iconLocation.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => addHabitsC.currentIcon.value = index,
                child: Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: (addHabitsC.currentIcon.value == index)
                              ? yellowDark
                              : naturalBlack,
                          width: 3),
                    ),
                    child: Image.asset(
                      addHabitsC.iconLocation[index],
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
                  value: addHabitsC.durationDaysHabits.value,
                  onChanged: (value) {
                    addHabitsC.durationDaysHabits.value = value;
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
            Center(child: Text("New Habits", style: mainSubTitle)),
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
                          addHabitsC.iconLocation[addHabitsC.currentIcon.value],
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
              child: Text("Habits Name", style: textParagraph),
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
                controller: addHabitsC.titleController,
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
                controller: addHabitsC.goalsController,
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
                            "${addHabitsC.durationDaysHabits.value} day(s)",
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
                      addHabitsC.setTimeOfDayHabits(pickTime);
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
                          todToString(addHabitsC.timeOfDayHabits.value),
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
                  addHabitsC.setList(index);
                  print(addHabitsC.dayList);
                },
                selectedFillColor: yellowDark,
                color: naturalBlack,
                selectedColor: naturalBlack,
                fillColor: greyLight,
                firstDayOfWeek: 7,
                elevation: 0,
                selectedElevation: 0,
                values: addHabitsC.dayList,
              );
            }),
            const Spacer(),
            GestureDetector(
              onTap: () {
                if (addHabitsC.dayList.contains(true)) {
                  _saveHabits();
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
