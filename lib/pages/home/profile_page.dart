import 'package:bloom/controllers/auth_controller.dart';
import 'package:bloom/controllers/user_local_db.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:bloom/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../models/user.dart';
import '../../utils.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  final userLocalDb = UserLocalDB();
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
                  onTap: () async {
                    var userData = await Hive.openBox('user_data');
                    userData.close();
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
            SizedBox(height: getHeight(32)),
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
            SizedBox(height: getHeight(8)),
            StreamBuilder(
              stream: authController.streamAuthStatus,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  User user = snapshot.data as User;
                  return Text(
                    user.displayName as String,
                    style: buttonSmall.copyWith(
                      fontSize: 14,
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            SizedBox(height: getHeight(8)),
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
            SizedBox(height: getHeight(32)),
            FutureBuilder(
              future: Hive.openBox('user_data'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    var userData = Hive.box('user_data');
                    UserModel userModel = userData.get('user');
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userModel.habitStreak.toString(),
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Habit Streak",
                              style: smallTextLink.copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                        SizedBox(width: getWidth(24)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userModel.taskCompleted.toString(),
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Task Completed",
                              style: smallTextLink.copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                        SizedBox(width: getWidth(24)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              //crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  userModel.totalFocus.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
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
                    );
                  }
                } else {
                  return const SizedBox(
                    height: 70,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: getHeight(24)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Progress",
                style: textForm.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: getHeight(8)),
            GestureDetector(
              onTap: () => Get.toNamed(RouteName.TASKHISTORY),
              child: Container(
                height: getHeight(48),
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
                    SizedBox(width: getWidth(7)),
                    Expanded(child: Text("Task History", style: textParagraph)),
                    Image.asset("assets/icons/arrow_right.png", width: 16),
                  ],
                ),
              ),
            ),
            SizedBox(height: getHeight(8)),
            GestureDetector(
              onTap: () => Get.toNamed(RouteName.STATISTICS),
              child: Container(
                height: getHeight(48),
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
                    SizedBox(width: getWidth(7)),
                    Expanded(
                      child: Text("Habit Statistic", style: textParagraph),
                    ),
                    Image.asset("assets/icons/arrow_right.png", width: 16),
                  ],
                ),
              ),
            ),
            SizedBox(height: getHeight(8)),
            Container(
              height: getHeight(48),
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
                  SizedBox(width: getWidth(7)),
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
