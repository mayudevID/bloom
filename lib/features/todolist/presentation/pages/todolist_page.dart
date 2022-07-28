// ignore_for_file: must_be_immutable

import 'package:bloom/core/routes/route_name.dart';
import 'package:bloom/core/utils/function.dart';
import 'package:bloom/features/todolist/domain/todos_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/theme.dart';
import '../../../authentication/data/repositories/local_auth_repository.dart';
import '../../../habit/presentation/widgets/calendar_widget/calendar_widget.dart';
import '../../data/models/task_model.dart';
import '../../domain/todos_history_repository.dart';
import '../bloc/todos_overview/todos_overview_bloc.dart';
import '../widgets/task_widget.dart';

class ToDoListPage extends StatelessWidget {
  const ToDoListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosOverviewBloc(
        todosRepository: context.read<TodosRepository>(),
        todosHistoryRepository: context.read<TodosHistoryRepository>(),
        localUserDataRepository: context.read<LocalUserDataRepository>(),
      )..add(
          const TodosOverviewSubscriptionRequested(),
        ),
      child: ToDoListPageContent(),
    );
  }
}

class ToDoListPageContent extends StatelessWidget {
  ToDoListPageContent({Key? key}) : super(key: key);
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
              child: Text("To-Do List", style: mainSubTitle),
            ),
            SizedBox(height: getHeight(24, context)),
            CalendarWidget(
              initialDate: DateTime.now(),
              firstDate: DateTime(DateTime.now().year, 1, 1),
              lastDate: DateTime(DateTime.now().year, 12, 31),
              onDateSelected: (date) {
                context.read<TodosOverviewBloc>().add(
                      TodosOverviewFilterChanged(date ?? dateNow),
                    );
              },
              leftMargin: (MediaQuery.of(context).size.width / 2) - 20,
            ),
            SizedBox(height: getHeight(32, context)),
            Container(
              margin: const EdgeInsets.only(left: 24),
              child: Text(
                "My Task",
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
                      final deletedHabit = state.lastDeletedTodo!;
                      final messenger = ScaffoldMessenger.of(context);
                      messenger
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(
                              'To do list "${deletedHabit.title}" deleted',
                            ),
                            // action: SnackBarAction(
                            //   label: "Undo Delete",
                            //   textColor: redAction,
                            //   onPressed: () {
                            //     messenger.hideCurrentSnackBar();
                            //     context.read<TodosOverviewBloc>().add(
                            //         const TodosOverviewUndoDeletionRequested());
                            //   },
                            // ),
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
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                        );
                      } else if (state.status != TodosOverviewStatus.success) {
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
                      List<TaskModel> dataTask = taskByDateChooser(
                        state.todos,
                        state.filter as DateTime,
                      );
                      if (kDebugMode) {
                        print(dataTask);
                      }
                      if (dataTask.isNotEmpty) {
                        return MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              for (TaskModel taskModel in dataTask)
                                TaskWidget(
                                  taskModel: taskModel,
                                )
                            ],
                          ),
                        );
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
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: getHeight(40, context)),
            BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
              builder: (context, state) {
                if (dateNow.isBefore(state.filter as DateTime) ||
                    dateNow.isAtSameMomentAs(state.filter as DateTime)) {
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(RouteName.ADDTASK);
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
                            "Add new task",
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
