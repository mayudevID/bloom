import 'package:bloom/controllers/auth_controller.dart';
import 'package:bloom/controllers/user_controller.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:bloom/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  final userController = Get.find<UserController>();
  final authController = Get.find<AuthController>();

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
                    left: Get.width * 0.5 - 48 - 59,
                  ),
                  child: Text(
                    "My Profile",
                    style: mainSubTitle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            StreamBuilder<User?>(
              stream: authController.streamAuthStatus,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  User user = snapshot.data as User;
                  return CachedNetworkImage(
                    imageUrl: user.photoURL as String,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    placeholder: (context, url) {
                      return const SizedBox(
                        width: 80.0,
                        height: 80.0,
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return const SizedBox(
                        width: 80.0,
                        height: 80.0,
                        child: Icon(Icons.error),
                      );
                    },
                  );
                } else {
                  return const SizedBox(
                    width: 80.0,
                    height: 80.0,
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            //Image.asset("assets/icons/profpict.png", width: 80),
            const SizedBox(height: 8),
            Obx(() {
              return Text(
                userController.userModel.value.name.toString(),
                style: buttonSmall.copyWith(fontSize: 14),
              );
            }),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Get.toNamed(RouteName.EDITPROFILE),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: naturalBlack),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 20,
                width: 80,
                child: Center(
                  child: Text(
                    "Edit profile",
                    style: smallTextLink.copyWith(
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      return Text(
                        userController.userModel.value.habitStreak.toString(),
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }),
                    Text(
                      "Habit Streak",
                      style: smallTextLink.copyWith(fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      return Text(
                        userController.userModel.value.taskCompleted.toString(),
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }),
                    Text(
                      "Task Completed",
                      style: smallTextLink.copyWith(fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Obx(() {
                          return Text(
                            userController.userModel.value.totalFocus
                                .toString(),
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        }),
                        Text(
                          "h",
                          style: smallText.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Total Focus",
                      style: smallTextLink.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Progress",
                style: textForm.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Get.toNamed(RouteName.TASKHISTORY),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: yellowLight,
                ),
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 16,
                  top: 12,
                  bottom: 12,
                ),
                child: Row(
                  children: [
                    Image.asset("assets/icons/clipboard_select.png", width: 24),
                    const SizedBox(width: 7),
                    Expanded(child: Text("Task History", style: textParagraph)),
                    Image.asset("assets/icons/arrow_right.png", width: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Get.toNamed(RouteName.STATISTICS),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: yellowLight,
                ),
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 16,
                  top: 12,
                  bottom: 12,
                ),
                child: Row(
                  children: [
                    Image.asset("assets/icons/calendar_select.png", width: 24),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text("Habit Statistic", style: textParagraph),
                    ),
                    Image.asset("assets/icons/arrow_right.png", width: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: yellowLight,
              ),
              padding: const EdgeInsets.only(
                left: 12,
                right: 16,
                top: 12,
                bottom: 12,
              ),
              child: Row(
                children: [
                  Image.asset("assets/icons/timer_select.png", width: 24),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text("Timer Statistic", style: textParagraph),
                  ),
                  Image.asset("assets/icons/arrow_right.png", width: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
