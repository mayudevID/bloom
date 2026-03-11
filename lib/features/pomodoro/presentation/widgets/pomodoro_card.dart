// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import '../../../../core/routes/route_name.dart';
import '../../../../core/utils/theme.dart';
import '../../data/models/pomodoro_model.dart';
import '../bloc/pomodoro_recent/pomodoro_recent_bloc.dart';

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
                  const SizedBox(width: 15),
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
      width: 99,
      height: 120,
      margin: EdgeInsets.only(
        left: isLast ? 24 : 4,
        right: index == 0 ? 24 : 4,
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
              text: pomodoro.title,
              style: textParagraph,
              velocity: 25,
              blankSpace: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text("${pomodoro.durationMinutes}:00", style: buttonSmall),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                RouteName.TIMER,
                arguments: pomodoro,
              );
              context
                  .read<PomodoroRecentBloc>()
                  .add(PomodoroRecentSaved(pomodoro));
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
