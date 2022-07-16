import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/function.dart';
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
      body: Container(
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
                Image.asset("assets/icons/share.png", width: 24),
                SizedBox(width: getWidth(16, context)),
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
            SizedBox(height: getHeight(40, context)),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  color:
                      (initTaskModel.tags == 'Basic') ? greenAction : redAction,
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
            SizedBox(height: getHeight(8, context)),
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
            SizedBox(height: getHeight(16, context)),
            Row(
              children: [
                Image.asset("assets/icons/calendar_unselect.png", width: 16),
                SizedBox(width: getWidth(4, context)),
                Text(
                  DateFormat('EEEE, dd MMMM y').format(initTaskModel.dateTime),
                  style: interBold12.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight(8, context)),
            Row(
              children: [
                Image.asset("assets/icons/clock.png", width: 16),
                SizedBox(width: getWidth(4, context)),
                Text(
                  DateFormat('jm').format(initTaskModel.dateTime),
                  style: interBold12.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight(24, context)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Description",
                style: buttonSmall,
              ),
            ),
            SizedBox(height: getHeight(4, context)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                (initTaskModel.description.isEmpty)
                    ? "No Description"
                    : initTaskModel.description,
                style: interBold12.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
