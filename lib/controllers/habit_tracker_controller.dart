import 'package:get/get.dart';

class HabitTrackerController extends GetxController {
  DateTime dateSelector = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  void setDate(DateTime date) {
    dateSelector = date;
    update();
  }
}
