import 'package:bloom/features/habit/domain/habits_repository.dart';
import 'package:bloom/features/home/bloc/user/user_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../authentication/data/repositories/local_auth_repository.dart';
import '../../habit/data/models/habit_model.dart';
import '../../habit/presentation/bloc/habit_overview/habits_overview_bloc.dart';
import '../../habit/presentation/widgets/habit_widget.dart';
import '../../todolist/data/models/task_model.dart';
import '../../todolist/domain/todos_repository.dart';
import '../../todolist/presentation/bloc/todos_overview/todos_overview_bloc.dart';
import '../../todolist/presentation/widgets/task_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodosOverviewBloc(
            todosRepository: context.read<TodosRepository>(),
          )..add(
              const TodosOverviewSubscriptionRequested(),
            ),
        ),
        BlocProvider(
          create: (context) => HabitsOverviewBloc(
            habitsRepository: context.read<HabitsRepository>(),
          )..add(
              const HabitsOverviewSubscriptionRequested(),
            ),
        ),
        BlocProvider(
          create: (context) => UserBloc(
            localUserDataRepository: context.read<LocalUserDataRepository>(),
          )..add(
              const UserRequested(),
            ),
        ),
      ],
      child: const HomePageContent(),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state.status == UserStatus.success) {
                          return CachedNetworkImage(
                            imageUrl: state.userData.photoURL.toString(),
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
                        } else {
                          return const SizedBox(
                            width: 40.0,
                            height: 40.0,
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
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
                        BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            if (state.status == UserStatus.success) {
                              return Text(
                                state.userData.name.toString(),
                                style: smallTextLink,
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
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
              MultiBlocListener(
                listeners: [
                  BlocListener<TodosOverviewBloc, TodosOverviewState>(
                    listenWhen: (previous, current) =>
                        previous.status != current.status,
                    listener: (context, state) {
                      if (state.status == TodosOverviewStatus.failure) {
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
                  BlocListener<TodosOverviewBloc, TodosOverviewState>(
                    listenWhen: (previous, current) =>
                        previous.lastDeletedTodo != current.lastDeletedTodo &&
                        current.lastDeletedTodo != null,
                    listener: (context, state) {
                      final deletedTodo = state.lastDeletedTodo!;
                      final messenger = ScaffoldMessenger.of(context);
                      messenger
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(
                              deletedTodo.title,
                            ),
                            action: SnackBarAction(
                              label: "Undo Delete",
                              textColor: redAction,
                              onPressed: () {
                                messenger.hideCurrentSnackBar();
                                context.read<TodosOverviewBloc>().add(
                                    const TodosOverviewUndoDeletionRequested());
                              },
                            ),
                          ),
                        );
                    },
                  ),
                ],
                child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
                  builder: (context, state) {
                    if (state.todos.isEmpty) {
                      if (state.status == TodosOverviewStatus.loading) {
                        return SizedBox(
                          height: getHeight(70, context),
                          child: const Center(
                            child:
                                CircularProgressIndicator(color: Colors.black),
                          ),
                        );
                      } else if (state.status != TodosOverviewStatus.success) {
                        return const SizedBox();
                      } else {
                        return SizedBox(
                          height: getHeight(70, context),
                          child: const Center(
                            child: Text(
                              'Task empty for now',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      List<TaskModel> dataTask = taskByDateChooser(
                        state.todos,
                        state.filter as DateTime,
                      );
                      return MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            for (final taskModel in dataTask)
                              TaskWidget(
                                taskModel: taskModel,
                              )
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
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
                              deletedHabit.title,
                            ),
                            action: SnackBarAction(
                              label: "Undo Delete",
                              textColor: redAction,
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
                            child:
                                CircularProgressIndicator(color: Colors.black),
                          ),
                        );
                      } else if (state.status != HabitsOverviewStatus.success) {
                        return const SizedBox();
                      } else {
                        return SizedBox(
                          height: getHeight(70, context),
                          child: const Center(
                            child: Text(
                              'Habits empty for this date',
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
                      return MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            for (final habitModel in dataHabit)
                              HabitWidget(
                                habitModel: habitModel,
                              )
                          ],
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
    );
  }
}
