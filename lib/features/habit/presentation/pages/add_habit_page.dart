import 'package:bloom/core/utils/constant.dart';
import 'package:bloom/features/habit/domain/habits_repository.dart';
import 'package:bloom/features/habit/presentation/bloc/add_habit/add_habit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../widgets/get_icon_dialog.dart';

class AddHabitsPage extends StatelessWidget {
  const AddHabitsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddHabitCubit(context.read<HabitsRepository>()),
      child: const AddHabitsPageContent(),
    );
  }
}

class AddHabitsPageContent extends StatelessWidget {
  const AddHabitsPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<TimeOfDay?> _getTime() async {
      final TimeOfDay? pickTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      return pickTime;
    }

    Future _getIcon() {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const GetIconDialog();
        },
      );
    }

    Future _getDurationDays() {
      return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text("Duration (days)", style: buttonSmall),
                const SizedBox(height: 5),
                SizedBox(
                  width: 250,
                  height: 70,
                  child: Center(
                    child: BlocBuilder<AddHabitCubit, AddHabitState>(
                      builder: (context, state) {
                        return NumberPicker(
                          itemWidth: 60,
                          textStyle: textParagraph.copyWith(
                            fontWeight: FontWeight.w600,
                            color: naturalBlack,
                            fontSize: 16,
                          ),
                          selectedTextStyle: textParagraph.copyWith(
                            fontWeight: FontWeight.w600,
                            color: naturalBlack,
                            fontSize: 20,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: naturalBlack),
                          ),
                          axis: Axis.horizontal,
                          minValue: 1,
                          maxValue: 100,
                          value: state.durationDays,
                          onChanged: (value) {
                            context
                                .read<AddHabitCubit>()
                                .durationChanged(value);
                          },
                          step: 1,
                        );
                      },
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 70,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: naturalBlack,
                        ),
                        child: Center(
                          child: Text(
                            'Back',
                            style: buttonSmall.copyWith(
                              color: naturalWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: naturalWhite,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Center(child: Text("New Habits", style: mainSubTitle)),
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
                        buildWhen: (previous, current) {
                          return previous.selectedIcon != current.selectedIcon;
                        },
                        builder: (context, state) {
                          print(state.selectedIcon);
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
                      onTap: () => _getIcon(),
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
              child: Text("Habits Name", style: textParagraph),
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
              // child: TextFormField(
              //   controller: addHabitsC.titleController,
              //   style: textForm,
              //   cursorColor: naturalBlack,
              //   decoration: InputDecoration.collapsed(
              //     hintText: "Input title",
              //     hintStyle: textForm.copyWith(color: greyDark),
              //   ),
              // ),
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
              // child: TextFormField(
              //   controller: addHabitsC.goalsController,
              //   style: textForm,
              //   maxLines: 4,
              //   maxLength: 1000,
              //   cursorColor: naturalBlack,
              //   decoration: InputDecoration.collapsed(
              //     hintText: "Input goals",
              //     hintStyle: textForm.copyWith(color: greyDark),
              //   ),
              // ),
            ),
            SizedBox(height: getHeight(16, context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Duration", style: textParagraph),
                GestureDetector(
                  onTap: () => _getDurationDays(),
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
                          now.year, now.month, now.day, pick.hour, pick.minute);
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
                                TimeOfDay.fromDateTime(state.timeOfDay)),
                            style: interBold12.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        },
                      ),
                      // child: Obx(() {
                      //   return Text(
                      //     todToString(addHabitsC.timeOfDayHabits.value),
                      //     style: interBold12.copyWith(
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   );
                      // }),
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
                    // print(day);
                    // final index = day % 7;
                    // context.read<AddHabitCubit>().dayListChanged(index);
                    // addHabitsC.setList(index);
                    // print(addHabitsC.dayList);
                  },
                  // selectedFillColor: yellowDark,
                  // color: naturalBlack,
                  // selectedColor: naturalBlack,
                  // fillColor: greyLight,
                  // firstDayOfWeek: 7,
                  // elevation: 0,
                  // selectedElevation: 0,
                  values: state.dayList,
                );
              },
            ),
            // Obx(() {
            //   return WeekdaySelector(
            //     onChanged: (int day) {
            //       print(day);
            //       final index = day % 7;
            //       addHabitsC.setList(index);
            //       print(addHabitsC.dayList);
            //     },
            //     selectedFillColor: yellowDark,
            //     color: naturalBlack,
            //     selectedColor: naturalBlack,
            //     fillColor: greyLight,
            //     firstDayOfWeek: 7,
            //     elevation: 0,
            //     selectedElevation: 0,
            //     values: addHabitsC.dayList,
            //   );
            // }),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                final dayList = context
                    .select((AddHabitCubit cubit) => cubit.state.dayList);
                final title =
                    context.select((AddHabitCubit cubit) => cubit.state.title);
                if (dayList.contains(true) == false) {
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
                        "Habits Added",
                      ),
                    ),
                  );
                }
                // Get.snackbar(
                //   "Choose date first",
                //   "Select one or more days to schedule",
                //   colorText: naturalWhite,
                //   snackPosition: SnackPosition.BOTTOM,
                //   margin: const EdgeInsets.only(
                //     bottom: 80,
                //     left: 30,
                //     right: 30,
                //   ),
                //   backgroundColor: naturalBlack,
                //   animationDuration: const Duration(milliseconds: 100),
                //   forwardAnimationCurve: Curves.fastOutSlowIn,
                //   reverseAnimationCurve: Curves.fastOutSlowIn,
                // );
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
