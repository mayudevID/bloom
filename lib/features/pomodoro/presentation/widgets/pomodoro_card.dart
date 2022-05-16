// ignore_for_file: must_be_immutable
import 'package:bloom/core/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';

class PomodoroCard extends StatelessWidget {
  final int index;
  final int indexPomodoro;
  final Pomodoro pomodoro;
  //final pomodoroController = Get.find<PomodoroController>();
  bool isLast;
  PomodoroCard(
      {Key? key,
      required this.index,
      required this.pomodoro,
      this.isLast = false,
      required this.indexPomodoro})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                onTap: () async {
                  // var pomodoroDb = await Hive.openBox('pomodoro_db');
                  // if (pomodoroDb.length == 1) {
                  //   pomodoroDb.clear();
                  // } else {
                  //   pomodoroDb.deleteAt(index);
                  // }
                  context
                      .read<PomodoroBloc>()
                      .add(DeletePomodoroEvent(index: indexPomodoro));
                  Navigator.pop(context);
                },
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
                Navigator.pushNamed(
                  context,
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
}
