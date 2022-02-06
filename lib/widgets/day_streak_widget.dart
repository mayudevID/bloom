// ignore_for_file: must_be_immutable

import 'package:bloom/models/habit.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../theme.dart';

class DayStreakWidget extends StatelessWidget {
  int dayIndex;
  int modelIndex;
  HabitModel habitModel;

  DayStreakWidget({
    Key? key,
    required this.dayIndex,
    required this.modelIndex,
    required this.habitModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: yellowDark,
      ),
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Day ${dayIndex + 1}", style: textParagraph),
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              activeColor: naturalBlack,
              value: habitModel.checkedDays[dayIndex],
              onChanged: (bool? value) async {
                List<bool> newCheckedDays = [];
                for (var i = 0; i < habitModel.checkedDays.length; i++) {
                  if (i == modelIndex) {
                    newCheckedDays[i] = value!;
                  } else {
                    newCheckedDays[i] = habitModel.checkedDays[i];
                  }
                }
                HabitModel newHabitModel = HabitModel(
                  habitId: habitModel.habitId,
                  iconImg: habitModel.iconImg,
                  title: habitModel.title,
                  goals: habitModel.goals,
                  timeOfDay: habitModel.timeOfDay,
                  durationDays: habitModel.durationDays,
                  missed: habitModel.missed,
                  streak: habitModel.streak,
                  streakLeft: habitModel.streakLeft,
                  dayList: habitModel.dayList,
                  checkedDays: habitModel.checkedDays,
                  openDays: habitModel.openDays,
                );
                var habitDb = await Hive.openBox('habit_db');
                habitDb.putAt(modelIndex, newHabitModel);
              },
            ),
          ),
        ],
      ),
    );
  }
}
