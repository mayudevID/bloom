// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:bloom/controllers/user_controller.dart';
import 'package:bloom/theme.dart';
import 'package:bloom/services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/edit_profile_controller.dart';
import '../../models/user.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({Key? key}) : super(key: key);
  final editProfileC = Get.put(EditProfileController());
  final userController = Get.find<UserController>();
  final authController = Get.find<AuthController>();
  final ImagePicker _picker = ImagePicker();
  DatabaseFirebase db = DatabaseFirebase();

  Future _errorDialog() {
    return Get.defaultDialog(
      title: "Unable to change profile",
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
        "Connect to internet and then retry",
        style: buttonSmall.copyWith(fontWeight: FontWeight.w400),
      ),
      actions: [
        const SizedBox(width: 160),
        GestureDetector(
          onTap: () async {
            _saveProfile();
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
                'Retry',
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

  void _pickProfilePicture() async {
    final fileData = await _picker.pickImage(source: ImageSource.gallery);
    if (fileData != null) {
      editProfileC.profilePictureTemp = File(fileData.path);
      editProfileC.isPictureChanged.value = true;
    }
  }

  void _saveProfile() async {
    editProfileC.isSaving.value = true;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        final result = await InternetAddress.lookup('google.com')
            .timeout(const Duration(seconds: 5));
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          db.deleteProfilePicture();
          String photoURLold = authController.userAuth!.photoURL as String;
          String displayName = editProfileC.nameController.text;
          String photoURL =
              await db.uploadProfilePicture(editProfileC.profilePictureTemp);
          if (await authController.updateData(displayName, photoURL)) {
            UserModel userModel = UserModel(
              userId: userController.userModel.value.userId,
              name: displayName,
              email: userController.userModel.value.email,
              habitStreak: userController.userModel.value.habitStreak,
              taskCompleted: userController.userModel.value.taskCompleted,
              totalFocus: userController.userModel.value.totalFocus,
              missed: userController.userModel.value.missed,
              completed: userController.userModel.value.completed,
              streakLeft: userController.userModel.value.streakLeft,
            );
            CachedNetworkImage.evictFromCache(photoURLold);
            if (await db.createNewUser(userModel)) {
              await userController.setUser(userModel);
            }
          }
        }
      } on SocketException catch (e) {
        _errorDialog();
      }
    } else {
      _errorDialog();
    }
    editProfileC.isSaving.value = false;
  }

  @override
  Widget build(BuildContext context) {
    Future exitDialog() {
      return Get.defaultDialog(
        title: "Profile unsaved",
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
          "Profile not saved. Exit anyway?",
          style: buttonSmall.copyWith(fontWeight: FontWeight.w400),
        ),
        actions: [
          const SizedBox(width: 250),
          GestureDetector(
            onTap: () {
              Get.back();
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
                  'Exit',
                  style: buttonSmall.copyWith(
                    color: naturalWhite,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 70,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: naturalBlack,
              ),
              child: Center(
                child: Text(
                  'Cancel',
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

    return Scaffold(
      backgroundColor: naturalWhite,
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.07),
            Text(
              "Edit Profile",
              style: mainSubTitle,
            ),
            const SizedBox(height: 32),
            Obx(() {
              if (editProfileC.isPictureChanged.value == true) {
                return CircleAvatar(
                  radius: 40,
                  backgroundImage: FileImage(
                    editProfileC.profilePictureTemp as File,
                  ),
                );
              } else {
                return CachedNetworkImage(
                  imageUrl: authController.userAuth!.photoURL as String,
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
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                );
              }
            }),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pickProfilePicture(),
              child: Text(
                "Change Profile Picture",
                style: textParagraph,
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Email",
                style: buttonSmall.copyWith(fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: greyDark),
                color: const Color(0xffF2F2F2),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/icons/mail.png",
                    width: 24,
                    color: greyDark,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: editProfileC.emailController,
                      style: textForm.copyWith(
                        color: greyDark,
                        fontWeight: FontWeight.w600,
                      ),
                      cursorColor: naturalBlack,
                      decoration: InputDecoration.collapsed(
                        enabled: false,
                        hintText: 'Your email',
                        hintStyle: textForm.copyWith(color: greyDark),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Name",
                style: buttonSmall.copyWith(fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: naturalBlack),
              ),
              child: Row(
                children: [
                  Image.asset("assets/icons/person.png", width: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: editProfileC.nameController,
                      style: textForm,
                      cursorColor: naturalBlack,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Your name',
                        hintStyle: textForm.copyWith(color: greyDark),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                if (editProfileC.isSaving.value == false) {
                  _saveProfile();
                }
              },
              child: Container(
                width: 202,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: naturalBlack,
                ),
                child: Center(
                  child: Obx(() {
                    if (editProfileC.isSaving.value == true) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: naturalWhite,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Saving..",
                            style: buttonSmall.copyWith(color: naturalWhite),
                          ),
                        ],
                      );
                    } else {
                      return Text(
                        "Save",
                        style: buttonSmall.copyWith(color: naturalWhite),
                      );
                    }
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                if (editProfileC.isPictureChanged.value == true ||
                    editProfileC.nameController.text.trim() !=
                        editProfileC.defaultName) {
                  exitDialog();
                } else {
                  Get.back();
                }
              },
              child: Text("Cancel", style: textParagraph),
            ),
            const SizedBox(height: 72),
          ],
        ),
      ),
    );
  }
}
