// ignore_for_file: must_be_immutable

import 'package:bloom/controllers/auth_controller.dart';
import 'package:bloom/widgets/form_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme.dart';
import '../../utils.dart';

class ForgotPasswordPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  ForgotPasswordPage({Key? key}) : super(key: key);
  final authController = AuthController();
  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: naturalWhite,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.11),
            Image.asset("assets/icons/logo.png", width: 100),
            Text("Forgot Password", style: mainTitle),
            SizedBox(height: getHeight(8)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Enter your registered email so we can send you a link to reset password",
                style: smallText,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: getHeight(18)),
            FormInput(
              icon: 'mail',
              hintText: 'Email',
              controller: emailController,
            ),
            SizedBox(height: getHeight(24)),
            GestureDetector(
              onTap: () async {
                if (!isLoading.value) {
                  isLoading.value = true;
                  authController.resetPassword(emailController.text.trim());
                  isLoading.value = false;
                }
              },
              child: Container(
                height: 56,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: yellowDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Obx(() {
                  if (!isLoading.value) {
                    return Center(
                      child: Text(
                        "Send",
                        style: buttonLarge,
                      ),
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(color: naturalBlack),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text("Loading", style: buttonLarge),
                      ],
                    );
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
