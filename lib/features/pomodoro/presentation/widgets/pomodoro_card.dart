// ignore_for_file: must_be_immutable
import 'package:bloom/core/routes/route_name.dart';
import 'package:bloom/features/pomodoro/data/models/pomodoro_model.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';

Widget pomodoroCard({
  required BuildContext context,
  required int index,
  required PomodoroModel pomodoro,
  required bool isLast,
  required Function() onTap,
}) {
  return GestureDetector(
    onLongPress: () async {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
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
              onTap: onTap,
              child: Row(
                children: [
                  Image.asset("assets/icons/delete.png", width: 35),
                  SizedBox(width: getWidth(15, context)),
                  Text(
                    "Delete timer",
                    style: textParagraph.copyWith(fontSize: 17),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
    child: Container(
      width: getWidth(99, context),
      height: getHeight(120, context),
      margin: EdgeInsets.only(
        left: isLast ? getWidth(24, context) : getWidth(4, context),
        right: index == 0 ? getWidth(24, context) : getWidth(4, context),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 19),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: yellowLight,
      ),
      child: Column(
        children: [
          SizedBox(height: getHeight(15, context)),
          Expanded(
            child: Marquee(
              text: pomodoro.title,
              style: textParagraph,
              velocity: 25,
              blankSpace: 20,
            ),
          ),
          SizedBox(height: getHeight(10, context)),
          Text("${pomodoro.durationMinutes}:00", style: buttonSmall),
          SizedBox(height: getHeight(10, context)),
          GestureDetector(
            onTap: () {
              // Get.toNamed(
              //   RouteName.TIMER,
              //   arguments: pomodoroModel,
              // );
              Navigator.of(context).pushNamed(
                RouteName.TIMER,
                arguments: pomodoro,
              );
              //pomodoroController.newRecent(pomodoroModel);
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
          SizedBox(height: getHeight(20, context)),
        ],
      ),
    ),
  );
}
