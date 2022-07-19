import 'package:bloom/core/utils/notifications.dart';
import 'package:bloom/features/authentication/data/repositories/local_auth_repository.dart';
import 'package:bloom/features/pomodoro/data/models/pomodoro_model.dart';
import 'package:bloom/features/pomodoro/presentation/bloc/timer/timer_bloc.dart';
import 'package:bloom/features/pomodoro/presentation/widgets/timer_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../bloc/timer/ticker.dart';
import '../widgets/exit_dialog.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({
    Key? key,
    required this.initPomodoroModel,
  }) : super(key: key);
  final PomodoroModel initPomodoroModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerBloc(
        ticker: const Ticker(),
        localUserDataRepository: context.read<LocalUserDataRepository>(),
      )..add(TimerSet(initPomodoroModel)),
      child: TimerPageContent(pModel: initPomodoroModel),
    );
  }
}

class TimerPageContent extends StatelessWidget {
  const TimerPageContent({
    Key? key,
    required this.pModel,
  }) : super(key: key);
  final PomodoroModel pModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellowLight,
      body: BlocListener<TimerBloc, TimerState>(
        listener: (context, state) {
          if (state is TimerRunComplete) {
            createTimerNotification(pModel, state.session);
            if (state.isCompleted && state.session == pModel.session) {
              context.read<TimerBloc>().add(const SetUserData());
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              BackMenu(data: pModel),
              SizedBox(height: getHeight(16, context)),
              Center(child: Text(pModel.title, style: mainSubTitle)),
              SizedBox(height: getHeight(4, context)),
              Center(
                child: SessionDisplay(data: pModel),
              ),
              SizedBox(height: getHeight(48, context)),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 293,
                      height: 293,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: yellowDark,
                      ),
                    ),
                    TimerCircle(earlyTime: pModel.durationMinutes),
                    Positioned(
                      left: 293 / 2 - 6,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: naturalWhite,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 2),
                              blurRadius: 7,
                              color: Colors.black.withOpacity(0.25),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: getHeight(40, context)),
              Center(
                child: BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      if (state is TimerInitial) {
                        context.read<TimerBloc>().add(
                              TimerStarted(
                                state.duration,
                                state.session,
                              ),
                            );
                      } else if (state is TimerRunInProgress) {
                        context.read<TimerBloc>().add(const TimerPaused());
                      } else if (state is TimerRunPause) {
                        context.read<TimerBloc>().add(const TimerResumed());
                      } else if (state is TimerRunComplete) {
                        if (state.isCompleted &&
                            state.session < pModel.session) {
                          context.read<TimerBloc>().add(TimerSet(pModel));
                        }
                      }
                    },
                    child: Container(
                      width: (state.isCompleted) ? 120 : 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: (state.isCompleted &&
                                state.session == pModel.session)
                            ? yellowLight
                            : naturalBlack,
                      ),
                      child: Center(
                        child: state.isRunning
                            ? Image.asset(
                                "assets/icons/pause.png",
                                width: 32,
                              )
                            : (state.isCompleted &&
                                    state.session < pModel.session)
                                ? Text(
                                    "Start Next Session",
                                    style: buttonSmall.copyWith(
                                      color: naturalWhite,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                : (state.isCompleted &&
                                        state.session == pModel.session)
                                    ? Text(
                                        "Finish",
                                        style: buttonLarge.copyWith(
                                          color: naturalBlack,
                                        ),
                                      )
                                    : (state is LoadingState)
                                        ? Container()
                                        : Image.asset(
                                            "assets/icons/play.png",
                                            width: 32,
                                          ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BackMenu extends StatelessWidget {
  final PomodoroModel data;
  const BackMenu({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCompleted =
        context.select((TimerBloc bloc) => bloc.state.isCompleted);
    final session = context.select((TimerBloc bloc) => bloc.state.session);

    Future exitDialog() {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const ExitDialog();
        },
      );
    }

    return GestureDetector(
      onTap: () {
        if (isCompleted && session == data.session) {
          Navigator.of(context).pop();
        } else {
          exitDialog();
        }
      },
      child: Image.asset("assets/icons/arrow_back.png", width: 24),
    );
  }
}

class SessionDisplay extends StatelessWidget {
  final PomodoroModel data;
  const SessionDisplay({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final session = context.select((TimerBloc bloc) => bloc.state.session);
    return Text(
      '$session of ${data.session} sessions',
      style: textParagraph,
    );
  }
}
