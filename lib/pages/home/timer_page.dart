import 'package:bloom/controllers/timer_controller.dart';
import 'package:bloom/models/pomodoro.dart';
import 'package:bloom/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../utils.dart';

class TimerPage extends StatelessWidget {
  TimerPage({Key? key}) : super(key: key);
  final timeCount = Get.put(TimerController(Get.arguments));
  final PomodoroModel data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    Future exitDialog() {
      return Get.defaultDialog(
        title: "Exit",
        titleStyle: buttonSmall,
        titlePadding: const EdgeInsets.only(
          top: 20,
          bottom: 5,
        ),
        contentPadding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        content: Text(
          "Timer is running or session is in progress, Continue?",
          style: buttonSmall.copyWith(fontWeight: FontWeight.w400),
        ),
        actions: [
          const SizedBox(width: 90),
          GestureDetector(
            onTap: () {
              Get.back();
              Get.back();
            },
            child: Container(
              width: 70,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: naturalBlack,
              ),
              child: Center(
                child: Text(
                  'Exit',
                  style: buttonSmall.copyWith(
                    color: naturalWhite,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 70,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: naturalBlack,
              ),
              child: Center(
                child: Text(
                  'Cancel',
                  style: buttonSmall.copyWith(
                    color: naturalWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: yellowLight,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.07),
            GestureDetector(
              onTap: () {
                if (timeCount.isCompleted.value &&
                    timeCount.session.value == data.session) {
                  Get.back();
                } else {
                  exitDialog();
                }
              },
              child: Image.asset("assets/icons/arrow_back.png", width: 24),
            ),
            const SizedBox(height: 16),
            Center(child: Text(data.title, style: mainSubTitle)),
            const SizedBox(height: 4),
            Center(
              child: Obx(() {
                return Text(
                  '${timeCount.session.value} of ${data.session} sessions',
                  style: textParagraph,
                );
              }),
            ),
            const SizedBox(height: 48),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 293,
                    height: 293,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: yellowDark,
                    ),
                  ),
                  Obx(() {
                    var minutes = twoDigits(timeCount
                        .countdownDuration.value.inMinutes
                        .remainder(60));
                    var seconds = twoDigits(timeCount
                        .countdownDuration.value.inSeconds
                        .remainder(60));
                    return CircularPercentIndicator(
                      radius: 293 / 2,
                      lineWidth: 12,
                      backgroundColor: yellowDark,
                      percent:
                          timeCount.countdownDuration.value.inMilliseconds /
                              timeCount.earlyTime,
                      reverse: true,
                      center: SizedBox(
                        child: Text(
                          "$minutes:$seconds",
                          style: mainTitle.copyWith(
                            fontSize: 56,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: naturalBlack,
                    );
                  }),
                  Positioned(
                    left: 293 / 2 - 6,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: naturalWhite,
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 2),
                            blurRadius: 7,
                            color: Colors.black.withOpacity(0.25),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: GestureDetector(
                onTap: () {
                  timeCount.toggleTimer();
                },
                child: Obx(() {
                  return Container(
                    width: (timeCount.isCompleted.value) ? 120 : 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: (timeCount.isCompleted.value &&
                              timeCount.session.value == data.session)
                          ? yellowLight
                          : naturalBlack,
                    ),
                    child: Center(
                      child: timeCount.isRunning.value
                          ? Image.asset(
                              "assets/icons/pause.png",
                              width: 32,
                            )
                          : (timeCount.isCompleted.value &&
                                  timeCount.session.value < data.session)
                              ? Text(
                                  "Start Next Session",
                                  style: buttonSmall.copyWith(
                                    color: naturalWhite,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : (timeCount.isCompleted.value &&
                                      timeCount.session.value == data.session)
                                  ? Text(
                                      "Finish",
                                      style: buttonLarge.copyWith(
                                        color: naturalBlack,
                                      ),
                                    )
                                  : Image.asset(
                                      "assets/icons/play.png",
                                      width: 32,
                                    ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
