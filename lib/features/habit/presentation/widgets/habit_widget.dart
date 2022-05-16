// ignore_for_file: must_be_immutable
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/route_name.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../data/models/habit_model.dart';
import '../bloc/habit_overview/habits_overview_bloc.dart';

class HabitWidget extends StatelessWidget {
  HabitModel? habitModel;
  HabitWidget({
    Key? key,
    required this.habitModel,
    //required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        dynamic isDeleted = Navigator.pushNamed(
          context,
          RouteName.HABITDETAIL,
          arguments: habitModel,
        );
        if (isDeleted as bool) {
          Future.delayed(
            const Duration(milliseconds: 500),
            () async {
              for (var i = 0; i < habitModel!.dayList.length; i++) {
                AwesomeNotifications().cancel(
                  habitModel!.habitId * habitModel!.dayList[i],
                );
              }
              context.read<HabitsOverviewBloc>().add(
                    HabitsOverviewHabitDeleted(
                      habitModel!,
                    ),
                  );
            },
          );
        }
      },
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: getHeight(8, context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: yellowLight,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xfffcf7d3),
                border: Border.all(color: yellowDark),
              ),
              child: Center(
                child: Image.asset(
                  habitModel!.iconImg,
                  width: 24,
                ),
              ),
            ),
            SizedBox(width: getWidth(8, context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(habitModel!.title, style: interSemiBold14),
                  Row(
                    children: [
                      Image.asset("assets/icons/clock.png", width: 12),
                      SizedBox(width: getWidth(2, context)),
                      Text(
                        // format(context)
                        TimeOfDay.fromDateTime(habitModel!.timeOfDay)
                            .format(context),
                        style: smallText.copyWith(
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
