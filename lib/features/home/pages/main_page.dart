// ignore_for_file: must_be_immutable
import 'package:bloom/core/utils/function.dart';
import 'package:bloom/core/utils/theme.dart';
import 'package:bloom/features/home/widgets/navbar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../habit/presentation/pages/habit_tracker_page.dart';
import '../../pomodoro/presentation/pages/pomodoro_page.dart';
import '../../todolist/presentation/pages/todolist_page.dart';

import '../bloc/cubit/home_cubit.dart';
import 'home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: const MainPageContent(),
    );
  }
}

class MainPageContent extends StatelessWidget {
  const MainPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: selectedTab.index,
        children: const [
          HomePage(),
          PomodoroPage(),
          HabitTrackerPage(),
          ToDoListPage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: naturalWhite,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: getHeight(56, context),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavbarButton(
                groupVal: selectedTab,
                value: HomeTab.home,
                icon: "home",
              ),
              NavbarButton(
                groupVal: selectedTab,
                value: HomeTab.pomodoro,
                icon: "timer",
              ),
              NavbarButton(
                groupVal: selectedTab,
                value: HomeTab.habit,
                icon: "calendar",
              ),
              NavbarButton(
                groupVal: selectedTab,
                value: HomeTab.todo,
                icon: "clipboard",
              )
            ],
          ),
        ),
      ),
    );
  }
}

// CustomNavBar(
//         items: const ["home", "timer", "calendar", "clipboard"],
//         selectedIndex: state.index,
//       ),