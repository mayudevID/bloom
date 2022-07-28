// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/theme.dart';
import '../../data/models/habit_model.dart';
import '../bloc/habit_detail/habit_detail_bloc.dart';

class DayStreakWidget extends StatelessWidget {
  int dayIndex;
  HabitModel initHabitModel;
  //final userController = Get.find<UserController>();

  DayStreakWidget({
    Key? key,
    required this.dayIndex,
    required this.initHabitModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: (initHabitModel.openDays[dayIndex] == true)
            ? yellowDark
            : greyLight,
      ),
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Day ${dayIndex + 1}",
            style: textParagraph.copyWith(
              color: (initHabitModel.openDays[dayIndex] == true)
                  ? Colors.black
                  : greyDark,
            ),
          ),
          SizedBox(
            width: 20,
            height: 20,
            child: BlocBuilder<HabitDetailBloc, HabitDetailState>(
              builder: (context, state) {
                return Checkbox(
                  activeColor: naturalBlack,
                  value: state.checkedDays[dayIndex],
                  onChanged: (initHabitModel.openDays[dayIndex] == true)
                      ? (bool? value) async {
                          List<bool> newCheckedDays = state.checkedDays;
                          newCheckedDays[dayIndex] = value!;
                          context.read<HabitDetailBloc>().add(
                                HabitChanged(
                                  missed: (newCheckedDays[dayIndex] == true)
                                      ? state.missed - 1
                                      : state.missed + 1,
                                  streak: (newCheckedDays[dayIndex] == true)
                                      ? state.streak + 1
                                      : state.streak - 1,
                                  streakLeft: (newCheckedDays[dayIndex] == true)
                                      ? state.streakLeft - 1
                                      : state.streakLeft + 1,
                                  checkedDays: newCheckedDays,
                                ),
                              );
                        }
                      : null,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
