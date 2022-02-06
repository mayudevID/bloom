// ignore_for_file: must_be_immutable

import 'package:bloom/widgets/form_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme.dart';

class ForgotPasswordPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  ForgotPasswordPage({Key? key}) : super(key: key);

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
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Enter your registered email so we can send you a link to reset password",
                style: smallText,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 18),
            FormInput(
              icon: 'mail',
              hintText: 'Email',
              controller: emailController,
            ),
            const SizedBox(height: 24),
            Container(
              height: 56,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: yellowDark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Send",
                  style: buttonLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
