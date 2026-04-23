import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/routes/route_name.dart';
import '../../../../core/utils/theme.dart';
import '../../data/models/task_model.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({
    Key? key,
    required this.initTaskModel,
  }) : super(key: key);
  final TaskModel initTaskModel;

  @override
  Widget build(BuildContext context) {
    return TaskDetailPageContent(initTaskModel: initTaskModel);
  }
}

class TaskDetailPageContent extends StatelessWidget {
  const TaskDetailPageContent({
    Key? key,
    required this.initTaskModel,
  }) : super(key: key);
  final TaskModel initTaskModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellowLight,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Navigator.of(context).pop(false);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Image.asset(
                      "assets/icons/arrow_back.png",
                      width: 24,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      final isChecked =
                          (initTaskModel.isChecked) ? "Finished" : "Unfinished";
                      SharePlus.instance.share(
                        ShareParams(
                          text: '''
                        To-do list: ${initTaskModel.title}
                        Time: ${initTaskModel.dateTime}
                        ${initTaskModel.tags} Task

                        ${initTaskModel.description}

                        Status: $isChecked
                      ''',
                        ),
                      );
                    },
                    child: Image.asset(
                      "assets/icons/share.png",
                      width: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop(true);
                    },
                    child: Image.asset(
                      "assets/icons/delete.png",
                      width: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 60,
                  height: 20,
                  decoration: BoxDecoration(
                    color: (initTaskModel.tags == 'Basic')
                        ? greenAction
                        : redAction,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      initTaskModel.tags,
                      style: smallTextLink.copyWith(
                        fontSize: 8,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  initTaskModel.title,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Image.asset("assets/icons/calendar_unselect.png", width: 16),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('EEEE, dd MMMM y')
                        .format(initTaskModel.dateTime),
                    style: interBold12.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.asset("assets/icons/clock.png", width: 16),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('jm').format(initTaskModel.dateTime),
                    style: interBold12.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Description",
                  style: buttonSmall,
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    (initTaskModel.description.isEmpty)
                        ? "No Description"
                        : initTaskModel.description,
                    style: interBold12.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      RouteName.EDITTASK,
                      arguments: initTaskModel,
                    );
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
                        "Edit",
                        style: buttonSmall.copyWith(
                          color: naturalWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 109,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
