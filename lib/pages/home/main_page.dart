// ignore_for_file: must_be_immutable

import 'package:bloom/controllers/mainpage_controller.dart';
import 'package:bloom/pages/home/pomodoro/pomodoro_page.dart';
import 'package:bloom/pages/home/todolist/todolist_page.dart';
import 'package:bloom/widgets/custom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'habit/habit_tracker_page.dart';
import 'home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainPageController>(
      builder: (mainPageController) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: IndexedStack(
            index: mainPageController.tabIndex,
            children: [
              HomePage(),
              PomodoroPage(),
              HabitTrackerPage(),
              ToDoListPage(),
            ],
          ),
          bottomNavigationBar: CustomNavBar(
            items: const ["home", "timer", "calendar", "clipboard"],
            onItemSelected: mainPageController.changeTabIndex,
            selectedIndex: mainPageController.tabIndex,
          ),
        );
      },
    );
  }
}
