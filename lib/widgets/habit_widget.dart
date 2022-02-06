// ignore_for_file: must_be_immutable

import 'package:bloom/models/habit.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

class HabitWidget extends StatelessWidget {
  HabitModel? habitModel;
  int? index;
  HabitWidget({Key? key, required this.habitModel, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteName.HABITDETAIL, arguments: [habitModel, index]);
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
                        habitModel!.timeOfDay.format(context),
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
