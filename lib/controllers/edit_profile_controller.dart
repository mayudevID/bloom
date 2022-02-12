import 'dart:io';

import 'package:bloom/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String? userId = Get.find<UserController>().userModel.value.userId;
  File? profilePictureTemp;
  RxBool isSaving = false.obs;
  RxBool isChanged = false.obs;
  //String photoLocation = 'photos/$userId/$baseName';

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    emailController.text = Get.find<UserController>().userModel.value.email!;
    nameController.text = Get.find<UserController>().userModel.value.name!;
  }
}
