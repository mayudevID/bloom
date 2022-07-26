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
  const MainPage({Key? key, required this.isGetData}) : super(key: key);

  final bool isGetData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: MainPageContent(isGetData: isGetData),
    );
  }
}

class MainPageContent extends StatefulWidget {
  const MainPageContent({Key? key, required this.isGetData}) : super(key: key);

  final bool isGetData;

  @override
  State<MainPageContent> createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> {
  void loadData() async {
    await Future.delayed(const Duration(milliseconds: 700));
    context.read<HomeCubit>().getDataBackup(widget.isGetData);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) async {
          if (state.status == LoadStatus.load) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  insetPadding: const EdgeInsets.only(
                    left: 120,
                    right: 120,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  content: SizedBox(
                    height: 100,
                    child: Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          color: naturalBlack,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state.status == LoadStatus.finish) {
            Navigator.of(context).pop();
            context.read<HomeCubit>().finishToDone();
          }
        },
        child: IndexedStack(
          index: selectedTab.index,
          children: const [
            HomePage(),
            PomodoroPage(),
            HabitTrackerPage(),
            ToDoListPage(),
          ],
        ),
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