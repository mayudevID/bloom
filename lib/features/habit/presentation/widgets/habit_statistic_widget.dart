import 'package:flutter/material.dart';

import '../../../../core/utils/theme.dart';

class HabitStatisticWidget extends StatelessWidget {
  String iconImg;
  String title;
  int count;
  HabitStatisticWidget({
    Key? key,
    required this.iconImg,
    required this.title,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 8,
        left: 8,
        bottom: 8,
        right: 20,
      ),
      width: (MediaQuery.of(context).size.width - 48 - 32) / 3,
      height: 72,
      decoration: BoxDecoration(
        color: yellowLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                iconImg,
                width: 24,
              ),
              const Spacer(),
              Text(count.toString(), style: buttonSmall),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: smallText.copyWith(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
