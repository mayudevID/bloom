// ignore_for_file: must_be_immutable
import 'package:bloom/controllers/pomodoro_controller.dart';
import 'package:bloom/models/pomodoro.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:marquee/marquee.dart';

import '../theme.dart';

class PomodoroCard extends StatelessWidget {
  final int index;
  final PomodoroModel pomodoroModel;
  final pomodoroController = Get.find<PomodoroController>();
  bool isLast;
  PomodoroCard(
      {Key? key,
      required this.index,
      required this.pomodoroModel,
      this.isLast = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        Get.bottomSheet(
          Container(
            padding: const EdgeInsets.all(24),
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: naturalWhite,
            ),
            child: GestureDetector(
              onTap: () async {
                var pomodoroDb = await Hive.openBox('pomodoro_db');
                if (pomodoroDb.length == 1) {
                  pomodoroDb.clear();
                } else {
                  pomodoroDb.deleteAt(index);
                }
                pomodoroDb.close();
                Get.back();
              },
              child: Row(
                children: [
                  Image.asset("assets/icons/delete.png", width: 35),
                  const SizedBox(width: 15),
                  Text(
                    "Delete timer",
                    style: textParagraph.copyWith(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        width: 99,
        height: 120,
        margin: EdgeInsets.only(
          left: isLast ? 24 : 8,
          right: index == 0 ? 24 : 8,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 19),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: yellowLight,
        ),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Expanded(
              child: Marquee(
                text: pomodoroModel.title,
                style: textParagraph,
                velocity: 25,
                blankSpace: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text("${pomodoroModel.durationMinutes}:00", style: buttonSmall),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Get.toNamed(
                  RouteName.TIMER,
                  arguments: pomodoroModel,
                );
                pomodoroController.newRecent(pomodoroModel);
              },
              child: Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: naturalBlack,
                ),
                child: Center(
                  child: Text(
                    "Start",
                    style: smallTextLink.copyWith(
                      fontSize: 8,
                      color: naturalWhite,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
