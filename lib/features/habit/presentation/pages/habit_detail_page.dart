import 'package:bloom/core/routes/route_name.dart';
import 'package:bloom/features/authentication/data/repositories/local_auth_repository.dart';
import 'package:bloom/features/habit/data/models/habit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../domain/habits_repository.dart';
import '../bloc/habit_detail/habit_detail_bloc.dart';
import '../widgets/day_streak_widget.dart';

class HabitsDetailPage extends StatelessWidget {
  const HabitsDetailPage({
    Key? key,
    required this.initHabitModel,
  }) : super(key: key);
  final HabitModel initHabitModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HabitDetailBloc(
        habitModel: initHabitModel,
        habitsRepository: context.read<HabitsRepository>(),
        localUserDataRepository: context.read<LocalUserDataRepository>(),
      ),
      child: HabitsDetailPageContent(initHabitModel: initHabitModel),
    );
  }
}

class HabitsDetailPageContent extends StatelessWidget {
  const HabitsDetailPageContent({
    Key? key,
    required this.initHabitModel,
  }) : super(key: key);
  final HabitModel initHabitModel;

  @override
  Widget build(BuildContext context) {
    final missedCurrent = context.select(
      (HabitDetailBloc bloc) => bloc.state.missed,
    );
    final streakCurrent = context.select(
      (HabitDetailBloc bloc) => bloc.state.streak,
    );
    final streakLeftCurrent = context.select(
      (HabitDetailBloc bloc) => bloc.state.streakLeft,
    );

    return Scaffold(
      backgroundColor: naturalWhite,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Image.asset(
                    "assets/icons/arrow_back.png",
                    width: 24,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    final goals = (initHabitModel.goals == "")
                        ? "No goals"
                        : initHabitModel.goals;
                    final openDaysVal = initHabitModel.openDays
                        .where((item) => item == true)
                        .length;
                    final total = (streakCurrent / openDaysVal) * 100;
                    Share.share('''
                      Habit: ${initHabitModel.title}\n
                      Goals: $goals\n\n
                      $openDaysVal of ${initHabitModel.durationDays}\n
                      Missed: $missedCurrent of $openDaysVal\n
                      Streak: $streakCurrent of $openDaysVal ($total%)\n
                      Streak Left: $streakLeftCurrent
                    ''');
                  },
                  child: Image.asset(
                    "assets/icons/share.png",
                    width: 24,
                  ),
                ),
                SizedBox(width: getWidth(16, context)),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop(true);
                  },
                  child: Image.asset(
                    "assets/icons/delete.png",
                    width: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight(32, context)),
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: yellowDark),
                    color: const Color(0xffFCF7D3),
                  ),
                  // Done
                  child: Image.asset(
                    initHabitModel.iconImg,
                    width: 32,
                    scale: 3,
                  ),
                ),
                SizedBox(width: getWidth(8, context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(initHabitModel.title, style: buttonLarge),
                      Text(
                        todToString(
                          TimeOfDay.fromDateTime(initHabitModel.timeOfDay),
                        ),
                        style: textForm,
                      ),
                    ],
                  ),
                ),
                BlocBuilder<HabitDetailBloc, HabitDetailState>(
                  builder: (context, state) {
                    int count =
                        state.checkedDays.where((item) => item == true).length;
                    return Text(
                      "$count/${initHabitModel.durationDays}",
                      style: textForm,
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: getHeight(24, context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Progress",
                  style: smallText.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  "View Statistic",
                  style: smallText.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight(4, context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<HabitDetailBloc, HabitDetailState>(
                      builder: (context, state) {
                        return Text(
                          state.missed.toString(),
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                    Text(
                      "Missed",
                      style: smallTextLink.copyWith(fontSize: 10),
                    ),
                  ],
                ),
                SizedBox(width: getWidth(24, context)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<HabitDetailBloc, HabitDetailState>(
                      builder: (context, state) {
                        return Text(
                          state.streak.toString(),
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                    Text(
                      "Streak",
                      style: smallTextLink.copyWith(fontSize: 10),
                    ),
                  ],
                ),
                SizedBox(width: getWidth(24, context)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<HabitDetailBloc, HabitDetailState>(
                      builder: (context, state) {
                        return Text(
                          state.streakLeft.toString(),
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                    Text(
                      "Streak Left",
                      style: smallTextLink.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: getHeight(24, context)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Daily Streak",
                style: smallText.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(height: getHeight(8, context)),
            SizedBox(
              height: 311,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  itemCount: initHabitModel.durationDays,
                  itemBuilder: (context, idx) {
                    return DayStreakWidget(
                      dayIndex: idx,
                      initHabitModel: initHabitModel,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: getHeight(56, context)),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  RouteName.EDITHABIT,
                  arguments: initHabitModel,
                );
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
                    "Edit",
                    style: buttonSmall.copyWith(
                      color: naturalWhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
