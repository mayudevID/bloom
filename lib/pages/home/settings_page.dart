import 'package:bloom/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);
  final authController = Get.find<AuthController>();

  Future<void> _handleSignOut() async {
    authController.isLoading.value = true;
    await authController.signOut();
    authController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: naturalWhite,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.07),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Image.asset("assets/icons/arrow_back.png", width: 24),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: Get.width * 0.5 - 48 - 50,
                  ),
                  child: Text(
                    "Settings",
                    style: mainSubTitle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 51),
            GestureDetector(
              onTap: () {
                if (!authController.isLoading.value) {
                  _handleSignOut();
                }
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: redLight,
                ),
                child: Obx(() {
                  if (!authController.isLoading.value) {
                    return Center(
                      child: Text(
                        "Logout",
                        style: buttonSmall.copyWith(
                          color: naturalWhite,
                        ),
                      ),
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: naturalWhite),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Loading",
                          style: buttonSmall.copyWith(
                            color: naturalWhite,
                          ),
                        ),
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
