import 'dart:async';

import 'package:bloom/controllers/auth_controller.dart';
import 'package:get/get.dart';

class VerificationTimeController extends GetxController {
  final authController = Get.find<AuthController>();
  var countdownDuration = const Duration(minutes: 1).obs;
  var isFinished = false.obs;
  Timer? timerCheckEmail;
  Timer? timerResend;

  @override
  void onReady() {
    // ignore: todo
    // TODO: implement onReady
    super.onReady();
    startCountDown();
    startCheckEmail();
  }

  @override
  void onClose() {
    // ignore: todo
    // TODO: implement onClose
    super.onClose();
    timerCheckEmail!.cancel();
    timerResend!.cancel();
  }

  void startCheckEmail() {
    timerCheckEmail = Timer.periodic(
      const Duration(seconds: 5),
      (_) => authController.checkEmailVerified(),
    );
  }

  void startCountDown() {
    timerResend = Timer.periodic(
      const Duration(seconds: 1),
      (_) => reduceTime(),
    );
  }

  void reduceTime() {
    const reduceVal = 1;
    int seconds = countdownDuration.value.inSeconds - reduceVal;
    if (seconds < 0) {
      timerResend?.cancel();
      isFinished.value = true;
    } else {
      countdownDuration.value = Duration(seconds: seconds);
    }
  }

  void setResendTime() {
    countdownDuration.value = const Duration(minutes: 1);
    isFinished.value = false;
    startCountDown();
  }
}
