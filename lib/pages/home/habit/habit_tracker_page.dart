// ignore_for_file: must_be_immutable

import 'package:bloom/controllers/habit_tracker_controller.dart';
import 'package:bloom/models/habit.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:bloom/utils.dart';
import 'package:bloom/widgets/calendar_widget/calendar_widget.dart';
import 'package:bloom/widgets/habit_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../theme.dart';

class HabitTrackerPage extends StatelessWidget {
  HabitTrackerPage({Key? key}) : super(key: key);
  final habitTrackerC = Get.find<HabitTrackerController>();
  DateTime dateNow = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  Future<Box> habitBox = Hive.openBox('habit_db');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: naturalWhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.07),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text("Habit Tracker", style: mainSubTitle),
            ),
            SizedBox(height: Get.height * 24 / 800),
            CalendarWidget(
              initialDate: DateTime.now(),
              firstDate: DateTime(DateTime.now().year, 1, 1),
              lastDate: DateTime(DateTime.now().year, 12, 31),
              onDateSelected: (date) {
                print(date);
                habitTrackerC.setDate(date ?? habitTrackerC.dateSelector);
              },
              leftMargin: (Get.width / 2) - 20,
            ),
            SizedBox(height: Get.height * 32 / 800),
            Container(
              margin: const EdgeInsets.only(left: 24),
              child: Text(
                "My Tracker",
                style: textParagraph.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: Get.height * 8 / 800),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: FutureBuilder(
                future: habitBox,
                builder: (builder, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      var habitDb = Hive.box('habit_db');
                      return ValueListenableBuilder(
                        valueListenable: habitDb.listenable(),
                        builder: (context, value, child) {
                          if (habitDb.isEmpty) {
                            return SizedBox(
                              height: Get.height * 70 / 800,
                              child: const Center(
                                child: Text(
                                  'Habit empty for this date',
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return GetBuilder<HabitTrackerController>(
                                builder: (_) {
                              Map<int, HabitModel?> dataHabit =
                                  habitByDateChooser(
                                      habitDb, habitTrackerC.dateSelector);
                              if (dataHabit.isEmpty) {
                                return SizedBox(
                                  height: Get.height * 70 / 800,
                                  child: const Center(
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
                                  removeTop: true,
                                  context: context,
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: dataHabit.length,
                                    itemBuilder: (context, idx) {
                                      return HabitWidget(
                                        habitModel:
                                            dataHabit.values.elementAt(idx),
                                        index: dataHabit.keys.elementAt(idx),
                                      );
                                    },
                                  ),
                                );
                              }
                            });
                          }
                        },
                      );
                    }
                  } else {
                    return SizedBox(
                      height: Get.height * 70 / 800,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: Get.height * 40 / 800),
            GetBuilder<HabitTrackerController>(
              builder: (_) {
                if (dateNow.isBefore(habitTrackerC.dateSelector) ||
                    dateNow.isAtSameMomentAs(habitTrackerC.dateSelector)) {
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteName.ADDHABIT);
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
                            "Add Habit",
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
            )
          ],
        ),
      ),
    );
  }
}
