import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/routes/route_name.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../../authentication/data/repositories/auth_repository.dart';
import '../../../authentication/data/repositories/local_auth_repository.dart';
import '../../../habit/domain/habits_repository.dart';
import '../../../pomodoro/domain/pomodoros_repository.dart';
import '../../../todolist/domain/todos_history_repository.dart';
import '../../../todolist/domain/todos_repository.dart';
import '../../domian/save_backup_repository.dart';
import '../bloc/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(
        authRepository: context.read<AuthRepository>(),
        localUserDataRepository: context.read<LocalUserDataRepository>(),
        saveBackupRepository: context.read<SaveBackupRepository>(),
        pomodorosRepository: context.read<PomodorosRepository>(),
        habitsRepository: context.read<HabitsRepository>(),
        todosRepository: context.read<TodosRepository>(),
        todosHistoryRepository: context.read<TodosHistoryRepository>(),
      ),
      child: const SettingsPageContent(),
    );
  }
}

class SettingsPageContent extends StatelessWidget {
  const SettingsPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: naturalWhite,
      body: BlocListener<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state.logoutStatus == LogoutStatus.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                ),
              );
          } else if (state.logoutStatus == LogoutStatus.success) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteName.LOGIN,
              (route) => false,
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        Image.asset("assets/icons/arrow_back.png", width: 24),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.5 - 48 - 50,
                    ),
                    child: Text(
                      "Settings",
                      style: mainSubTitle,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getHeight(51, context)),
              Row(
                children: [
                  Text(
                    "Last backup:",
                    style: textParagraph.copyWith(fontSize: 11),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return Text(
                        (state.updatedAt != DateTime(0))
                            ? DateFormat('EEEE, dd MMMM y,')
                                .add_jm()
                                .format(state.updatedAt)
                            : "No Updated",
                        style: textParagraph.copyWith(fontSize: 11),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: getHeight(10, context),
              ),
              GestureDetector(
                onTap: () {
                  context.read<SettingsCubit>().backupData();
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: naturalWhite,
                    border: Border.all(color: naturalBlack, width: 0.5),
                  ),
                  child: BlocConsumer<SettingsCubit, SettingsState>(
                    listener: (context, state) {
                      if (state.backupStatus == BackupStatus.success) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text("Backup success"),
                            ),
                          );
                      } else if (state.backupStatus == BackupStatus.success) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text("Error: Unexpected"),
                            ),
                          );
                      }
                    },
                    builder: (context, state) {
                      if (state.backupStatus == BackupStatus.initial) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cached),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Backup",
                              style: buttonSmall,
                            ),
                          ],
                        );
                      } else if (state.backupStatus ==
                          BackupStatus.processing) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: naturalBlack,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Loading",
                              style: buttonSmall.copyWith(
                                color: naturalBlack,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cached),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Backup",
                              style: buttonSmall,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: getHeight(15, context),
              ),
              GestureDetector(
                onTap: () {
                  context.read<SettingsCubit>().logOut();
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: redLight,
                  ),
                  child: BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      if (state.logoutStatus == LogoutStatus.initial) {
                        return Center(
                          child: Text(
                            "Logout",
                            style: buttonSmall.copyWith(
                              color: naturalWhite,
                            ),
                          ),
                        );
                      } else if (state.logoutStatus ==
                          LogoutStatus.processing) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: naturalWhite,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Loading",
                              style: buttonSmall.copyWith(
                                color: naturalWhite,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: Text(
                            "Logout",
                            style: buttonSmall.copyWith(
                              color: naturalWhite,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
