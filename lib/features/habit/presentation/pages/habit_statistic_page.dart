// ignore_for_file: must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../../authentication/data/repositories/local_auth_repository.dart';
import '../bloc/habit_statistic/habit_statistic_bloc.dart';
import '../widgets/habit_statistic_widget.dart';

class HabitStatisticPage extends StatelessWidget {
  const HabitStatisticPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HabitStatisticBloc(
        localUserDataRepository: context.read<LocalUserDataRepository>(),
      )..add(
          const GetAllStatistic(),
        ),
      child: HabitStatisticPageContent(),
    );
  }
}

class HabitStatisticPageContent extends StatelessWidget {
  HabitStatisticPageContent({Key? key}) : super(key: key);

  final dayCount = getNumberOfDays();
  final subtractTwelveDaysAgo = getSubtractTwelveDaysAgo();

  @override
  Widget build(BuildContext context) {
    LinearWidgetPointer linearWidget(index) {
      if (kDebugMode) {
        print(index);
      }
      return LinearWidgetPointer(
        position: LinearElementPosition.outside,
        value: index.toDouble(),
        child: Container(
          height: getHeight((index == 11) ? 120 : 183, context),
          width: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: naturalBlack,
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: naturalWhite,
        body: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image.asset(
                      "assets/icons/arrow_back.png",
                      width: 24,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.5 - 48 - 56.5,
                    ),
                    child: Text(
                      "Statistics",
                      style: mainSubTitle,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: getHeight(40, context)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: greyDark,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 39,
                    child: TabBar(
                      indicatorColor: naturalBlack,
                      indicatorWeight: 3,
                      tabs: [
                        Text(
                          "Overall",
                          style: textParagraph.copyWith(
                            fontWeight: FontWeight.w700,
                            color: naturalBlack,
                          ),
                        ),
                        Text(
                          "By Habit",
                          style: textParagraph.copyWith(
                            fontWeight: FontWeight.w700,
                            color: naturalBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: getHeight(32, context)),
            Expanded(
              child: TabBarView(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Progress",
                          style: textParagraph.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: getHeight(10, context)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: BlocBuilder<HabitStatisticBloc,
                            HabitStatisticState>(
                          builder: (context, state) {
                            if (state is HabitStatisticLoaded) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  HabitStatisticWidget(
                                    iconImg: 'assets/icons/dismiss.png',
                                    title: 'Missed',
                                    count: state.data.missed,
                                  ),
                                  HabitStatisticWidget(
                                    iconImg: 'assets/icons/checkmark.png',
                                    title: 'Completed',
                                    count: state.data.completed,
                                  ),
                                  HabitStatisticWidget(
                                    iconImg: 'assets/icons/streakleft.png',
                                    title: 'Streak Left',
                                    count: state.data.streakLeft,
                                  ),
                                ],
                              );
                            } else if (state is HabitStatisticInitial) {
                              return const SizedBox(
                                height: 70,
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.black),
                                ),
                              );
                            } else {
                              return const SizedBox(
                                height: 70,
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.black),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: getHeight(40, context)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Average Performances",
                          style: textParagraph.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: getHeight(16, context)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 183,
                                  child: SfLinearGauge(
                                    minimum: 0,
                                    maximum: 100,
                                    interval: 20,
                                    showTicks: false,
                                    showAxisTrack: false,
                                    orientation:
                                        LinearGaugeOrientation.vertical,
                                    axisTrackStyle: const LinearAxisTrackStyle(
                                      color: Colors.transparent,
                                    ),
                                    axisLabelStyle: smallText.copyWith(
                                      color: naturalBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: getHeight(25, context),
                                ),
                              ],
                            ),
                            SfLinearGauge(
                              minimum: subtractTwelveDaysAgo,
                              maximum: subtractTwelveDaysAgo + 11,
                              interval: 1,
                              showTicks: false,
                              labelFormatterCallback: (String val) {
                                int? date = int.tryParse(val);
                                int valueReturn = date! % dayCount;
                                if (valueReturn == 0) {
                                  return date.toString();
                                } else {
                                  return valueReturn.toString();
                                }
                              },
                              axisTrackStyle: const LinearAxisTrackStyle(
                                color: Colors.transparent,
                              ),
                              axisLabelStyle: smallText.copyWith(
                                color: naturalBlack,
                              ),
                              markerPointers:
                                  List<LinearWidgetPointer>.generate(
                                12,
                                (index) {
                                  int date = subtractTwelveDaysAgo.toInt();
                                  return linearWidget(date + index);
                                },
                                growable: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
