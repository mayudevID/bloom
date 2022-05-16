import 'package:bloom/core/routes/route_name.dart';
import 'package:bloom/core/utils/function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/theme.dart';
import '../../../habit/presentation/widgets/calendar_widget/calendar_widget.dart';
import '../../data/models/task_model.dart';
import '../bloc/todos_overview/todos_overview_bloc.dart';
import '../task_widget.dart';

class ToDoListPage extends StatelessWidget {
  ToDoListPage({Key? key}) : super(key: key);
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
                print(date);
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
                              deletedHabit.title,
                            ),
                            action: SnackBarAction(
                              label: "Undo Delete",
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
                      Map<int, TaskModel> dataTask = taskByDateChooser(
                        state.todos,
                        state.filter as DateTime,
                      );
                      return MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: dataTask.length,
                          itemBuilder: (context, idx) {
                            return TaskWidget(
                              taskModel: dataTask.values.elementAt(idx),
                              index: dataTask.keys.elementAt(idx),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
              // child: FutureBuilder(
              //   future: taskBox,
              //   builder: (builder, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.done) {
              //       if (snapshot.hasError) {
              //         return Center(
              //           child: Text(snapshot.error.toString()),
              //         );
              //       } else {
              //         var taskDb = Hive.box('task_db');
              //         return ValueListenableBuilder(
              //           valueListenable: taskDb.listenable(),
              //           builder: (context, value, child) {
              //             if (taskDb.isEmpty) {
              //               return SizedBox(
              //                 height: Get.height * 70 / 800,
              //                 child: const Center(
              //                   child: Text(
              //                     'Task empty for this date',
              //                     style: TextStyle(
              //                       fontFamily: "Poppins",
              //                       fontSize: 14,
              //                     ),
              //                   ),
              //                 ),
              //               );
              //             } else {
              //               return GetBuilder<ToDoListController>(
              //                 builder: (_) {
              //                   Map<int, TaskModel?> dataTask =
              //                       taskByDateChooser(taskDb,
              //                           toDoListController.dateSelector);
              //                   if (dataTask.isEmpty) {
              //                     return SizedBox(
              //                       height: Get.height * 70 / 800,
              //                       child: const Center(
              //                         child: Text(
              //                           'Task empty for this date',
              //                           style: TextStyle(
              //                             fontFamily: "Poppins",
              //                             fontSize: 14,
              //                           ),
              //                         ),
              //                       ),
              //                     );
              //                   } else {
              //                     return MediaQuery.removePadding(
              //                       context: context,
              //                       removeTop: true,
              //                       child: ListView.builder(
              //                         physics:
              //                             const NeverScrollableScrollPhysics(),
              //                         shrinkWrap: true,
              //                         itemCount: dataTask.length,
              //                         itemBuilder: (context, idx) {
              //                           return TaskWidget(
              //                             taskModel:
              //                                 dataTask.values.elementAt(idx),
              //                             index: dataTask.keys.elementAt(idx),
              //                           );
              //                         },
              //                       ),
              //                     );
              //                   }
              //                 },
              //               );
              //             }
              //           },
              //         );
              //       }
              //     } else {
              //       return SizedBox(
              //         height: Get.height * 70 / 800,
              //         child: const Center(
              //           child: CircularProgressIndicator(color: Colors.black),
              //         ),
              //       );
              //     }
              //   },
              // ),
            ),
            SizedBox(height: getHeight(40, context)),
            BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
                builder: (context, state) {
              if (dateNow.isBefore(state.filter as DateTime) ||
                  dateNow.isAtSameMomentAs(state.filter as DateTime)) {
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.ADDHABIT);
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
            }),
          ],
        ),
      ),
    );
  }
}
