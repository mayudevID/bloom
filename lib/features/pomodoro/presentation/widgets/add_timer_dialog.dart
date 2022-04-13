import 'package:bloom/features/pomodoro/presentation/bloc/add_pomodoro/add_pomodoro_cubit.dart';
import 'package:bloom/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';

class AddTimerDialog extends StatelessWidget {
  const AddTimerDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddPomodoroCubit>(),
      child: Dialog(
        insetPadding: const EdgeInsets.all(20),
        child: BlocListener<AddPomodoroCubit, AddPomodoroState>(
          listener: (context, state) {
            if (state.status == AddPomodoroStatus.success) {
              Navigator.of(context).pop();
            } else if (state.status == AddPomodoroStatus.error) {
              //showErrorDialog(context, state.errorMessage);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SizedBox(height: getHeight(5, context)),
              Text("Title", style: smallTextLink),
              SizedBox(height: getHeight(10, context)),
              Container(
                height: 35,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: naturalBlack),
                ),
                child: BlocBuilder<AddPomodoroCubit, AddPomodoroState>(
                  buildWhen: (previous, current) {
                    return previous.title != current.title;
                  },
                  builder: (context, state) {
                    return TextFormField(
                      onChanged: (val) {
                        context.read<AddPomodoroCubit>().titleChanged(val);
                      },
                      maxLength: 25,
                      buildCounter: (BuildContext context,
                          {int? currentLength,
                          int? maxLength,
                          bool? isFocused}) {
                        return null;
                      },
                      autofocus: true,
                      style: textForm,
                      cursorColor: naturalBlack,
                      decoration: InputDecoration.collapsed(
                        hintText: "Add Title",
                        hintStyle: textForm.copyWith(color: greyDark),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: getHeight(10, context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Duration\n(in Minutes)", style: smallTextLink),
                  BlocBuilder<AddPomodoroCubit, AddPomodoroState>(
                    buildWhen: (previous, current) {
                      return previous.duration != current.duration;
                    },
                    builder: (context, state) {
                      return NumberPicker(
                        itemWidth: 35,
                        textStyle: textParagraph.copyWith(
                          fontWeight: FontWeight.w600,
                          color: naturalBlack,
                        ),
                        selectedTextStyle: textParagraph.copyWith(
                          fontWeight: FontWeight.w600,
                          color: naturalBlack,
                          fontSize: 18,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: naturalBlack),
                        ),
                        axis: Axis.horizontal,
                        minValue: 5,
                        maxValue: 45,
                        value: state.duration,
                        onChanged: (value) {
                          context
                              .read<AddPomodoroCubit>()
                              .durationChanged(value);
                        },
                        step: 5,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: getHeight(10, context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Session(s)", style: smallTextLink),
                  BlocBuilder<AddPomodoroCubit, AddPomodoroState>(
                    buildWhen: (previous, current) {
                      return previous.session != current.session;
                    },
                    builder: (context, state) {
                      return NumberPicker(
                        itemWidth: 35,
                        textStyle: textParagraph.copyWith(
                          fontWeight: FontWeight.w600,
                          color: naturalBlack,
                        ),
                        selectedTextStyle: textParagraph.copyWith(
                          fontWeight: FontWeight.w600,
                          color: naturalBlack,
                          fontSize: 18,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: naturalBlack),
                        ),
                        axis: Axis.horizontal,
                        minValue: 1,
                        maxValue: 5,
                        value: state.session,
                        onChanged: (value) {
                          context
                              .read<AddPomodoroCubit>()
                              .sessionChanged(value);
                        },
                        step: 1,
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      context.read<AddPomodoroCubit>().addPomodoro();
                    },
                    child: Container(
                      width: 70,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: naturalBlack,
                      ),
                      child: Center(
                        child: Text(
                          'Add',
                          style: buttonSmall.copyWith(
                            color: naturalWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 70,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: naturalBlack,
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: buttonSmall.copyWith(
                            color: naturalWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// if (addPomodoroController.titleController.text.isNotEmpty) {
                  //   var pomodoroDb = await Hive.openBox('pomodoro_db');
                  //   pomodoroDb.add(
                  //     PomodoroModel(
                  //       pomodoroId: getRandomId(),
                  //       title:
                  //           addPomodoroController.titleController.text.trim(),
                  //       durationMinutes:
                  //           addPomodoroController.valueDuration.value,
                  //       session: addPomodoroController.valueSessions.value,
                  //     ),
                  //   );
                  //   Get.delete<AddPomodoroController>();
                  //   Get.back();
                  //   if (pomodoroDb.length != 1) {
                  //     scrollController.scrollTo(
                  //       index: pomodoroDb.length - 1,
                  //       duration: const Duration(seconds: 1),
                  //     );
                  //   }
                  //   Get.snackbar(
                  //     "Timer Added",
                  //     "\"${addPomodoroController.titleController.text}\" added to My Timer",
                  //     colorText: naturalWhite,
                  //     snackPosition: SnackPosition.BOTTOM,
                  //     margin: const EdgeInsets.only(
                  //       bottom: 80,
                  //       left: 30,
                  //       right: 30,
                  //     ),
                  //     backgroundColor: naturalBlack,
                  //     animationDuration: const Duration(milliseconds: 100),
                  //     forwardAnimationCurve: Curves.fastOutSlowIn,
                  //     reverseAnimationCurve: Curves.fastOutSlowIn,
                  //   );
                  // } else {
                  //   Get.snackbar(
                  //     "Empty Title",
                  //     "Enter the title first",
                  //     colorText: naturalWhite,
                  //     snackPosition: SnackPosition.BOTTOM,
                  //     margin: const EdgeInsets.only(
                  //       bottom: 40,
                  //       left: 30,
                  //       right: 30,
                  //     ),
                  //     backgroundColor: naturalBlack,
                  //     animationDuration: const Duration(milliseconds: 100),
                  //     forwardAnimationCurve: Curves.fastOutSlowIn,
                  //     reverseAnimationCurve: Curves.fastOutSlowIn,
                  //   );
                  // }