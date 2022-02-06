import 'dart:async';
import 'package:bloom/controllers/user_controller.dart';
import 'package:bloom/models/user.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:bloom/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import '../theme.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  RxBool isLoadingGoogle = false.obs;

  Stream<User?> get streamAuthStatus => _auth.authStateChanges();
  User? get userAuth => _auth.currentUser;

  Future<void> signUp(String name, String email, String password) async {
    try {
      var _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserModel _userModel = UserModel(
        userId: _authResult.user?.uid ?? '0',
        name: name,
        email: email,
        habitStreak: 0,
        taskCompleted: 0,
        totalFocus: 0,
        missed: 0,
        completed: 0,
        streakLeft: 0,
      );
      if (await DatabaseFirebase().createNewUser(_userModel)) {
        await Get.find<UserController>().setUser(_userModel);
        Get.toNamed(RouteName.VERIFICATION);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "SignUp Error",
        e.message.toString(),
        colorText: naturalWhite,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(
          bottom: 80,
          left: 30,
          right: 30,
        ),
        backgroundColor: naturalBlack,
        animationDuration: const Duration(milliseconds: 100),
        forwardAnimationCurve: Curves.fastOutSlowIn,
        reverseAnimationCurve: Curves.fastOutSlowIn,
      );
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      var _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (_authResult.user!.emailVerified) {
        await Get.find<UserController>()
            .setUser(await DatabaseFirebase().getUser(_authResult.user!.uid));
        Get.offAllNamed(RouteName.MAIN);
      } else {
        Get.defaultDialog(
          title: "Verification Email",
          titleStyle: buttonSmall,
          titlePadding: const EdgeInsets.only(
            top: 20,
            bottom: 5,
          ),
          contentPadding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          content: Text(
            "Email must be verified first",
            style: buttonSmall.copyWith(fontWeight: FontWeight.w400),
          ),
          actions: [
            const SizedBox(width: 180),
            GestureDetector(
              onTap: () async {
                await sendVerification();
                Get.toNamed(RouteName.VERIFICATION);
              },
              child: Container(
                width: 120,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: naturalBlack,
                ),
                child: Center(
                  child: Text(
                    'Resend Email',
                    style: buttonSmall.copyWith(
                      color: naturalWhite,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.offAllNamed(RouteName.MAIN);
              },
              child: Container(
                width: 70,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: naturalBlack,
                ),
                child: Center(
                  child: Text(
                    'Later',
                    style: buttonSmall.copyWith(
                      color: naturalWhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "SignIn Error",
        e.message.toString(),
        colorText: naturalWhite,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(
          bottom: 80,
          left: 30,
          right: 30,
        ),
        backgroundColor: naturalBlack,
        animationDuration: const Duration(milliseconds: 100),
        forwardAnimationCurve: Curves.fastOutSlowIn,
        reverseAnimationCurve: Curves.fastOutSlowIn,
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      await Get.find<UserController>().clear();
      var taskDb = await Hive.openBox('task_db');
      var habitDb = await Hive.openBox('habit_db');
      var pomodoroDb = await Hive.openBox('pomodoro_db');
      var taskHistoryDb = await Hive.openBox('task_history_db');
      taskDb.clear();
      habitDb.clear();
      pomodoroDb.clear();
      taskHistoryDb.clear();
      Get.offAllNamed(RouteName.LOGIN);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signInSignUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        var _authResult = await _auth.signInWithCredential(credential);

        if (_authResult.additionalUserInfo!.isNewUser) {
          UserModel _userModel = UserModel(
            name: _authResult.user!.displayName ?? 'user',
            email: _authResult.user!.email ?? 'user@user.com',
            userId: _authResult.user?.uid ?? '0',
            habitStreak: 0,
            taskCompleted: 0,
            totalFocus: 0,
            missed: 0,
            completed: 0,
            streakLeft: 0,
          );

          if (await DatabaseFirebase().createNewUser(_userModel)) {
            await Get.find<UserController>().setUser(_userModel);
          }
        } else {
          await Get.find<UserController>()
              .setUser(await DatabaseFirebase().getUser(_authResult.user!.uid));
        }

        Get.offAllNamed(RouteName.MAIN);
      }
    } on PlatformException catch (e) {}
  }

  Future<void> sendVerification() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  Future<void> checkEmailVerified() async {
    await _auth.currentUser!.reload();
    if (_auth.currentUser!.emailVerified) {
      Get.offAllNamed(RouteName.MAIN);
    }
  }
}
