// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:io';
import 'package:bloom/controllers/user_local_db.dart';
import 'package:bloom/models/user.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:bloom/services/firebase_database.dart';
import 'package:bloom/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import '../theme.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userLocalDb = UserLocalDB();
  final firebaseDb = FirebaseDB();
  RxBool isLoading = false.obs;
  RxBool isLoadingGoogle = false.obs;
  RxBool isLoadingFacebook = false.obs;

  Stream<User?> get streamAuthStatus => _auth.userChanges();
  User? get userAuth => _auth.currentUser;

  Future<void> signUp(String name, String email, String password) async {
    try {
      var _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      File photoDefault = await getImageFileFromAssets('icons/profpict.png');
      String photoURL = await firebaseDb.uploadProfilePicture(photoDefault);
      _auth.currentUser!.updatePhotoURL(photoURL);
      _auth.currentUser!.updateDisplayName(name);
      UserModel _userModel = UserModel(
        userId: _authResult.user?.uid,
        name: name,
        email: email,
        habitStreak: 0,
        taskCompleted: 0,
        totalFocus: 0,
        missed: 0,
        completed: 0,
        streakLeft: 0,
        isNewUser: true,
      );
      if (await firebaseDb.createNewUser(_userModel)) {
        await userLocalDb.setUser(_userModel);
        Get.toNamed(RouteName.VERIFICATION);
      }
    } on FirebaseException catch (e) {
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
        await userLocalDb
            .setUser(await firebaseDb.getUser(_authResult.user!.uid));
        Get.offAllNamed(RouteName.MAIN, arguments: false);
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
            SizedBox(width: getWidth(180)),
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
                Get.offAllNamed(RouteName.MAIN, arguments: false);
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
      await FacebookAuth.instance.logOut();
      await userLocalDb.clear();
      var taskDb = await Hive.openBox('task_db');
      var habitDb = await Hive.openBox('habit_db');
      var pomodoroDb = await Hive.openBox('pomodoro_db');
      var taskHistoryDb = await Hive.openBox('task_history_db');
      taskDb.clear();
      habitDb.clear();
      pomodoroDb.clear();
      taskHistoryDb.clear();
      taskDb.close();
      habitDb.close();
      pomodoroDb.close();
      taskHistoryDb.close();
      Get.offAllNamed(RouteName.LOGIN);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signInSignUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: ['profile', 'email']).signIn();

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
            name: _authResult.user!.displayName,
            email: _authResult.user!.email,
            userId: _authResult.user?.uid,
            habitStreak: 0,
            taskCompleted: 0,
            totalFocus: 0,
            missed: 0,
            completed: 0,
            streakLeft: 0,
            isNewUser: true,
          );

          if (await firebaseDb.createNewUser(_userModel)) {
            await userLocalDb.setUser(_userModel);
            Get.offAllNamed(RouteName.MAIN, arguments: true);
          }
        } else {
          await userLocalDb
              .setUser(await firebaseDb.getUser(_authResult.user!.uid));
          Get.offAllNamed(RouteName.MAIN, arguments: false);
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future<void> signInSignUpWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.accessToken?.token != null) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        var credentialSave = await Hive.openBox('credentialSave');
        await credentialSave.put('token', loginResult.accessToken!.token);
        credentialSave.close();
        var _authResult =
            await _auth.signInWithCredential(facebookAuthCredential);

        if (_authResult.additionalUserInfo!.isNewUser) {
          UserModel _userModel = UserModel(
            name: _authResult.user!.displayName,
            email: _authResult.user!.email,
            userId: _authResult.user?.uid,
            habitStreak: 0,
            taskCompleted: 0,
            totalFocus: 0,
            missed: 0,
            completed: 0,
            streakLeft: 0,
            isNewUser: true,
          );

          if (await firebaseDb.createNewUser(_userModel)) {
            await userLocalDb.setUser(_userModel);
            print("GO TO VERIF PAGE");
            await sendVerification();
            Get.offAllNamed(RouteName.VERIFICATION);
          }
        } else {
          await userLocalDb
              .setUser(await firebaseDb.getUser(_authResult.user!.uid));
          Get.offAllNamed(RouteName.MAIN, arguments: false);
        }
      }
    } on FirebaseException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        Get.defaultDialog(
          title: "SignIn Alert",
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
            "Account Already Exists (Google) With Different Credential\n\nLogin with Google to link your account",
            style: buttonSmall.copyWith(fontWeight: FontWeight.w400),
          ),
          actions: [
            SizedBox(width: getWidth(160)),
            GestureDetector(
              onTap: () async {
                await linkGoogleAndFacebook();
              },
              child: Container(
                width: 200,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: naturalBlack,
                ),
                child: Center(
                  child: Text(
                    'Link to Google Account',
                    style: buttonSmall.copyWith(
                      color: naturalWhite,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
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
                    'Close',
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
    }
  }

  Future<void> linkGoogleAndFacebook() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
      try {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        var _authResultGoogle = await _auth.signInWithCredential(credential);

        var credentialSave = await Hive.openBox('credentialSave');

        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(credentialSave.get('token'));

        await _authResultGoogle.user!
            .linkWithCredential(facebookAuthCredential);

        credentialSave.clear();
        credentialSave.close();

        await userLocalDb
            .setUser(await firebaseDb.getUser(_authResultGoogle.user!.uid));
        Get.offAllNamed(RouteName.MAIN, arguments: false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          Get.snackbar(
            "Failed to link account",
            "Invalid Email/Email not found\nTry to change Google account",
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
    }
  }

  Future<void> sendVerification() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  Future<void> checkEmailVerified() async {
    await _auth.currentUser!.reload();
    if (_auth.currentUser!.emailVerified) {
      Get.offAllNamed(RouteName.MAIN, arguments: true);
    }
  }

  Future<bool> updateData(String displayName, String photoURL) async {
    try {
      await _auth.currentUser!.reload();
      await _auth.currentUser!.updateDisplayName(displayName);
      await _auth.currentUser!.updatePhotoURL(photoURL);
      return true;
    } on Exception catch (e) {
      return false;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      var providerList = await _auth.fetchSignInMethodsForEmail(email);
      print(providerList);
      // if (providerList.contains('password')) {
      //   await _auth.sendPasswordResetEmail(email: email);
      // } else {
      //   Get.snackbar(
      //     "Account not listed",
      //     "Email is linked to Google Account/Facebook, not password",
      //     colorText: naturalWhite,
      //     snackPosition: SnackPosition.BOTTOM,
      //     margin: const EdgeInsets.only(
      //       bottom: 80,
      //       left: 30,
      //       right: 30,
      //     ),
      //     backgroundColor: naturalBlack,
      //     animationDuration: const Duration(milliseconds: 100),
      //     forwardAnimationCurve: Curves.fastOutSlowIn,
      //     reverseAnimationCurve: Curves.fastOutSlowIn,
      //   );
      // }
    } on FirebaseException catch (e) {
      Get.snackbar(
        "Invalid Email",
        "Email not found",
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
}
