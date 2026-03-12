// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/route_name.dart';
import '../../../../core/utils/notifications.dart';
import '../../../../core/utils/theme.dart';
import '../../data/models/habit_model.dart';
import '../bloc/habit_overview/habits_overview_bloc.dart';

class HabitWidget extends StatelessWidget {
  HabitWidget({
    Key? key,
    required this.habitModel,
    //required this.index,
  }) : super(key: key);
  HabitModel? habitModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final dynamic isDeleted = await Navigator.of(context).pushNamed(
          RouteName.HABITDETAIL,
          arguments: habitModel,
        );
        if (isDeleted as bool) {
          Future.delayed(
            const Duration(milliseconds: 50),
            () async {
              await cancelAllHabitNotifications(habitModel!);
              if (!context.mounted) return;
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
        margin: const EdgeInsets.only(bottom: 8),
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
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(habitModel!.title, style: interSemiBold14),
                  Row(
                    children: [
                      Image.asset("assets/icons/clock.png", width: 12),
                      const SizedBox(width: 2),
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
