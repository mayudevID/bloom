import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'habit.g.dart';

@HiveType(typeId: 4)
class HabitModel {
  @HiveField(0)
  int habitId;

  @HiveField(1)
  String iconImg;

  @HiveField(2)
  String title;

  @HiveField(3)
  String goals;

  @HiveField(4)
  TimeOfDay timeOfDay;

  @HiveField(5)
  int durationDays;

  @HiveField(6)
  int missed;

  @HiveField(7)
  int streak;

  @HiveField(8)
  int streakLeft;

  @HiveField(9)
  List<int> dayList;

  @HiveField(10)
  List<bool> checkedDays;

  @HiveField(11)
  List<bool> openDays;

  HabitModel({
    required this.habitId,
    required this.iconImg,
    required this.title,
    required this.goals,
    required this.timeOfDay,
    required this.durationDays,
    required this.missed,
    required this.streak,
    required this.streakLeft,
    required this.dayList,
    required this.checkedDays,
    required this.openDays,
  });
}
