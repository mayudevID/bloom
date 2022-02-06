import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPomodoroController extends GetxController {
  TextEditingController titleController = TextEditingController();
  RxInt valueDuration = 25.obs;
  RxInt valueSessions = 3.obs;
}
