// ignore_for_file: must_be_immutable

import 'package:bloom/controllers/auth_controller.dart';
import 'package:bloom/widgets/button_logo.dart';
import 'package:bloom/widgets/form_input.dart';
import 'package:bloom/widgets/form_input_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme.dart';

class CreateAccountPage extends StatelessWidget {
  CreateAccountPage({Key? key}) : super(key: key);
  final authController = Get.find<AuthController>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> handleSignUp() async {
    authController.isLoading.value = true;
    await authController.signUp(nameController.text.trim(),
        emailController.text.trim(), passwordController.text.trim());
    await authController.sendVerification();
    authController.isLoading.value = false;
  }

  Future<void> handleSignUpGoogle() async {
    authController.isLoadingGoogle.value = true;
    await authController.signInSignUpWithGoogle();
    authController.isLoadingGoogle.value = false;
  }

  Future<void> handleSignUpFacebook() async {
    authController.isLoadingFacebook.value = true;
    await authController.signInSignUpWithFacebook();
    authController.isLoadingFacebook.value = false;
  }

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
            Text("Create Account", style: mainTitle),
            const SizedBox(height: 32),
            FormInput(
              hintText: 'Name',
              icon: 'person',
              controller: nameController,
            ),
            const SizedBox(height: 8),
            FormInput(
              hintText: 'Email',
              icon: 'mail',
              controller: emailController,
            ),
            const SizedBox(height: 8),
            FormInputPassword(controller: passwordController),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                if (!authController.isLoading.value) {
                  handleSignUp();
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
                  if (!authController.isLoading.value) {
                    return Center(
                      child: Text("Create Account", style: buttonLarge),
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
            const SizedBox(height: 23),
            Text("Or Create new account with", style: smallText),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const ButtonLogo(platformLogo: 'fb'),
                Obx(() {
                  return GestureDetector(
                    onTap: () {
                      if (!authController.isLoadingFacebook.value) {
                        handleSignUpFacebook();
                      }
                    },
                    child: (authController.isLoadingFacebook.value)
                        ? const ButtonLogo(platformLogo: '-')
                        : const ButtonLogo(platformLogo: 'fb'),
                  );
                }),
                const SizedBox(width: 28.8),
                Obx(() {
                  return GestureDetector(
                    onTap: () {
                      if (!authController.isLoadingGoogle.value) {
                        handleSignUpGoogle();
                      }
                    },
                    child: (authController.isLoadingGoogle.value)
                        ? const ButtonLogo(platformLogo: '-')
                        : const ButtonLogo(platformLogo: 'google'),
                  );
                }),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? ", style: smallText),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Text(
                    "Login",
                    style: smallText.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
