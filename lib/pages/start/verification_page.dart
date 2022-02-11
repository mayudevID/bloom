import 'package:bloom/controllers/auth_controller.dart';
import 'package:bloom/controllers/verification_time_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme.dart';

class VerificationPage extends StatelessWidget {
  VerificationPage({Key? key}) : super(key: key);
  final verificationTimeController = Get.put(VerificationTimeController());
  final authController = Get.find<AuthController>();
  //final userEmail = "Mblem";
  String twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    Widget resendButton() {
      return GestureDetector(
        onTap: () async {
          await authController.sendVerification();
          verificationTimeController.setResendTime();
        },
        child: Container(
          height: 56,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: yellowDark,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              "Resend email",
              style: buttonLarge,
            ),
          ),
        ),
      );
    }

    Widget resendButtonInactive() {
      return Container(
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: greyLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "Resend email",
            style: buttonLarge.copyWith(color: greyDark),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: naturalWhite,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.11),
            Image.asset("assets/icons/logo.png", width: 100),
            Text("Verification", style: mainTitle),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "An email has been sent to ${authController.userAuth!.email}. check email for verification and the page will move automatically. If the email hasn't arrived, please resend it",
                style: smallText,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Obx(() {
              if (verificationTimeController.isFinished.value) {
                return resendButton();
              } else {
                return resendButtonInactive();
              }
            }),
            const SizedBox(height: 16),
            Obx(() {
              var minutes = twoDigits(verificationTimeController
                  .countdownDuration.value.inMinutes
                  .remainder(60));
              var seconds = twoDigits(verificationTimeController
                  .countdownDuration.value.inSeconds
                  .remainder(60));
              return Text(
                "Resend ($minutes:$seconds)",
                style: smallText.copyWith(
                  fontWeight: FontWeight.w700,
                  color: greyDark,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
