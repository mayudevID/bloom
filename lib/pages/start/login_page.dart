// ignore_for_file: must_be_immutable
import 'package:bloom/controllers/auth_controller.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:bloom/theme.dart';
import 'package:bloom/widgets/button_logo.dart';
import 'package:bloom/widgets/form_input.dart';
import 'package:bloom/widgets/form_input_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final authController = Get.find<AuthController>();

  Future<void> handleSignIn() async {
    authController.isLoading.value = true;
    await authController.signIn(
        emailController.text.trim(), passwordController.text.trim());
    authController.isLoading.value = false;
  }

  Future<void> handleSignInGoogle() async {
    authController.isLoadingGoogle.value = true;
    await authController.signInSignUpWithGoogle();
    authController.isLoadingGoogle.value = false;
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
            Text("Login", style: mainTitle),
            const SizedBox(height: 32),
            FormInput(
              hintText: 'Email',
              icon: 'mail',
              controller: emailController,
            ),
            const SizedBox(height: 8),
            FormInputPassword(controller: passwordController),
            const SizedBox(height: 9),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 30),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteName.FORGETPASS);
                  },
                  child: Text("Forgot Password?", style: smallTextLink),
                ),
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                if (!authController.isLoading.value) {
                  handleSignIn();
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
                      child: Text("Login", style: buttonLarge),
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
            Text("Or login with", style: smallText),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ButtonLogo(platformLogo: 'fb'),
                const SizedBox(width: 28.8),
                Obx(() {
                  return GestureDetector(
                    onTap: () {
                      if (!authController.isLoadingGoogle.value) {
                        handleSignInGoogle();
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
                Text("Don't have an account? ", style: smallText),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteName.REGISTER);
                  },
                  child: Text(
                    "Create Account",
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
