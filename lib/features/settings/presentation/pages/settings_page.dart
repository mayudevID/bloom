import 'package:bloom/core/routes/route_name.dart';
import 'package:bloom/features/authentication/data/repositories/auth_repository.dart';
import 'package:bloom/features/settings/presentation/bloc/logout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../../authentication/data/repositories/local_auth_repository.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return LogoutCubit(
          context.read<AuthRepository>(),
          context.read<LocalUserDataRepository>(),
        );
      },
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
      body: Container(
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
                  child: Image.asset("assets/icons/arrow_back.png", width: 24),
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
                Text(
                  DateFormat('EEEE, dd MMMM y,')
                      .add_jm()
                      .format(DateTime.now()),
                  style: textParagraph.copyWith(fontSize: 11),
                ),
              ],
            ),
            SizedBox(
              height: getHeight(10, context),
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: naturalWhite,
                border: Border.all(color: naturalBlack, width: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cached),
                  const SizedBox(
                    width: 5,
                  ),
                  Text("Backup", style: buttonSmall),
                ],
              ),
            ),
            SizedBox(
              height: getHeight(15, context),
            ),
            GestureDetector(
              onTap: () async {
                await context.read<LogoutCubit>().logOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteName.LOGIN,
                  (route) => false,
                );
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: redLight,
                ),
                child: BlocBuilder<LogoutCubit, LogoutState>(
                  builder: (context, state) {
                    if (state.status == LogoutStatus.initial) {
                      return Center(
                        child: Text(
                          "Logout",
                          style: buttonSmall.copyWith(
                            color: naturalWhite,
                          ),
                        ),
                      );
                    } else if (state.status == LogoutStatus.processing) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child:
                                CircularProgressIndicator(color: naturalWhite),
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
                      return Text(
                        "Loading",
                        style: buttonSmall.copyWith(
                          color: naturalWhite,
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
    );
  }
}
