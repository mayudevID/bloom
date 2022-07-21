import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../bloc/timer/timer_bloc.dart';

class TimerCircle extends StatelessWidget {
  final int earlyTime;
  const TimerCircle({Key? key, required this.earlyTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr =
        ((duration / 1000 / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr =
        (duration / 1000 % 60).floor().toString().padLeft(2, '0');
    return CircularPercentIndicator(
      radius: 293 / 2,
      lineWidth: 12,
      backgroundColor: yellowDark,
      percent: duration / (earlyTime * 60 * 1000),
      reverse: true,
      center: SizedBox(
        child: Text(
          "$minutesStr:$secondsStr",
          style: mainTitle.copyWith(
            fontSize: 56,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: naturalBlack,
    );
  }
}
