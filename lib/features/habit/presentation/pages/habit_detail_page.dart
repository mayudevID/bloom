import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloom/features/habit/data/models/habit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../domain/repositories/habit_repository.dart';
import '../bloc/habit_detail/habit_detail_bloc.dart';

class HabitsDetailPage extends StatelessWidget {
  const HabitsDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as HabitModel;

    return BlocProvider(
      create: (context) => HabitDetailBloc(
        habitModel: data,
        habitsRepository: context.read<HabitsRepository>(),
      ),
      child: Scaffold(
        backgroundColor: naturalWhite,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(result: false),
                    child: Image.asset(
                      "assets/icons/arrow_back.png",
                      width: 24,
                    ),
                  ),
                  const Spacer(),
                  Image.asset("assets/icons/share.png", width: 24),
                  SizedBox(width: getWidth(16, context)),
                  GestureDetector(
                    onTap: () async {
                      // HabitsModel habitTarget = habitDb.getAt(modelIndex);
                      // for (var i = 0; i < habitTarget.dayList.length; i++) {
                      //   AwesomeNotifications()
                      //       .cancel(habitTarget.habitId * habitTarget.dayList[i]);
                      // }
                      Navigator.pop(context, true);
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
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: yellowDark),
                      color: const Color(0xffFCF7D3),
                    ),
                    child: Image.asset(
                      data.iconImg,
                      width: 32,
                      scale: 3,
                    ),
                    // child: ValueListenableBuilder(
                    //   valueListenable: habitDb.listenable(),
                    //   builder: (context, box, _) {
                    //     HabitsModel habitModel = habitDb.getAt(modelIndex);
                    //     return Image.asset(
                    //       habitModel.iconImg,
                    //       width: 32,
                    //       scale: 3,
                    //     );
                    //   },
                    // ),
                  ),
                  SizedBox(width: getWidth(8, context)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.title, style: buttonLarge),
                        Text(
                          "Every day, ${todToString(TimeOfDay.fromDateTime(data.timeOfDay))}",
                          style: textForm,
                        ),
                      ],
                    ),
                    // child: ValueListenableBuilder(
                    //   valueListenable: habitDb.listenable(),
                    //   builder: (context, box, _) {
                    //     HabitsModel habitModel = habitDb.getAt(modelIndex);
                    //     return Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(habitModel.title, style: buttonLarge),
                    //         Text(
                    //           "Every day, ${todToString(habitModel.timeOfDay)}",
                    //           style: textForm,
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // ),
                  ),
                  BlocBuilder(builder: builder)
                  // ValueListenableBuilder(
                  //   valueListenable: habitDb.listenable(),
                  //   builder: (context, box, _) {
                  //     HabitsModel habitModel = habitDb.getAt(modelIndex);
                  //     int count = habitModel.checkedDays
                  //         .where((item) => item == true)
                  //         .length;
                  //     return Text(
                  //       "/${habitModel.durationDays}",
                  //       style: textForm,
                  //     );
                  //   },
                  // ),
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
              SizedBox(height: getHeight(4)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: habitDb.listenable(),
                        builder: (context, box, _) {
                          HabitsModel test = habitDb.getAt(modelIndex);
                          return Text(
                            test.missed.toString(),
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
                  SizedBox(width: getWidth(24)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: habitDb.listenable(),
                        builder: (context, box, _) {
                          HabitsModel habitModel = habitDb.getAt(modelIndex);
                          return Text(
                            habitModel.streak.toString(),
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
                  SizedBox(width: getWidth(24)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: habitDb.listenable(),
                        builder: (context, box, _) {
                          HabitsModel habitModel = habitDb.getAt(modelIndex);
                          return Text(
                            habitModel.streakLeft.toString(),
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
              SizedBox(height: getHeight(24)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Daily Streak",
                  style: smallText.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: getHeight(8)),
              SizedBox(
                height: 311,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ValueListenableBuilder(
                    valueListenable: habitDb.listenable(),
                    builder: (context, box, _) {
                      HabitsModel habitModel = habitDb.getAt(modelIndex);
                      return ListView.builder(
                        itemCount: habitModel.durationDays,
                        itemBuilder: (context, idx) {
                          return DayStreakWidget(
                            dayIndex: idx,
                            modelIndex: modelIndex,
                            habitModel: habitModel,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: getHeight(56)),
              GestureDetector(
                onTap: () {},
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
          // child: FutureBuilder(
          //   future: Hive.openBox("habit_db"),
          //   builder: (builder, snapshot) {
          //     if (snapshot.hasData) {
          //       var habitDb = Hive.box("habit_db");
          //       //HabitsModel habitTarget = habitDb.getAt(modelIndex);
          //       return Column(
          //         children: [
          //           SizedBox(height: MediaQuery.of(context).size.height * 0.07),
          //           Row(
          //             children: [
          //               GestureDetector(
          //                 onTap: () => Get.back(result: false),
          //                 child: Image.asset(
          //                   "assets/icons/arrow_back.png",
          //                   width: 24,
          //                 ),
          //               ),
          //               const Spacer(),
          //               Image.asset("assets/icons/share.png", width: 24),
          //               SizedBox(width: getWidth(16, context)),
          //               GestureDetector(
          //                 onTap: () async {
          //                   HabitsModel habitTarget = habitDb.getAt(modelIndex);
          //                   for (var i = 0; i < habitTarget.dayList.length; i++) {
          //                     AwesomeNotifications().cancel(
          //                         habitTarget.habitId * habitTarget.dayList[i]);
          //                   }
          //                   Navigator.pop(context, true);
          //                 },
          //                 child: Image.asset(
          //                   "assets/icons/delete.png",
          //                   width: 24,
          //                 ),
          //               ),
          //             ],
          //           ),
          //           SizedBox(height: getHeight(32, context)),
          //           Row(
          //             // crossAxisAlignment: CrossAxisAlignment.center,
          //             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Container(
          //                 width: 64,
          //                 height: 64,
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(5),
          //                   border: Border.all(color: yellowDark),
          //                   color: const Color(0xffFCF7D3),
          //                 ),
          //                 child: ValueListenableBuilder(
          //                   valueListenable: habitDb.listenable(),
          //                   builder: (context, box, _) {
          //                     HabitsModel habitModel = habitDb.getAt(modelIndex);
          //                     return Image.asset(
          //                       habitModel.iconImg,
          //                       width: 32,
          //                       scale: 3,
          //                     );
          //                   },
          //                 ),
          //               ),
          //               SizedBox(width: getWidth(8)),
          //               Expanded(
          //                 child: ValueListenableBuilder(
          //                   valueListenable: habitDb.listenable(),
          //                   builder: (context, box, _) {
          //                     HabitsModel habitModel = habitDb.getAt(modelIndex);
          //                     return Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text(habitModel.title, style: buttonLarge),
          //                         Text(
          //                           "Every day, ${todToString(habitModel.timeOfDay)}",
          //                           style: textForm,
          //                         ),
          //                       ],
          //                     );
          //                   },
          //                 ),
          //               ),
          //               ValueListenableBuilder(
          //                 valueListenable: habitDb.listenable(),
          //                 builder: (context, box, _) {
          //                   HabitsModel habitModel = habitDb.getAt(modelIndex);
          //                   int count = habitModel.checkedDays
          //                       .where((item) => item == true)
          //                       .length;
          //                   return Text(
          //                     "/${habitModel.durationDays}",
          //                     style: textForm,
          //                   );
          //                 },
          //               ),
          //             ],
          //           ),
          //           SizedBox(height: getHeight(24)),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 "Progress",
          //                 style: smallText.copyWith(fontWeight: FontWeight.w700),
          //               ),
          //               Text(
          //                 "View Statistic",
          //                 style: smallText.copyWith(
          //                   fontWeight: FontWeight.w400,
          //                   fontSize: 8,
          //                 ),
          //               ),
          //             ],
          //           ),
          //           SizedBox(height: getHeight(4)),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               Column(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   ValueListenableBuilder(
          //                     valueListenable: habitDb.listenable(),
          //                     builder: (context, box, _) {
          //                       HabitsModel test = habitDb.getAt(modelIndex);
          //                       return Text(
          //                         test.missed.toString(),
          //                         style: const TextStyle(
          //                           fontFamily: "Poppins",
          //                           fontSize: 24,
          //                           fontWeight: FontWeight.w700,
          //                         ),
          //                       );
          //                     },
          //                   ),
          //                   Text(
          //                     "Missed",
          //                     style: smallTextLink.copyWith(fontSize: 10),
          //                   ),
          //                 ],
          //               ),
          //               SizedBox(width: getWidth(24)),
          //               Column(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   ValueListenableBuilder(
          //                     valueListenable: habitDb.listenable(),
          //                     builder: (context, box, _) {
          //                       HabitsModel habitModel =
          //                           habitDb.getAt(modelIndex);
          //                       return Text(
          //                         habitModel.streak.toString(),
          //                         style: const TextStyle(
          //                           fontFamily: "Poppins",
          //                           fontSize: 24,
          //                           fontWeight: FontWeight.w700,
          //                         ),
          //                       );
          //                     },
          //                   ),
          //                   Text(
          //                     "Streak",
          //                     style: smallTextLink.copyWith(fontSize: 10),
          //                   ),
          //                 ],
          //               ),
          //               SizedBox(width: getWidth(24)),
          //               Column(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   ValueListenableBuilder(
          //                     valueListenable: habitDb.listenable(),
          //                     builder: (context, box, _) {
          //                       HabitsModel habitModel =
          //                           habitDb.getAt(modelIndex);
          //                       return Text(
          //                         habitModel.streakLeft.toString(),
          //                         style: const TextStyle(
          //                           fontFamily: "Poppins",
          //                           fontSize: 24,
          //                           fontWeight: FontWeight.w700,
          //                         ),
          //                       );
          //                     },
          //                   ),
          //                   Text(
          //                     "Streak Left",
          //                     style: smallTextLink.copyWith(fontSize: 10),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //           SizedBox(height: getHeight(24)),
          //           Align(
          //             alignment: Alignment.centerLeft,
          //             child: Text(
          //               "Daily Streak",
          //               style: smallText.copyWith(fontWeight: FontWeight.w700),
          //             ),
          //           ),
          //           SizedBox(height: getHeight(8)),
          //           SizedBox(
          //             height: 311,
          //             child: MediaQuery.removePadding(
          //               context: context,
          //               removeTop: true,
          //               child: ValueListenableBuilder(
          //                 valueListenable: habitDb.listenable(),
          //                 builder: (context, box, _) {
          //                   HabitsModel habitModel = habitDb.getAt(modelIndex);
          //                   return ListView.builder(
          //                     itemCount: habitModel.durationDays,
          //                     itemBuilder: (context, idx) {
          //                       return DayStreakWidget(
          //                         dayIndex: idx,
          //                         modelIndex: modelIndex,
          //                         habitModel: habitModel,
          //                       );
          //                     },
          //                   );
          //                 },
          //               ),
          //             ),
          //           ),
          //           SizedBox(height: getHeight(56)),
          //           GestureDetector(
          //             onTap: () {},
          //             child: Container(
          //               width: 202,
          //               height: 40,
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(10),
          //                 color: naturalBlack,
          //               ),
          //               child: Center(
          //                 child: Text(
          //                   "Edit",
          //                   style: buttonSmall.copyWith(
          //                     color: naturalWhite,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       );
          //     } else {
          //       return const Center(
          //         child: SizedBox(
          //           width: 50,
          //           height: 50,
          //           child: CircularProgressIndicator(),
          //         ),
          //       );
          //     }
          //   },
          // ),
        ),
      ),
    );
  }
}
