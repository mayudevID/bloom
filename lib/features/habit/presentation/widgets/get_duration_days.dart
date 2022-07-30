import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../../core/utils/constant.dart';
import '../../../../core/utils/theme.dart';
import '../bloc/add_habit/add_habit_cubit.dart';
import '../bloc/edit_habit/edit_habit_cubit.dart';

Dialog getDurationDays(BuildContext context, HabitPageType type) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Container(
      width: 150,
      height: 180,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Duration (days)", style: buttonSmall),
          const SizedBox(height: 5),
          SizedBox(
            width: 250,
            height: 70,
            child: Center(
              child: (type == HabitPageType.add)
                  ? BlocBuilder<AddHabitCubit, AddHabitState>(
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
                    )
                  : BlocBuilder<EditHabitCubit, EditHabitState>(
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
                          minValue: state.openDays
                                  .where((item) => item == true)
                                  .length +
                              1,
                          maxValue: 100,
                          value: state.durationDays,
                          onChanged: (value) {
                            context
                                .read<EditHabitCubit>()
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
    ),
  );
}
