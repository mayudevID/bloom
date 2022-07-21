// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:bloom/core/utils/function.dart';
import 'package:bloom/features/pomodoro/data/models/pomodoro_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/routes/route_name.dart';
import '../../../../core/utils/theme.dart';

class PomodoroRecentWidget extends StatelessWidget {
  PomodoroRecentWidget({Key? key, required this.pomodoroModel})
      : super(key: key);
  final PomodoroModel pomodoroModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: getHeight(125, context),
      margin: EdgeInsets.symmetric(horizontal: getWidth(24, context)),
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 19,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: yellowLight,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pomodoroModel.title,
                style: textParagraph,
              ),
              Text(
                "${pomodoroModel.durationMinutes}:00",
                style: mainTitle.copyWith(
                  fontSize: 40,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                RouteName.TIMER,
                arguments: pomodoroModel,
              );
            },
            child: Container(
              width: 123,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: naturalBlack,
              ),
              child: Center(
                child: Text(
                  "Play",
                  style: buttonSmall.copyWith(
                    color: naturalWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
