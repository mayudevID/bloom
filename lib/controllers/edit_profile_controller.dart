import 'dart:io';
import 'package:bloom/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final userC = Get.find<UserController>();
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
    userId = userC.userModel.value.userId;
    emailController.text = userC.userModel.value.email as String;
    nameController.text = userC.userModel.value.name as String;
    defaultName = userC.userModel.value.name;
  }
}
