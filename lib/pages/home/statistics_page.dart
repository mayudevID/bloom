import 'package:bloom/theme.dart';
import 'package:bloom/utils.dart';
import 'package:bloom/widgets/statistics_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../controllers/user_local_db.dart';
import '../../models/user.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LinearWidgetPointer linearWidget(index) {
      return LinearWidgetPointer(
        value: index.toDouble(),
        child: Container(
          height: 183,
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
            SizedBox(height: Get.height * 0.07),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      "assets/icons/arrow_back.png",
                      width: 24,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: Get.width * 0.5 - 48 - 56.5,
                    ),
                    child: Text(
                      "Statistics",
                      style: mainSubTitle,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: getHeight(40)),
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
            SizedBox(height: getHeight(32)),
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
                      SizedBox(height: getHeight(10)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: FutureBuilder(
                          future: Hive.openBox('user_data'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              } else {
                                var userData = Hive.box('user_data');
                                UserModel userModel = userData.get('user');
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    StatisticsWidget(
                                      iconImg: 'assets/icons/dismiss.png',
                                      title: 'Missed',
                                      count: userModel.missed,
                                    ),
                                    StatisticsWidget(
                                      iconImg: 'assets/icons/checkmark.png',
                                      title: 'Completed',
                                      count: userModel.completed,
                                    ),
                                    StatisticsWidget(
                                      iconImg: 'assets/icons/streakleft.png',
                                      title: 'Streak Left',
                                      count: userModel.streakLeft,
                                    ),
                                  ],
                                );
                              }
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
                      SizedBox(height: getHeight(40)),
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
                      SizedBox(height: getHeight(16)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 183,
                              child: SfLinearGauge(
                                minimum: 0,
                                maximum: 100,
                                interval: 20,
                                showTicks: false,
                                showAxisTrack: false,
                                orientation: LinearGaugeOrientation.vertical,
                                axisTrackStyle: const LinearAxisTrackStyle(
                                  color: Colors.transparent,
                                ),
                                axisLabelStyle: smallText.copyWith(
                                  color: naturalBlack,
                                ),
                              ),
                            ),
                            SfLinearGauge(
                              minimum: 1,
                              maximum: 12,
                              interval: 1,
                              showTicks: false,
                              axisTrackStyle: const LinearAxisTrackStyle(
                                color: Colors.transparent,
                              ),
                              axisLabelStyle: smallText.copyWith(
                                color: naturalBlack,
                              ),
                              labelOffset: 100,
                              markerPointers:
                                  List<LinearWidgetPointer>.generate(
                                15,
                                (index) => linearWidget(index),
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
