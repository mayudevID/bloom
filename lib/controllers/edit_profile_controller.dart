import 'dart:io';

import 'package:bloom/controllers/auth_controller.dart';
import 'package:bloom/controllers/user_local_db.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final authController = Get.find<AuthController>();
  final userController = Get.find<UserController>();
  String? userId;
  File? profilePictureTemp;
  String? defaultName;
  RxBool isSaving = false.obs;
  RxBool isPictureChanged = false.obs;
  RxBool isSaved = false.obs;
  //String photoLocation = 'photos/$userId/$baseName';

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    userId = authController.userAuth!.uid;
    emailController.text = authController.userAuth!.email as String;
    nameController.text = userController.userModel.value.name as String;
    defaultName = userController.userModel.value.name;
  }
}
