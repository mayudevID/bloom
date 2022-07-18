// ignore_for_file: must_be_immutable

import 'package:bloom/core/routes/route_name.dart';
import 'package:bloom/features/habit/data/models/habit_model.dart';
import 'package:bloom/features/habit/domain/habits_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../bloc/habit_overview/habits_overview_bloc.dart';
import '../widgets/calendar_widget/calendar_widget.dart';
import '../widgets/habit_widget.dart';

class HabitTrackerPage extends StatelessWidget {
  const HabitTrackerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HabitsOverviewBloc(
        habitsRepository: context.read<HabitsRepository>(),
      )..add(
          const HabitsOverviewSubscriptionRequested(),
        ),
      child: HabitTrackerPageContent(),
    );
  }
}

class HabitTrackerPageContent extends StatelessWidget {
  HabitTrackerPageContent({Key? key}) : super(key: key);
  DateTime dateNow = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: naturalWhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text("Habit Tracker", style: mainSubTitle),
            ),
            SizedBox(height: getHeight(24, context)),
            CalendarWidget(
              initialDate: DateTime.now(),
              firstDate: DateTime(DateTime.now().year, 1, 1),
              lastDate: DateTime(DateTime.now().year, 12, 31),
              onDateSelected: (date) {
                context.read<HabitsOverviewBloc>().add(
                      HabitsOverviewFilterChanged(date ?? dateNow),
                    );
              },
              leftMargin: (MediaQuery.of(context).size.width / 2) - 20,
            ),
            SizedBox(height: getHeight(32, context)),
            Container(
              margin: const EdgeInsets.only(left: 24),
              child: Text(
                "My Tracker",
                style: textParagraph.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: getHeight(8, context)),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: MultiBlocListener(
                listeners: [
                  BlocListener<HabitsOverviewBloc, HabitsOverviewState>(
                    listenWhen: (previous, current) =>
                        previous.status != current.status,
                    listener: (context, state) {
                      if (state.status == HabitsOverviewStatus.failure) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text("Error"),
                            ),
                          );
                      }
                    },
                  ),
                  BlocListener<HabitsOverviewBloc, HabitsOverviewState>(
                    listenWhen: (previous, current) =>
                        previous.lastDeletedHabit != current.lastDeletedHabit &&
                        current.lastDeletedHabit != null,
                    listener: (context, state) {
                      final deletedHabit = state.lastDeletedHabit!;
                      final messenger = ScaffoldMessenger.of(context);
                      messenger
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(
                              'Habit "${deletedHabit.title}" deleted',
                            ),
                            action: SnackBarAction(
                              label: "Undo Delete",
                              textColor: redAction,
                              onPressed: () {
                                messenger.hideCurrentSnackBar();
                                context.read<HabitsOverviewBloc>().add(
                                      const HabitsOverviewUndoDeletionRequested(),
                                    );
                              },
                            ),
                          ),
                        );
                    },
                  ),
                ],
                child: BlocBuilder<HabitsOverviewBloc, HabitsOverviewState>(
                  builder: (context, state) {
                    if (state.habits.isEmpty) {
                      if (state.status == HabitsOverviewStatus.loading) {
                        return SizedBox(
                          height: getHeight(70, context),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                        );
                      } else if (state.status != HabitsOverviewStatus.success) {
                        return const SizedBox();
                      } else {
                        return SizedBox(
                          height: getHeight(70, context),
                          child: const Center(
                            child: Text(
                              'Habit empty for this date',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      List<HabitModel> dataHabit = habitByDateChooser(
                        state.habits,
                        state.filter as DateTime,
                      );
                      print(dataHabit);
                      if (dataHabit.isNotEmpty) {
                        return MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              for (HabitModel habitModel in dataHabit)
                                HabitWidget(
                                  habitModel: habitModel,
                                )
                            ],
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: getHeight(70, context),
                          child: const Center(
                            child: Text(
                              'Habit empty for this date',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: getHeight(40, context)),
            BlocBuilder<HabitsOverviewBloc, HabitsOverviewState>(
              builder: (context, state) {
                if (dateNow.isBefore(state.filter as DateTime) ||
                    dateNow.isAtSameMomentAs(state.filter as DateTime)) {
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(RouteName.ADDHABIT);
                      },
                      child: Container(
                        height: 40,
                        width: 203,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: naturalBlack,
                        ),
                        child: Center(
                          child: Text(
                            "Add Habit",
                            style: buttonSmall.copyWith(
                              color: naturalWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
