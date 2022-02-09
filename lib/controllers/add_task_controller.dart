import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTaskController extends GetxController {
  DateTime dateSelector;
  Rx<DateTime> dateChoose = (DateTime.now()).obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  AddTaskController(this.dateSelector);

  RxBool isTime = false.obs;
  RxBool isChoose = false.obs;
  RxBool isRepeat = false.obs;
  RxString tags = "Basic".obs;

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    dateChoose.value = dateSelector;
  }

  void setDateTime(DateTime time) {
    dateChoose.value = time;
  }
}
