import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  void setDateTime(String time) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String stringDate = dateFormat.format(dateChoose.value);
    String newDateChooseString = stringDate + " " + time;
    DateFormat newDateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
    DateTime newDateChoose = newDateFormat.parse(newDateChooseString);
    dateChoose.value = newDateChoose;
  }
}
