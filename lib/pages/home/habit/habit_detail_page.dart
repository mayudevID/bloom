import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloom/models/habit.dart';
import 'package:bloom/theme.dart';
import 'package:bloom/utils.dart';
import 'package:bloom/widgets/day_streak_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HabitDetailPage extends StatelessWidget {
  HabitDetailPage({Key? key}) : super(key: key);
  final int modelIndex = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: naturalWhite,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: FutureBuilder(
          future: Hive.openBox("habit_db"),
          builder: (builder, snapshot) {
            if (snapshot.hasData) {
              var habitDb = Hive.box("habit_db");
              //HabitModel habitTarget = habitDb.getAt(modelIndex);
              return Column(
                children: [
                  SizedBox(height: Get.height * 0.07),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(result: false),
                        child: Image.asset(
                          "assets/icons/arrow_back.png",
                          width: 24,
                        ),
                      ),
                      const Spacer(),
                      Image.asset("assets/icons/share.png", width: 24),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () async {
                          HabitModel habitTarget = habitDb.getAt(modelIndex);
                          for (var i = 0; i < habitTarget.dayList.length; i++) {
                            AwesomeNotifications().cancel(
                                habitTarget.habitId * habitTarget.dayList[i]);
                          }
                          Get.back(result: true);
                        },
                        child: Image.asset(
                          "assets/icons/delete.png",
                          width: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: yellowDark),
                          color: const Color(0xffFCF7D3),
                        ),
                        child: ValueListenableBuilder(
                          valueListenable: habitDb.listenable(),
                          builder: (context, box, _) {
                            HabitModel habitModel = habitDb.getAt(modelIndex);
                            return Image.asset(
                              habitModel.iconImg,
                              width: 32,
                              scale: 3,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: habitDb.listenable(),
                          builder: (context, box, _) {
                            HabitModel habitModel = habitDb.getAt(modelIndex);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(habitModel.title, style: buttonLarge),
                                Text(
                                  "Every day, ${todToString(habitModel.timeOfDay)}",
                                  style: textForm,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: habitDb.listenable(),
                        builder: (context, box, _) {
                          HabitModel habitModel = habitDb.getAt(modelIndex);
                          int count = habitModel.checkedDays
                              .where((item) => item == true)
                              .length;
                          return Text(
                            "$count/${habitModel.durationDays}",
                            style: textForm,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Progress",
                        style: smallText.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "View Statistic",
                        style: smallText.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: habitDb.listenable(),
                            builder: (context, box, _) {
                              HabitModel test = habitDb.getAt(modelIndex);
                              return Text(
                                test.missed.toString(),
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            },
                          ),
                          Text(
                            "Missed",
                            style: smallTextLink.copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: habitDb.listenable(),
                            builder: (context, box, _) {
                              HabitModel habitModel = habitDb.getAt(modelIndex);
                              return Text(
                                habitModel.streak.toString(),
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            },
                          ),
                          Text(
                            "Streak",
                            style: smallTextLink.copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: habitDb.listenable(),
                            builder: (context, box, _) {
                              HabitModel habitModel = habitDb.getAt(modelIndex);
                              return Text(
                                habitModel.streakLeft.toString(),
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            },
                          ),
                          Text(
                            "Streak Left",
                            style: smallTextLink.copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Daily Streak",
                      style: smallText.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 311,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ValueListenableBuilder(
                        valueListenable: habitDb.listenable(),
                        builder: (context, box, _) {
                          HabitModel habitModel = habitDb.getAt(modelIndex);
                          return ListView.builder(
                            itemCount: habitModel.durationDays,
                            itemBuilder: (context, idx) {
                              return DayStreakWidget(
                                dayIndex: idx,
                                modelIndex: modelIndex,
                                habitModel: habitModel,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 56),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 202,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: naturalBlack,
                      ),
                      child: Center(
                        child: Text(
                          "Edit",
                          style: buttonSmall.copyWith(
                            color: naturalWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
