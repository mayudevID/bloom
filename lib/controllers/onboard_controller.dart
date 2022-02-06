import 'package:get/get.dart';

class OnboardController extends GetxController {
  List<String> title = [
    "Plan your day and become a better you",
    "Stay focus and motivated",
    "Reach your goals",
  ];

  List<String> description = [
    "Plan and organize your life to archive your strengths, challenges and goals",
    "Stay focus while we track your day to motivated you to reach your goals",
    "It's now or never. There's nothing better than achieving your goals, whatever they might be",
  ];

  RxInt currentIndex = 0.obs;

  void changeSlide(int index) {
    currentIndex.value = index;
    //update();
  }
}
