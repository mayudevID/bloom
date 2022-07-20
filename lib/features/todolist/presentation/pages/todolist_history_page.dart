import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../domain/todos_history_repository.dart';
import '../bloc/bloc/todos_history_bloc.dart';
import '../widgets/task_widget_deleted.dart';

class ToDoListHistoryPage extends StatelessWidget {
  const ToDoListHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosHistoryBloc(
        todosHistoryRepository: context.read<TodosHistoryRepository>(),
      )..add(
          const TodosHistorySubscriptionRequested(),
        ),
      child: const ToDoListHistoryPageContent(),
    );
  }
}

class ToDoListHistoryPageContent extends StatelessWidget {
  const ToDoListHistoryPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: naturalWhite,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset("assets/icons/arrow_back.png", width: 24),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.5 - 48 - 74.5,
                  ),
                  child: Text(
                    "Task History",
                    style: mainSubTitle,
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight(32, context)),
            BlocBuilder<TodosHistoryBloc, TodosHistoryState>(
              builder: (context, state) {
                if (state.todos.isNotEmpty) {
                  return MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        for (final taskModel in state.todos)
                          TaskWidgetDeleted(
                            taskModel: taskModel,
                            onTap: () {
                              context.read<TodosHistoryBloc>().add(
                                    TodosHistoryTodoDeleted(
                                      taskModel,
                                    ),
                                  );
                            },
                          )
                      ],
                    ),
                  );
                } else {
                  return const SizedBox(
                    height: 70,
                    child: Center(
                      child: Text(
                        'Task history empty',
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
          ],
        ),
      ),
    );
  }
}
