import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloom/models/pomodoro.dart';
import 'package:bloom/widgets/notifications.dart';
import 'package:get/get.dart';
//import 'package:audioplayers/audio_cache.dart';

class TimerController extends GetxController {
  var countdownDuration = const Duration().obs;
  var isRunning = false.obs;
  var isCompleted = false.obs;
  var session = 1.obs;
  late int earlyTime;
  Timer? timer;
  final PomodoroModel pomodoroModel;

  TimerController(this.pomodoroModel);

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    earlyTime = pomodoroModel.durationMinutes * 60 * 1000;
    countdownDuration.value = Duration(minutes: pomodoroModel.durationMinutes);
  }

  @override
  void onReady() {
    // ignore: todo
    // TODO: implement onReady
    super.onReady();
    startCountDown();
    isRunning.value = true;
  }

  @override
  void onClose() {
    // ignore: todo
    // TODO: implement onClose
    super.onClose();
    timer?.cancel();
    AwesomeNotifications().cancel(pomodoroModel.pomodoroId);
  }

  void reduceTime() {
    const reduceVal = 100;
    int milliseconds = countdownDuration.value.inMilliseconds - reduceVal;
    if (milliseconds < 0) {
      timer?.cancel();
      isCompleted.value = true;
      isRunning.value = false;
      createTimerNotification(pomodoroModel, session.value);
    } else {
      countdownDuration.value = Duration(milliseconds: milliseconds);
    }
  }

  void startCountDown() {
    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => reduceTime(),
    );
  }

  void pauseCountdown() {
    timer?.cancel();
  }

  void toggleTimer() {
    if (isRunning.value) {
      pauseCountdown();
      isRunning.value = false;
    } else if (isCompleted.value) {
      nextSession();
    } else {
      startCountDown();
      isRunning.value = true;
    }
  }

  void nextSession() {
    if (isCompleted.value) {
      countdownDuration.value =
          Duration(minutes: pomodoroModel.durationMinutes);
      session.value++;
      startCountDown();
      isCompleted.value = false;
      isRunning.value = true;
    }
  }
}
