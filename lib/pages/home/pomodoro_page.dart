// ignore_for_file: must_be_immutable

import 'package:bloom/controllers/add_pomodoro_controller.dart';
import 'package:bloom/controllers/pomodoro_controller.dart';
import 'package:bloom/models/pomodoro.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:bloom/theme.dart';
import 'package:bloom/utils.dart';
import 'package:bloom/widgets/pomodoro_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class PomodoroPage extends StatelessWidget {
  final pomodoroController = Get.put(PomodoroController());
  ItemScrollController scrollController = ItemScrollController();
  PomodoroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future _addTimerDialog() {
      final addPomodoroController = Get.put(AddPomodoroController());
      return Get.defaultDialog(
        actions: [
          const SizedBox(width: 70),
          GestureDetector(
            onTap: () async {
              if (addPomodoroController.titleController.text.isNotEmpty) {
                var pomodoroDb = await Hive.openBox('pomodoro_db');
                pomodoroDb.add(
                  PomodoroModel(
                    pomodoroId: getRandomId(),
                    title: addPomodoroController.titleController.text.trim(),
                    durationMinutes: addPomodoroController.valueDuration.value,
                    session: addPomodoroController.valueSessions.value,
                  ),
                );
                Get.delete<AddPomodoroController>();
                Get.back();
                if (pomodoroDb.length != 1) {
                  scrollController.scrollTo(
                    index: pomodoroDb.length - 1,
                    duration: const Duration(seconds: 1),
                  );
                }
                Get.snackbar(
                  "Timer Added",
                  "\"${addPomodoroController.titleController.text}\" added to My Timer",
                  colorText: naturalWhite,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.only(
                    bottom: 80,
                    left: 30,
                    right: 30,
                  ),
                  backgroundColor: naturalBlack,
                  animationDuration: const Duration(milliseconds: 100),
                  forwardAnimationCurve: Curves.fastOutSlowIn,
                  reverseAnimationCurve: Curves.fastOutSlowIn,
                );
              } else {
                Get.snackbar(
                  "Empty Title",
                  "Enter the title first",
                  colorText: naturalWhite,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.only(
                    bottom: 40,
                    left: 30,
                    right: 30,
                  ),
                  backgroundColor: naturalBlack,
                  animationDuration: const Duration(milliseconds: 100),
                  forwardAnimationCurve: Curves.fastOutSlowIn,
                  reverseAnimationCurve: Curves.fastOutSlowIn,
                );
              }
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
                  'Add',
                  style: buttonSmall.copyWith(
                    color: naturalWhite,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.delete<AddPomodoroController>();
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
                  'Cancel',
                  style: buttonSmall.copyWith(
                    color: naturalWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
        title: "Add Timer",
        titlePadding: const EdgeInsets.only(top: 20),
        contentPadding: const EdgeInsets.only(bottom: 20),
        titleStyle: buttonSmall,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 190,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text("Title", style: smallTextLink),
              const SizedBox(height: 10),
              Container(
                height: 35,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: naturalBlack),
                ),
                child: TextFormField(
                  controller: addPomodoroController.titleController,
                  maxLength: 25,
                  buildCounter: (BuildContext context,
                      {int? currentLength, int? maxLength, bool? isFocused}) {
                    return null;
                  },
                  autofocus: true,
                  style: textForm,
                  cursorColor: naturalBlack,
                  decoration: InputDecoration.collapsed(
                    hintText: "Add Title",
                    hintStyle: textForm.copyWith(color: greyDark),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Duration\n(in Minutes)", style: smallTextLink),
                  Obx(
                    () {
                      return NumberPicker(
                        itemWidth: 35,
                        textStyle: textParagraph.copyWith(
                          fontWeight: FontWeight.w600,
                          color: naturalBlack,
                        ),
                        selectedTextStyle: textParagraph.copyWith(
                          fontWeight: FontWeight.w600,
                          color: naturalBlack,
                          fontSize: 18,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: naturalBlack),
                        ),
                        axis: Axis.horizontal,
                        minValue: 5,
                        maxValue: 45,
                        value: addPomodoroController.valueDuration.value,
                        onChanged: (value) {
                          addPomodoroController.valueDuration.value = value;
                        },
                        step: 5,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Session(s)", style: smallTextLink),
                  Obx(
                    () {
                      return NumberPicker(
                        itemWidth: 35,
                        textStyle: textParagraph.copyWith(
                          fontWeight: FontWeight.w600,
                          color: naturalBlack,
                        ),
                        selectedTextStyle: textParagraph.copyWith(
                          fontWeight: FontWeight.w600,
                          color: naturalBlack,
                          fontSize: 18,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: naturalBlack),
                        ),
                        axis: Axis.horizontal,
                        minValue: 1,
                        maxValue: 5,
                        value: addPomodoroController.valueSessions.value,
                        onChanged: (value) {
                          addPomodoroController.valueSessions.value = value;
                        },
                        step: 1,
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: naturalWhite,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Get.height * 0.07),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Pomodoro Timer",
              style: mainSubTitle,
            ),
          ),
          const SizedBox(height: 21),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "My Timer",
              style: textParagraph.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          FutureBuilder(
            future: Hive.openBox('pomodoro_db'),
            builder: (builder, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  var pomodoroDb = Hive.box('pomodoro_db');
                  return ValueListenableBuilder(
                    valueListenable: pomodoroDb.listenable(),
                    builder: (context, value, child) {
                      if (pomodoroDb.isEmpty) {
                        return const SizedBox(
                          height: 70,
                          child: Center(
                            child: Text(
                              'Timer empty',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: 120,
                          child: ScrollablePositionedList.builder(
                            itemCount: pomodoroDb.length,
                            itemScrollController: scrollController,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            itemBuilder: (context, index) {
                              PomodoroModel pomodoro = pomodoroDb.getAt(index);
                              return PomodoroCard(
                                index: index,
                                model: pomodoro,
                                isLast: index == pomodoroDb.length - 1,
                              );
                            },
                          ),
                        );
                      }
                    },
                  );
                }
              } else {
                return const SizedBox(
                  height: 70,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Recent",
              style: textParagraph.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (pomodoroController.recentList.isNotEmpty) {
              return Container(
                height: 120,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 19,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: yellowLight,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pomodoroController.recentList[0].title,
                          style: textParagraph,
                        ),
                        Text(
                          "${pomodoroController.recentList[0].durationMinutes}:00",
                          style: mainTitle.copyWith(
                            fontSize: 40,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          RouteName.TIMER,
                          arguments: pomodoroController.recentList[0],
                        );
                      },
                      child: Container(
                        width: 123,
                        height: 34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: naturalBlack,
                        ),
                        child: Center(
                          child: Text(
                            "Play",
                            style: buttonSmall.copyWith(
                              color: naturalWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox(
                height: 70,
                child: Center(
                  child: Text(
                    'Nothing opened recently',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }
          }),
          const SizedBox(height: 48),
          GestureDetector(
            onTap: () => _addTimerDialog(),
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: naturalBlack,
              ),
              child: Center(
                child: Text(
                  "Add Timer",
                  style: buttonSmall.copyWith(
                    color: naturalWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
