import 'package:bloom/features/todolist/domain/todos_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../bloc/add_todo/add_todo_cubit.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddTodoCubit(context.read<TodosRepository>()),
      child: const AddTaskPageContent(),
    );
  }
}

class AddTaskPageContent extends StatelessWidget {
  const AddTaskPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = context.select((AddTodoCubit cubit) => cubit.state.title);
    Future<DateTime> _getTime() async {
      TimeOfDay? pickedTime;
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), // Refer step 1
        firstDate: DateTime(DateTime.now().year), // Refer step 2
        lastDate: DateTime.now().add(const Duration(days: 365)), // Refer step 2
        selectableDayPredicate: decideWhichDayToEnable,
      );
      if (pickedDate != null) {
        pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
      }
      if (pickedDate != null && pickedTime != null) {
        return DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
            pickedTime.hour, pickedTime.minute);
      } else {
        return DateTime(1970);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: naturalWhite,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Text("New Task", style: mainSubTitle),
            SizedBox(height: getHeight(32, context)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Title", style: textParagraph),
            ),
            SizedBox(height: getHeight(4, context)),
            Container(
              padding: const EdgeInsets.all(5),
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: greyLight,
              ),
              child: BlocBuilder<AddTodoCubit, AddTodoState>(
                buildWhen: (previous, current) {
                  return previous.title != current.title;
                },
                builder: (context, state) {
                  return TextFormField(
                    onChanged: (val) {
                      context.read<AddTodoCubit>().titleChanged(val);
                    },
                    style: textForm,
                    cursorColor: naturalBlack,
                    decoration: InputDecoration.collapsed(
                      hintText: "Input title",
                      hintStyle: textForm.copyWith(color: greyDark),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: getHeight(16, context)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Description", style: textParagraph),
            ),
            SizedBox(height: getHeight(4, context)),
            Container(
              padding: const EdgeInsets.all(5),
              height: 96,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: greyLight,
              ),
              child: BlocBuilder<AddTodoCubit, AddTodoState>(
                buildWhen: (previous, current) {
                  return previous.description != current.description;
                },
                builder: (context, state) {
                  return TextFormField(
                    onChanged: (val) {
                      context.read<AddTodoCubit>().descriptionChanged(val);
                    },
                    style: textForm,
                    maxLines: 5,
                    maxLength: 1000,
                    cursorColor: naturalBlack,
                    decoration: InputDecoration.collapsed(
                      hintText: "Input description",
                      hintStyle: textForm.copyWith(color: greyDark),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: getHeight(16, context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Time", style: textParagraph),
                SizedBox(
                  width: 34,
                  height: 20,
                  child: BlocBuilder<AddTodoCubit, AddTodoState>(
                    builder: (context, state) {
                      return Switch(
                        inactiveTrackColor: greyLight,
                        inactiveThumbColor: greyDark,
                        activeColor: naturalBlack,
                        value: state.isTime,
                        onChanged: (val) {
                          context.read<AddTodoCubit>().isTimeChanged(val);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight(8, context)),
            BlocBuilder<AddTodoCubit, AddTodoState>(
              builder: (context, state) {
                if (state.isTime) {
                  if (state.isChoose) {
                    return GestureDetector(
                      onTap: () async {
                        var pick = await _getTime();
                        if (pick != DateTime(1970)) {
                          context.read<AddTodoCubit>().timeChanged(pick);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: greyLight,
                            ),
                            child: Center(
                              child: Text(
                                DateFormat('E, dd MMM y')
                                    .format(state.dateTime),
                                style: smallText,
                              ),
                            ),
                          ),
                          SizedBox(width: getWidth(8, context)),
                          Container(
                            width: 120,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: greyLight,
                            ),
                            child: Center(
                              child: Text(
                                DateFormat('jm').format(state.dateTime),
                                style: smallText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () async {
                        var pick = await _getTime();
                        if (pick != DateTime(1970)) {
                          context.read<AddTodoCubit>().timeChanged(pick);
                        }
                      },
                      child: Container(
                        width: 278,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: greyLight,
                        ),
                        child:
                            Center(child: Text("Pick time", style: smallText)),
                      ),
                    );
                  }
                } else {
                  return Container();
                }
              },
            ),
            // Obx(() {
            //   if (addTaskC.isTime.value) {
            //     if (addTaskC.isChoose.value) {
            //       return GestureDetector(
            //         onTap: () {
            //           pickTime();
            //         },
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Container(
            //               width: 150,
            //               height: 32,
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(5),
            //                 color: greyLight,
            //               ),
            //               child: Center(
            //                 child: Text(
            //                   DateFormat('E, dd MMM y')
            //                       .format(addTaskC.dateChoose.value),
            //                   style: smallText,
            //                 ),
            //               ),
            //             ),
            //             SizedBox(width: getWidth(8)),
            //             Container(
            //               width: 120,
            //               height: 32,
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(5),
            //                 color: greyLight,
            //               ),
            //               child: Center(
            //                 child: Text(
            //                   DateFormat('jm')
            //                       .format(addTaskC.dateChoose.value),
            //                   style: smallText,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       );
            //     } else {
            //       return GestureDetector(
            //         onTap: () {
            //           pickTime();
            //         },
            //         child: Container(
            //           width: 278,
            //           height: 32,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(5),
            //             color: greyLight,
            //           ),
            //           child: Center(child: Text("Pick time", style: smallText)),
            //         ),
            //       );
            //     }
            //   } else {
            //     return Container();
            //   }
            // }),
            SizedBox(height: getHeight(24, context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Repeat", style: textParagraph),
                Container(
                  width: 122,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: greyLight,
                  ),
                  child: Center(
                    child: Text(
                      "None",
                      style: interBold12.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: getHeight(16, context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tags", style: textParagraph),
                Container(
                  width: 122,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: greyLight,
                  ),
                  child: BlocBuilder<AddTodoCubit, AddTodoState>(
                    builder: (context, state) {
                      return Center(
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(10),
                          // icon: const Visibility(
                          //   visible: false,
                          //   child: Icon(Icons.arrow_downward),
                          // ),
                          value: state.tags,
                          items: ['Basic', 'Important'].map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: interBold12.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            context
                                .read<AddTodoCubit>()
                                .tagsChanged(newVal as String);
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                if (title.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please input the name of habit",
                      ),
                    ),
                  );
                } else {
                  context.read<AddTodoCubit>().saveTodo();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Habits Added",
                      ),
                    ),
                  );
                }
                //_saveTask();
              },
              child: Container(
                width: 202,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: naturalBlack,
                ),
                child: Center(
                  child: Text(
                    "Save",
                    style: buttonSmall.copyWith(
                      color: naturalWhite,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: getHeight(16, context)),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: textParagraph),
            ),
            SizedBox(height: getHeight(72, context)),
          ],
        ),
      ),
    );
  }
}
