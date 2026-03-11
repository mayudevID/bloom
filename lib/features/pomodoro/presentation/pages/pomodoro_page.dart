// ignore_for_file: must_be_immutable
import '../../data/models/pomodoro_model.dart';
import '../../domain/pomodoros_repository.dart';
import '../widgets/add_timer_dialog.dart';
import '../widgets/pomodoro_recent_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../../core/utils/theme.dart';
import '../bloc/pomodoro_overview/pomodoros_overview_bloc.dart';
import '../bloc/pomodoro_recent/pomodoro_recent_bloc.dart';
import '../widgets/pomodoro_card.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PomodorosOverviewBloc(
            pomodorosRepository: context.read<PomodorosRepository>(),
          )..add(
              const PomodorosOverviewSubscriptionRequested(),
            ),
        ),
        BlocProvider(
          create: (context) => PomodoroRecentBloc(
            pomodorosRepository: context.read<PomodorosRepository>(),
          )..add(
              const PomodoroRecentSubscriptionRequested(),
            ),
        ),
      ],
      child: PomodoroPageContent(),
    );
  }
}

class PomodoroPageContent extends StatelessWidget {
  PomodoroPageContent({Key? key}) : super(key: key);
  ItemScrollController scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    Future addTimerDialog() {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AddTimerDialog();
        },
      );
    }

    return Scaffold(
      backgroundColor: naturalWhite,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Pomodoro Timer",
              style: mainSubTitle,
            ),
          ),
          const SizedBox(height: 21),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "My Timer",
              style: textParagraph.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          MultiBlocListener(
            listeners: [
              BlocListener<PomodorosOverviewBloc, PomodorosOverviewState>(
                listenWhen: (previous, current) =>
                    previous.status != current.status,
                listener: (context, state) {
                  if (state.status == PomodorosOverviewStatus.failure) {
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
              BlocListener<PomodorosOverviewBloc, PomodorosOverviewState>(
                listenWhen: (previous, current) =>
                    previous.lastDeletedPomodoro !=
                        current.lastDeletedPomodoro &&
                    current.lastDeletedPomodoro != null,
                listener: (context, state) {
                  final deletedPomodoro = state.lastDeletedPomodoro!;
                  final messenger = ScaffoldMessenger.of(context);
                  messenger
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          'Pomodoro "${deletedPomodoro.title}" deleted',
                        ),
                        // action: SnackBarAction(
                        //   label: "Undo Delete",
                        //   textColor: redAction,
                        //   onPressed: () {
                        //     messenger.hideCurrentSnackBar();
                        //     context.read<PomodorosOverviewBloc>().add(
                        //           const PomodorosOverviewUndoDeletionRequested(),
                        //         );
                        //   },
                        // ),
                      ),
                    );
                },
              ),
            ],
            child: BlocBuilder<PomodorosOverviewBloc, PomodorosOverviewState>(
              builder: (_, state) {
                if (state.pomodoros.isEmpty) {
                  if (state.status == PomodorosOverviewStatus.loading) {
                    return const SizedBox(
                      height: 120,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      ),
                    );
                  } else if (state.status != PomodorosOverviewStatus.success) {
                    return const SizedBox();
                  } else {
                    return const SizedBox(
                      height: 120,
                      child: Center(
                        child: Text(
                          'Timer empty',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return SizedBox(
                    height: 120,
                    child: ScrollablePositionedList.builder(
                      itemCount: state.pomodoros.length,
                      itemScrollController: scrollController,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      itemBuilder: (_, index) {
                        return pomodoroCard(
                          onTap: () async {
                            context.read<PomodorosOverviewBloc>().add(
                                  PomodorosOverviewPomodoroDeleted(
                                    state.pomodoros[index],
                                  ),
                                );
                            Navigator.of(context).pop();
                          },
                          context: context,
                          index: index,
                          pomodoro: state.pomodoros[index],
                          isLast: index == state.pomodoros.length - 1,
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Recent",
              style: textParagraph.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<PomodoroRecentBloc, PomodoroRecentState>(
            builder: (context, state) {
              if (state.status == PomodoroRecentStatus.success) {
                if (state.pomodoro == PomodoroModel.empty) {
                  return const SizedBox(
                    height: 120,
                    child: Center(
                      child: Text(
                        'Nothing opened recently',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                } else {
                  return PomodoroRecentWidget(pomodoroModel: state.pomodoro);
                }
              } else {
                return const SizedBox(
                  height: 120,
                  child: Center(
                    child: Text(
                      'Nothing opened recently',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 48),
          GestureDetector(
            onTap: () => addTimerDialog(),
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 85),
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
    );
  }
}
