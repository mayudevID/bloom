// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../../../core/utils/constant.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../../authentication/data/repositories/local_auth_repository.dart';
import '../../domain/habits_repository.dart';
import '../bloc/add_habit/add_habit_cubit.dart';
import '../widgets/get_duration_days.dart';
import '../widgets/get_icon_dialog.dart';

class AddHabitsPage extends StatelessWidget {
  const AddHabitsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddHabitCubit(
        habitsRepository: context.read<HabitsRepository>(),
        localUserDataRepository: context.read<LocalUserDataRepository>(),
      ),
      child: const AddHabitsPageContent(),
    );
  }
}

class AddHabitsPageContent extends StatelessWidget {
  const AddHabitsPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final monday = context.select(
      (AddHabitCubit cubit) => cubit.state.monday,
    );
    final sunday = context.select(
      (AddHabitCubit cubit) => cubit.state.sunday,
    );
    final thursday = context.select(
      (AddHabitCubit cubit) => cubit.state.thursday,
    );
    final wednesday = context.select(
      (AddHabitCubit cubit) => cubit.state.wednesday,
    );
    final tuesday = context.select(
      (AddHabitCubit cubit) => cubit.state.tuesday,
    );
    final friday = context.select(
      (AddHabitCubit cubit) => cubit.state.friday,
    );
    final saturday = context.select(
      (AddHabitCubit cubit) => cubit.state.saturday,
    );

    final title = context.select(
      (AddHabitCubit cubit) => cubit.state.title,
    );

    Future<TimeOfDay?> _getTime() async {
      final TimeOfDay? pickTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      return pickTime;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: naturalWhite,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Center(child: Text("New Habit", style: mainSubTitle)),
            SizedBox(height: getHeight(16, context)),
            Container(
              width: 74,
              height: 74,
              color: naturalWhite,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: yellowDark),
                        color: const Color(0xffFCF7D3),
                      ),
                      child: BlocBuilder<AddHabitCubit, AddHabitState>(
                        builder: (context, state) {
                          return Image.asset(
                            iconLocation[state.selectedIcon],
                            width: 32,
                            scale: 3,
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: 54,
                    bottom: 54,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return getIconDialog(context, HabitPageType.add);
                          },
                        );
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: const Color(0xffFED8B6),
                        ),
                        child: Image.asset(
                          "assets/icons/pen.png",
                          width: 12,
                          scale: 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: getHeight(32, context)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Habit Name", style: textParagraph),
            ),
            SizedBox(height: getHeight(4, context)),
            Container(
              padding: const EdgeInsets.all(5),
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: greyLight,
              ),
              child: BlocBuilder<AddHabitCubit, AddHabitState>(
                buildWhen: (previous, current) {
                  return previous.title != current.title;
                },
                builder: (context, state) {
                  return TextFormField(
                    onChanged: (val) {
                      context.read<AddHabitCubit>().titleChanged(val);
                    },
                    style: textForm,
                    cursorColor: naturalBlack,
                    decoration: InputDecoration.collapsed(
                      hintText: "Input title",
                      hintStyle: textForm.copyWith(color: greyDark),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: getHeight(16, context)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Goals", style: textParagraph),
            ),
            SizedBox(height: getHeight(4, context)),
            Container(
              padding: const EdgeInsets.all(5),
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: greyLight,
              ),
              child: BlocBuilder<AddHabitCubit, AddHabitState>(
                buildWhen: (previous, current) {
                  return previous.goals != current.goals;
                },
                builder: (context, state) {
                  return TextFormField(
                    onChanged: (value) {
                      context.read<AddHabitCubit>().goalsChanged(value);
                    },
                    style: textForm,
                    maxLines: 4,
                    maxLength: 1000,
                    cursorColor: naturalBlack,
                    decoration: InputDecoration.collapsed(
                      hintText: "Input goals",
                      hintStyle: textForm.copyWith(color: greyDark),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: getHeight(16, context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Duration", style: textParagraph),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return BlocProvider.value(
                          value: context.read<AddHabitCubit>(),
                          child: getDurationDays(context, HabitPageType.add),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 88,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: greyLight,
                    ),
                    child: Center(
                      child: BlocBuilder<AddHabitCubit, AddHabitState>(
                        builder: (context, state) {
                          return Text(
                            "${state.durationDays} day(s)",
                            style: interBold12.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: getHeight(16, context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Time", style: textParagraph),
                GestureDetector(
                  onTap: () async {
                    var pick = await _getTime();
                    if (pick != null) {
                      final now = DateTime.now();
                      final target = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        pick.hour,
                        pick.minute,
                      );
                      context.read<AddHabitCubit>().timeChanged(target);
                    }
                  },
                  child: Container(
                    width: 88,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: greyLight,
                    ),
                    child: Center(
                      child: BlocBuilder<AddHabitCubit, AddHabitState>(
                        builder: (context, state) {
                          return Text(
                            todToString(
                              TimeOfDay.fromDateTime(state.timeOfDay),
                            ),
                            style: interBold12.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: getHeight(16, context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Frequency", style: textParagraph),
                Container(
                  width: 88,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: greyLight,
                  ),
                  child: Center(
                    child: Text(
                      "Weekly",
                      style: interBold12.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: getHeight(16, context)),
            BlocBuilder<AddHabitCubit, AddHabitState>(
              builder: (context, state) {
                return WeekdaySelector(
                  onChanged: (int day) {
                    final index = day % 7;
                    context.read<AddHabitCubit>().dayListChanged(index);
                  },
                  selectedFillColor: yellowDark,
                  color: naturalBlack,
                  selectedColor: naturalBlack,
                  fillColor: greyLight,
                  firstDayOfWeek: 7,
                  elevation: 0,
                  selectedElevation: 0,
                  values: [
                    state.sunday,
                    state.monday,
                    state.tuesday,
                    state.wednesday,
                    state.thursday,
                    state.friday,
                    state.saturday
                  ],
                );
              },
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                if (monday == false &&
                    sunday == false &&
                    tuesday == false &&
                    wednesday == false &&
                    thursday == false &&
                    friday == false &&
                    saturday == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Select one or more days to schedule",
                      ),
                    ),
                  );
                } else if (title.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please input the name of habit",
                      ),
                    ),
                  );
                } else {
                  context.read<AddHabitCubit>().saveHabit();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Habit Added",
                      ),
                    ),
                  );
                }
              },
              child: Container(
                width: 202,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: naturalBlack,
                ),
                child: Center(
                  child: Text(
                    "Save",
                    style: buttonSmall.copyWith(
                      color: naturalWhite,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: getHeight(16, context)),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: textParagraph),
            ),
            SizedBox(height: getHeight(72, context)),
          ],
        ),
      ),
    );
  }
}
