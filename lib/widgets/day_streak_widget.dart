// ignore_for_file: must_be_immutable

import 'package:bloom/controllers/user_controller.dart';
import 'package:bloom/models/habit.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

import '../theme.dart';

class DayStreakWidget extends StatelessWidget {
  int dayIndex;
  int modelIndex;
  HabitModel habitModel;
  final userController = Get.find<UserController>();

  DayStreakWidget({
    Key? key,
    required this.dayIndex,
    required this.modelIndex,
    required this.habitModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: (habitModel.openDays[dayIndex] == true) ? yellowDark : greyLight,
      ),
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Day ${dayIndex + 1}",
            style: textParagraph.copyWith(
              color: (habitModel.openDays[dayIndex] == true)
                  ? Colors.black
                  : greyDark,
            ),
          ),
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              activeColor: naturalBlack,
              value: habitModel.checkedDays[dayIndex],
              onChanged: (habitModel.openDays[dayIndex] == true)
                  ? (bool? value) async {
                      List<bool> newCheckedDays = habitModel.checkedDays;
                      newCheckedDays[dayIndex] = value!;
                      // int newCheckedDaysVal = newCheckedDays.where((item) => item == true).length;
                      // int openDaysVal = habitModel.openDays.where((item) => item == true).length;
                      //int newMissed = (openDaysVal - newCheckedDaysVal).abs();
                      HabitModel newHabitModel = HabitModel(
                        habitId: habitModel.habitId,
                        iconImg: habitModel.iconImg,
                        title: habitModel.title,
                        goals: habitModel.goals,
                        timeOfDay: habitModel.timeOfDay,
                        durationDays: habitModel.durationDays,
                        missed: (newCheckedDays[dayIndex] == true)
                            ? habitModel.missed - 1
                            : habitModel.missed + 1,
                        streak: (newCheckedDays[dayIndex] == true)
                            ? habitModel.streak + 1
                            : habitModel.streak - 1,
                        streakLeft: (newCheckedDays[dayIndex] == true)
                            ? habitModel.streakLeft - 1
                            : habitModel.streakLeft + 1,
                        dayList: habitModel.dayList,
                        checkedDays: newCheckedDays,
                        openDays: habitModel.openDays,
                      );
                      var habitDb = await Hive.openBox('habit_db');
                      habitDb.putAt(modelIndex, newHabitModel);
                      userController.updateData(
                        'missed',
                        (newCheckedDays[dayIndex]),
                      );
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
