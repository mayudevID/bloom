// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:bloom/controllers/user_controller.dart';
import 'package:bloom/theme.dart';
import 'package:bloom/services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  void _pickProfilePicture() async {
    final fileData = await _picker.pickImage(source: ImageSource.gallery);
    if (fileData != null) {
      editProfileC.profilePictureTemp = File(fileData.path);
    }
  }

  void _saveProfile() async {
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

      if (await db.createNewUser(userModel)) {
        await userController.setUser(userModel);
      }
    }
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
                    left: Get.width * 0.5 - 48 - 63.5,
                  ),
                  child: Text(
                    "Edit Profile",
                    style: mainSubTitle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            CachedNetworkImage(
              imageUrl: authController.userAuth!.photoURL as String,
              imageBuilder: (context, imageProvider) => Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
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
          ],
        ),
      ),
    );
  }
}
