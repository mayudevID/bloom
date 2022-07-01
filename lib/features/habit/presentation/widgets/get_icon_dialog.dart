import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constant.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../domain/habits_repository.dart';
import '../bloc/add_habit/add_habit_cubit.dart';

class GetIconDialog extends StatelessWidget {
  const GetIconDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return AddHabitCubit(context.read<HabitsRepository>());
      },
      child: const GetIconDialogContent(),
    );
  }
}

class GetIconDialogContent extends StatelessWidget {
  const GetIconDialogContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: 200,
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Choose Icon", style: textParagraph.copyWith(fontSize: 17)),
            SizedBox(height: getHeight(10, context)),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 70,
                childAspectRatio: 1,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: iconLocation.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.read<AddHabitCubit>().iconChanged(index);
                  },
                  child: BlocBuilder<AddHabitCubit, AddHabitState>(
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: (state.selectedIcon == index)
                                  ? yellowDark
                                  : naturalBlack,
                              width: 3),
                        ),
                        child: Image.asset(
                          iconLocation[index],
                          scale: 2,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
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
                        'Close',
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
}
