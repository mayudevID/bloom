// ignore_for_file: must_be_immutable
import 'package:bloom/features/home/widgets/navbar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../habit/presentation/pages/habit_tracker_page.dart';
import '../../pomodoro/presentation/pages/pomodoro_page.dart';
import '../../todolist/presentation/widgets/todolist_page.dart';
import '../bloc/home_cubit.dart';
import 'home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: MainPage());

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: selectedTab.index,
        children: [
          const HomePage(),
          PomodoroPage(),
          HabitTrackerPage(),
          ToDoListPage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Row(
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
    );
  }
}

// CustomNavBar(
//         items: const ["home", "timer", "calendar", "clipboard"],
//         selectedIndex: state.index,
//       ),