// ignore_for_file: must_be_immutable
import 'package:bloom/features/pomodoro/presentation/widgets/add_timer_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../../../injection_container.dart';
import '../bloc/pomodoro_scroll/pomodoro_bloc.dart';
import '../widgets/pomodoro_card.dart';

class PomodoroPage extends StatelessWidget {
  ItemScrollController scrollController = ItemScrollController();
  PomodoroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future _addTimerDialog() {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AddTimerDialog();
        },
      );
    }

    return BlocProvider(
      create: (context) => sl<PomodoroBloc>(),
      child: Scaffold(
        backgroundColor: naturalWhite,
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Container(
              padding: EdgeInsets.symmetric(horizontal: getWidth(24, context)),
              child: Text(
                "Pomodoro Timer",
                style: mainSubTitle,
              ),
            ),
            SizedBox(height: getHeight(21, context)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: getWidth(24, context)),
              child: Text(
                "My Timer",
                style: textParagraph.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(height: getHeight(8, context)),
            BlocBuilder<PomodoroBloc, PomodoroState>(builder: (context, state) {
              if (state is PomodoroInitial) {
                context.read<PomodoroBloc>().add(DisplayPomodoroEvent());
                return Container();
              } else if (state is DisplayPomodoroLoading) {
                return SizedBox(
                  height: getHeight(120, context),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  ),
                );
              } else if (state is DisplayPomodoroLoaded) {
                return SizedBox(
                  height: getHeight(120, context),
                  child: ScrollablePositionedList.builder(
                    itemCount: state.pomodoro.length,
                    itemScrollController: scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return PomodoroCard(
                        index: index,
                        indexPomodoro: state.pomodoro.keys.elementAt(index),
                        pomodoro: state.pomodoro.values.elementAt(index),
                        isLast: index == state.pomodoro.length - 1,
                      );
                    },
                  ),
                );
              } else if (state is DisplayPomodoroEmpty) {
                return SizedBox(
                  height: getHeight(120, context),
                  child: const Center(
                    child: Text(
                      'Timer empty',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox(
                  height: 120,
                  child: Center(
                    child: Text('Error'),
                  ),
                );
              }
            }),
            SizedBox(height: getHeight(32, context)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: getWidth(24, context)),
              child: Text(
                "Recent",
                style: textParagraph.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(height: getHeight(8, context)),
            // Obx(() {
            //   if (pomodoroController.recentList.isNotEmpty) {
            //     return Container(
            //       height: Get.height * 120 / 800,
            //       margin: EdgeInsets.symmetric(horizontal: Get.width * 24 / 360),
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 30,
            //         vertical: 19,
            //       ),
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(5),
            //         color: yellowLight,
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 pomodoroController.recentList[0].title,
            //                 style: textParagraph,
            //               ),
            //               Text(
            //                 "${pomodoroController.recentList[0].durationMinutes}:00",
            //                 style: mainTitle.copyWith(
            //                   fontSize: 40,
            //                 ),
            //               ),
            //             ],
            //           ),
            //           GestureDetector(
            //             onTap: () {
            //               Get.toNamed(
            //                 RouteName.TIMER,
            //                 arguments: pomodoroController.recentList[0],
            //               );
            //             },
            //             child: Container(
            //               width: 123,
            //               height: 34,
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(30),
            //                 color: naturalBlack,
            //               ),
            //               child: Center(
            //                 child: Text(
            //                   "Play",
            //                   style: buttonSmall.copyWith(
            //                     color: naturalWhite,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   } else {
            //     return SizedBox(
            //       height: Get.height * 120 / 800,
            //       child: const Center(
            //         child: Text(
            //           'Nothing opened recently',
            //           style: TextStyle(
            //             fontFamily: "Poppins",
            //             fontSize: 14,
            //           ),
            //         ),
            //       ),
            //     );
            //   }
            // }),
            SizedBox(height: getHeight(48, context)),
            GestureDetector(
              onTap: () => _addTimerDialog(),
              child: Container(
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: getWidth(85, context)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: naturalBlack,
                ),
                child: Center(
                  child: Text(
                    "Add Timer",
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
