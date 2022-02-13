import 'package:bloom/controllers/user_controller.dart';
import 'package:bloom/models/habit.dart';
import 'package:bloom/models/task.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:bloom/theme.dart';
import 'package:bloom/widgets/habit_widget.dart';
import 'package:bloom/widgets/task_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../controllers/auth_controller.dart';
import '../../utils.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final userController = Get.find<UserController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: naturalWhite,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.07),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.toNamed(RouteName.PROFILE),
                    child: StreamBuilder<User?>(
                      stream: authController.streamAuthStatus,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          User user = snapshot.data as User;
                          return CachedNetworkImage(
                            imageUrl: user.photoURL as String,
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
                            width: 80.0,
                            height: 80.0,
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
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
                        Obx(() {
                          return Text(
                            userController.userModel.value.name.toString(),
                            style: smallTextLink,
                          );
                        }),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteName.SETTINGS);
                    },
                    child: Image.asset(
                      "assets/icons/settings.png",
                      width: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                DateFormat('EEEE, dd MMMM y').format(DateTime.now()),
                style: buttonSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'Upcoming Task',
                style: smallTextLink,
              ),
              const SizedBox(height: 7),
              FutureBuilder(
                future: Hive.openBox('task_db'),
                builder: (builder, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      var taskDb = Hive.box('task_db');
                      return ValueListenableBuilder(
                        valueListenable: taskDb.listenable(),
                        builder: (context, value, child) {
                          Map<int, TaskModel?> sortedTask =
                              sortTaskByDate(taskDb);
                          if (sortedTask.isEmpty) {
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
                                itemCount: sortedTask.length,
                                itemBuilder: (context, idx) {
                                  return TaskWidget(
                                    taskModel: sortedTask.values.elementAt(idx),
                                    index: sortedTask.keys.elementAt(idx),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      );
                    }
                  } else {
                    return const SizedBox(
                      height: 70,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 25),
              Text("Todays Habit", style: smallTextLink),
              const SizedBox(height: 8),
              FutureBuilder(
                future: Hive.openBox('habit_db'),
                builder: (builder, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      var habitDb = Hive.box('habit_db');
                      return ValueListenableBuilder(
                        valueListenable: habitDb.listenable(),
                        builder: (context, value, child) {
                          Map<int, HabitModel?> sortedHabit =
                              sortHabitByDate(habitDb);
                          if (sortedHabit.isEmpty) {
                            return const SizedBox(
                              height: 70,
                              child: Center(
                                child: Text(
                                  'Habit empty for today',
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
                                itemCount: sortedHabit.length,
                                itemBuilder: (context, idx) {
                                  return HabitWidget(
                                    habitModel:
                                        sortedHabit.values.elementAt(idx),
                                    index: sortedHabit.keys.elementAt(idx),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      );
                    }
                  } else {
                    return const SizedBox(
                      height: 70,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
