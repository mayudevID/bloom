import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddHabitController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController goalsController = TextEditingController();
  RxString dropDownValue = 'Weekly'.obs;
  RxInt currentIcon = 0.obs;
  RxList<bool> dayList = List.filled(7, false).obs;
  Rx<TimeOfDay> timeOfDayHabit = (TimeOfDay.now()).obs;
  RxInt durationDaysHabit = 7.obs;
  List<String> iconLocation = [
    'assets/icons/work_habit.png',
    'assets/icons/sleep_habit.png',
    'assets/icons/cycle_habit.png',
    'assets/icons/draw_habit.png',
    'assets/icons/run_habit.png',
  ];

  void setTimeOfDayHabit(TimeOfDay time) {
    timeOfDayHabit.value = time;
  }

  void setList(int index) {
    dayList[index] = !dayList[index];
  }
}
