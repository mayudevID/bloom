import 'package:bloom/features/auth/presentation/bloc/app/app_bloc.dart';
import 'package:bloom/injection_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../habit/data/models/habit_model.dart';
import '../../habit/presentation/bloc/habits_overview_bloc.dart';
import '../../habit/presentation/widgets/habit_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc appBloc) => appBloc.state.user);

    return MultiBlocProvider(
      providers: [
        // BlocProvider(
        //   create: (context) => sl<TaskHomeBloc>()
        //     ..add(
        //       DisplayTaskHomeEvent(),
        //     ),
        // ),
        BlocProvider(
          create: (context) => sl<HabitsOverviewBloc>()
            ..add(
              const HabitsOverviewSubscriptionRequested(),
            ),
        ),
      ],
      child: Scaffold(
        backgroundColor: naturalWhite,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: getWidth(24, context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: BlocBuilder(builder: (context, state) {
                        return CachedNetworkImage(
                          imageUrl: user.photo as String,
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                          placeholder: (context, url) {
                            return const SizedBox(
                              width: 40.0,
                              height: 40.0,
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return const SizedBox(
                              width: 40.0,
                              height: 40.0,
                              child: Icon(Icons.error),
                            );
                          },
                        );
                      }),
                    ),
                    SizedBox(width: getWidth(6, context)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            greeting(),
                            style: smallText.copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            user.name as String,
                            style: smallTextLink,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //Get.toNamed(RouteName.SETTINGS);
                      },
                      child: Image.asset(
                        "assets/icons/settings.png",
                        width: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getWidth(16, context)),
                Text(
                  DateFormat('EEEE, dd MMMM y').format(DateTime.now()),
                  style: buttonSmall,
                ),
                SizedBox(height: getWidth(16, context)),
                Text(
                  'Upcoming Task',
                  style: smallTextLink,
                ),
                SizedBox(height: getHeight(7, context)),
                BlocBuilder<TaskHomeBloc, TaskHomeState>(
                    builder: (context, state) {
                  if (state is DisplayTaskHomeLoading) {
                    return const SizedBox(
                      height: 70,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      ),
                    );
                  } else if (state is DisplayTaskHomeLoaded) {
                    if (state.tasks.isEmpty) {
                      return const SizedBox(
                        height: 70,
                        child: Center(
                          child: Text(
                            'Task empty',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.tasks.length,
                          itemBuilder: (context, idx) {
                            return HabitsWidget(
                              habitModel: state.tasks.values.elementAt(idx),
                              index: state.tasks.keys.elementAt(idx),
                            );
                          },
                        ),
                      );
                    }
                  } else {
                    return const SizedBox(
                      height: 70,
                      child: Center(
                        child: Text('Error'),
                      ),
                    );
                  }
                }),
                SizedBox(height: getHeight(17, context)),
                Text("Todays Habits", style: smallTextLink),
                SizedBox(height: getHeight(8, context)),
                MultiBlocListener(
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
                          previous.lastDeletedHabit !=
                              current.lastDeletedHabit &&
                          current.lastDeletedHabit != null,
                      listener: (context, state) {
                        final deletedHabit = state.lastDeletedHabit!;
                        final messenger = ScaffoldMessenger.of(context);
                        messenger
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(
                                deletedHabit.title,
                              ),
                              action: SnackBarAction(
                                label: "Undo Delete",
                                onPressed: () {
                                  messenger.hideCurrentSnackBar();
                                  context.read<HabitsOverviewBloc>().add(
                                      const HabitsOverviewUndoDeletionRequested());
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
                                  color: Colors.black),
                            ),
                          );
                        } else if (state.status !=
                            HabitsOverviewStatus.success) {
                          return const SizedBox();
                        } else {
                          return SizedBox(
                            height: getHeight(70, context),
                            child: const Center(
                              child: Text(
                                'Task empty for this date',
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }
                      } else {
                        Map<int, HabitModel> dataHabit = habitByDateChooser(
                          state.habits,
                          state.filter as DateTime,
                        );
                        return MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dataHabit.length,
                            itemBuilder: (context, idx) {
                              return HabitWidget(
                                habitModel: dataHabit.values.elementAt(idx),
                                index: dataHabit.keys.elementAt(idx),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: getHeight(8, context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
